CREATE TABLE IF NOT EXISTS garage_vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner VARCHAR(50) NOT NULL,
    plate VARCHAR(10) NOT NULL,
    vehicle_model VARCHAR(50) NOT NULL,
    garage_name VARCHAR(50) NOT NULL,
    stored INT DEFAULT 1,
    UNIQUE KEY unique_plate (plate)
);