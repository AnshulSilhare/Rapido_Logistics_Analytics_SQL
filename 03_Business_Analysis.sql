# 1. Calculating Revenue Leakage from Operational Friction
-- Identified 251.9K revenue leakage

Select 
    booking_status,
    Count(booking_id) as Total_Rides,
    Sum(booking_value) as Revenue_Leakage
From Fact_Bookings
Where booking_status IN ('Incomplete', 'Canceled_by_Driver', 'Canceled_by_Customer')
Group By booking_status;


#2. Business Problem: Are specific drivers habitually cancelling rides, or is it random?
-- Objective: Identify "High-Risk" Drivers with > 5 Cancellations
-- Resume potential: "Identified 15 repeat offenders accounting for 40% of driver-side cancellations."

Select d.driver_id, Count(f.booking_id) as Total_Cancellations, avg(d.avg_rating) as Driver_Rating
from Fact_Bookings f
Join Dim_Drivers d on f.driver_id = d.driver_id
Where f.cancelled_by = 'Driver'
group by d.driver_id
having Total_Cancellations > 5
Order by Total_Cancellations Desc;


# 3. Does the "Vehicle TAT" (Turnaround Time) get worse as the day progresses?
-- Objective: Analyze Operational Efficiency by Time of Day
-- Resume potential: "Pinpointed a 20% spike in TAT during Evening Peak (6-9 PM), recommending surge supply allocation."

select	case 
        when hour(booking_time) between 7 and 10 then 'Morning Peak'
        when hour(booking_time) between 11 and 16 then 'Afternoon Slump'
        when hour(booking_time) between 17 and 21 then 'Evening Peak'
        else 'Night'
    end as Time_Slot,
    avg(v_tat) as Avg_Vehicle_Turnaround_Time,
    COUNT(booking_id) as Total_Rides
From Fact_Bookings
group By Time_Slot
order By Avg_Vehicle_Turnaround_Time Desc;


# 4. Business Question: "Are our drivers rejecting low-rated customers?"


-- Objective: Correlation between Customer Rating and Ride Incompletion
-- Insight: "Low-rated customers (< 3.5) face a 3x higher rejection rate."

Select Case 
	When c.avg_rating < 3.5 
		Then "Low Rated (< 3.5)"
	When c.avg_rating >= 3.5 And c.avg_rating < 4.5 Then 'Average (3.5 - 4.5)'
	Else 'Top Rated (> 4.5)'
    End As Customer_Segment,
    
    Count(f.booking_id) As Total_Requests,
    Sum(Case When f.booking_status = 'Incomplete' Then 1 Else 0 End) As Incomplete_Rides,
    Concat(Round((Sum(Case 
					When f.booking_status = 'Incomplete' 
					Then 1 Else 0 End) / Count(f.booking_id)) * 100, 2)," ", "%") As Failure_Rate
From Fact_Bookings f
join Dim_Customers c on f.customer_id = c.customer_id
group By Customer_Segment
Order By Failure_Rate Desc; 


# 5. Business Problem: Identify High-Friction Pickup Zones
-- Insight: "Flagged 'Pune' Zone as a high-risk origin with 15% cancellation rate despite high demand."

Select 
    pl.city_name As Pickup_Zone,
    Count(f.booking_id) As Total_Demand,
    
    -- Calculated Metrics
    Sum(Case When f.booking_status = 'Incomplete' Then 1 Else 0 End) As Failed_Pickups,
    Round(Avg(f.v_tat), 1) As Avg_Wait_Time,
    
    -- The "Friction" Metric
    Concat(Round((Sum(Case When f.booking_status = 'Incomplete' Then 1 Else 0 End) / Count(f.booking_id)) * 100, 1), '%') As Cancellation_Rate

From Fact_Bookings f
Join Dim_Locations pl On f.pickup_loc_id = pl.location_id
Group By Pickup_Zone
Having Total_Demand > 100 -- Filter for significant zones
Order By Failed_Pickups Desc;