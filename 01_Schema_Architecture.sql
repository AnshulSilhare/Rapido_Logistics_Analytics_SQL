create database rapido_logistics_db;
Use rapido_logistics_db;

Create Table Staging_Rapido (
    Booking_ID Varchar(50),
    Booking_Status Varchar(50),
    Booking_Value Decimal(10, 2),
    Customer_ID Varchar(50),
    Driver_ID Varchar(50),
    Pickup_Location Varchar(100),
    Drop_Location Varchar(100),
    Ride_Distance_km Decimal(10, 2),
    Ride_Time_min Int,              
    Date_Ride Text,                 
    Time_Ride Text,                
    Vehicle_Type Varchar(50),
    Vehicle_Image Varchar(255),
    Payment_Method Varchar(50),
    Customer_Rating Decimal(3, 1),
    Driver_Rating Decimal(3, 1),
    Canceled_Rides_by_Customer Int,
    Canceled_Rides_by_Driver Int,
    Incomplete_Rides Int,
    Incomplete_Rides_Reason Varchar(255),
    Total_Bookings Int,
    Canceled_Bookings Int,
    Canceled_Percentage Decimal(5, 2),
    V_TAT Int,
    C_TAT Int  );
    
    SELECT COUNT(*) FROM Staging_Rapido;

-- ------------------------------------------------- --
# DIMENSION TABLES

-- 1. Customers Dimension
Create Table Dim_Customers (
    customer_id Varchar(50) Primary Key,
    avg_rating Decimal(3,1));

-- 2. Drivers Dimension
Create Table Dim_Drivers (
	driver_id Varchar(50) primary Key,
    avg_rating decimal(3,1));

-- 3. Vehicles Dimension
Create Table Dim_Vehicles (
    vehicle_id int auto_increment Primary Key,
    vehicle_type Varchar(50) Unique,
    vehicle_image_url varchar(255));

-- 4. Locations Dimension (city)
Create Table Dim_Locations (
    location_id Int Auto_Increment Primary Key,
    city_name Varchar(100) unique);

-- 5. Payment Methods Dimension
Create Table Dim_Payment_Methods (
    payment_id Int auto_increment Primary Key,
    method_name Varchar(50) Unique);

-- 6. Date Dimension
Create Table Dim_Date (
    date_val date primary Key,
    year_val Int,
    month_val varchar(20),
    day_val Varchar(20),
    quarter_val Int);

-- --- FACT TABLES ---

-- 7. Fact_Bookings 
Create Table Fact_Bookings (
    booking_id Varchar(50) Primary Key,
    customer_id Varchar(50),
    driver_id Varchar(50),
    vehicle_id Int,
    pickup_loc_id Int,
    drop_loc_id Int,
    payment_id Int,
    date_val Date,
    booking_time Time,
    booking_value Decimal(10,2),
    ride_distance_km Decimal(10,2),
    ride_time_min Int,
    v_tat Int,
    c_tat Int,
    booking_status Varchar(50),
    
    Foreign Key (customer_id) References Dim_Customers(customer_id),
    Foreign Key (driver_id) References Dim_Drivers(driver_id),
    Foreign Key (vehicle_id) References Dim_Vehicles(vehicle_id),
    Foreign Key (pickup_loc_id) References Dim_Locations(location_id),
    Foreign Key (drop_loc_id) References Dim_Locations(location_id),
    Foreign Key (payment_id) References Dim_Payment_Methods(payment_id),
    Foreign Key (date_val) References Dim_Date(date_val));

-- 8. Fact_Incomplete_logs_table
Create Table Fact_Incomplete_Logs (
    log_id Int Auto_Increment Primary Key,
    booking_id Varchar(50),
    incomplete_reason Varchar(255),
    Foreign Key (booking_id) References Fact_Bookings(booking_id));
    
