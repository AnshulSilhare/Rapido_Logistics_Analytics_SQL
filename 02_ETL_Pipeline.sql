use rapido_logistics_db;

-- 1. Insert into Customers
Insert ignore Into Dim_Customers (customer_id, avg_rating)
Select Customer_ID, Avg(Customer_Rating)
	From Staging_Rapido
Group By Customer_ID;

-- 2. Insert into Drivers
Insert Ignore Into Dim_Drivers (driver_id, avg_rating)
Select Driver_ID, Avg(Driver_Rating)
From Staging_Rapido
	Group By Driver_ID;

-- 3. Insert into Vehicles
Insert ignore Into Dim_Vehicles (vehicle_type, vehicle_image_url)
select Distinct Vehicle_Type, Vehicle_Image
	from Staging_Rapido;

-- 4. Insert into Locations (Combining Pickup and Drop cities to get a full list)
Insert Ignore Into Dim_Locations (city_name)
Select Distinct Pickup_Location From Staging_Rapido
Union
Select Distinct Drop_Location From Staging_Rapido;

-- 5. Insert into Payment Methods
Insert Ignore Into Dim_Payment_Methods (method_name)
Select Distinct Payment_Method
From Staging_Rapido;

-- 6. Insert into Date Dimension
Insert ignore Into Dim_Date (date_val, year_val, month_val, day_val, quarter_val)
Select distinct 
    Str_To_Date(Date_Ride, '%Y-%m-%d'),
    Year(Str_To_Date(Date_Ride, '%Y-%m-%d')),
    MonthName(Str_To_Date(Date_Ride, '%Y-%m-%d')),
    DayName(Str_To_Date(Date_Ride, '%Y-%m-%d')),
    Quarter(Str_To_Date(Date_Ride, '%Y-%m-%d'))
From Staging_Rapido;

-- -------------------------------------------------------------------------------

# 1. Insert in the Main fact table - Fact_Bookings
Insert Ignore Into Fact_Bookings 
(   booking_id, 
    customer_id, 
    driver_id, 
    vehicle_id, 
    pickup_loc_id, 
    drop_loc_id, 
    payment_id, 
    date_val, 
    booking_time, 
    booking_value, 
    ride_distance_km, 
    ride_time_min, 
    v_tat, 
    c_tat, 
    booking_status)
    
Select 
    s.Booking_ID,
    s.Customer_ID,
    s.Driver_ID,
    v.vehicle_id,       
    pl.location_id,     
    dl.location_id, 
    pm.payment_id,      
    Str_To_Date(s.Date_Ride, '%Y-%m-%d'),
    s.Time_Ride,
    s.Booking_Value,
    s.Ride_Distance_km,
    s.Ride_Time_min,
    s.V_TAT,
    s.C_TAT,
    s.Booking_Status
From Staging_Rapido s
Left Join Dim_Vehicles v on s.Vehicle_Type = v.vehicle_type
left Join Dim_Locations pl On s.Pickup_Location = pl.city_name
Left Join Dim_Locations dl on s.Drop_Location = dl.city_name
Left Join Dim_Payment_Methods pm on s.Payment_Method = pm.method_name;

-- 2.Inserting Incomplete Logs
Insert Ignore Into Fact_Incomplete_Logs (booking_id, incomplete_reason)
Select Booking_ID, Incomplete_Rides_Reason
From Staging_Rapido
Where Incomplete_Rides = 1;

    
-- -------------------------------------------------------- --

-- 1. Adding missing column to Fact Table
Alter Table Fact_Bookings
Add Column cancelled_by Varchar(50);

-- 2. Update Driver Cancellations
Update Fact_Bookings f
Join Staging_Rapido s On f.booking_id = s.Booking_ID
Set f.cancelled_by = "Driver"
Where s.Canceled_Rides_by_Driver = 1;

-- 3. Update Customer Cancellations
Update Fact_Bookings f
Join Staging_Rapido s on f.booking_id = s.Booking_ID
Set f.cancelled_by = 'Customer'
Where s.Canceled_Rides_by_Customer = 1;

