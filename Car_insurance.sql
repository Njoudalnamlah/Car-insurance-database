DROP TABLE IF EXISTS Car_accident;
DROP TABLE IF EXISTS Accident;
DROP TABLE IF EXISTS Insurance;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(15),
    birth_date DATE,
    license VARCHAR(20)
);

CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    position VARCHAR(30),
    phone VARCHAR(15),
    gender VARCHAR(10),
    department_id INT
);

CREATE TABLE Car (
    plate_number INT PRIMARY KEY,
    customer_id INT,
    brand VARCHAR(50),
    year INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Insurance (
    policy_number INT PRIMARY KEY,
    start_date DATE,
    end_date DATE,
    insurance_type VARCHAR(10),
    plate_number INT,
    employee_id INT,
    FOREIGN KEY (plate_number) REFERENCES Car(plate_number),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

CREATE TABLE Accident (
    accident_id INT PRIMARY KEY,
    accident_date DATE,
    description VARCHAR(100),
    location VARCHAR(50)
);

CREATE TABLE Car_accident (
    accident_id INT,
    plate_number INT,
    PRIMARY KEY (accident_id, plate_number),
    FOREIGN KEY (accident_id) REFERENCES Accident(accident_id),
    FOREIGN KEY (plate_number) REFERENCES Car(plate_number)
);

INSERT INTO Customer VALUES
(11, 'Ahmed', '0565755466', '2001-07-13', '15889e'),
(22, 'Noor', '0555478290', '2020-01-14', '15868d'),
(33, 'Rana', '0556471444', '2015-07-12', '14188f'),
(44, 'Lama', '0553478065', '2017-12-30', '14363u'),
(55, 'Ali', '0556547421', '2018-07-17', '13886o'),
(66, 'Sara', '0567742116', '2022-02-07', '13289w');

INSERT INTO Employee VALUES
(2479, 'Rana', 'HR', '0533450745', 'Female', 3),
(9352, 'Reema', 'Manager', '0564657890', 'Female', 2),
(1157, 'Abdullah', 'CEO', '0511478955', 'Male', 1),
(3792, 'Nora', 'IS', '0512748993', 'Female', 3),
(1199, 'Mohammed', 'Marketing', '0523894577', 'Male', 2),
(4681, 'Asma', 'Sales', '0519825400', 'Female', 2);

INSERT INTO Car VALUES
(83262, 11, 'BMW', 2020),
(64829, 22, 'KIA', 2017),
(73957, 33, 'RANGE ROVER', 2021),
(25372, 44, 'HYUNDAI', 2013),
(27030, 55, 'MERCEDES', 2022),
(92436, 66, 'TOYOTA', 2019);

INSERT INTO Insurance VALUES
(1824, '2020-10-31', '2021-10-31', 'VIP', 83262, 2479),
(3425, '2017-06-15', '2018-06-15', 'C', 64829, 9352),
(5262, '2021-02-07', '2022-02-07', 'A', 73957, 1157),
(8261, '2018-07-25', '2019-07-25', 'C', 25372, 3792),
(2721, '2012-08-09', '2013-08-09', 'VIP', 27030, 1199),
(4951, '2015-12-30', '2016-12-30', 'A', 92436, 4681);

INSERT INTO Accident VALUES
(410, '2020-09-01', 'Sideswipe', 'Riyadh'),
(411, '2018-02-01', 'Rear Impact', 'Khober'),
(412, '2021-03-01', 'Crashed Into Wall', 'Makkah'),
(413, '2022-07-01', 'Crash Into Tree', 'Jaddah'),
(414, '2019-10-01', 'Drowning Car', 'Riyadh'),
(415, '2020-05-01', 'Burning Car', 'Qassim');

INSERT INTO Car_accident VALUES
(410, 83262),
(411, 64829),
(412, 73957),
(413, 25372),
(414, 27030),
(415, 92436);

CREATE INDEX idx_customer_license ON Customer(license);
CREATE INDEX idx_accident_description ON Accident(description);

DELIMITER //

CREATE PROCEDURE check_car_insurance(IN plate_no INT)
BEGIN
    DECLARE cnt INT;
    SELECT COUNT(*) INTO cnt FROM Insurance WHERE plate_number = plate_no;
    IF cnt > 0 THEN
        SELECT '✅ This car has an active insurance.' AS message;
    ELSE
        SELECT '❌ This car does NOT have any insurance!' AS message;
    END IF;
END;
//

CREATE FUNCTION get_total_accidents(plate_no INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Car_accident WHERE plate_number = plate_no;
    RETURN total;
END;
//

CREATE PROCEDURE validate_policy_number(IN policy_no INT)
BEGIN
    DECLARE cnt INT;
    SELECT COUNT(*) INTO cnt FROM Insurance WHERE policy_number = policy_no;
    IF cnt > 0 THEN
        SELECT '❌ This Policy Number is already in use!' AS message;
    ELSE
        SELECT '✅ This Policy Number is available.' AS message;
    END IF;
END;
//

CREATE TRIGGER trg_check_year
BEFORE UPDATE ON Car
FOR EACH ROW
BEGIN
    IF NEW.year > 2022 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '❌ Invalid year! Car year cannot be greater than 2022.';
    END IF;
END;
//

CREATE TRIGGER trg_check_insurance_end_date
BEFORE INSERT ON Insurance
FOR EACH ROW
BEGIN
    IF NEW.end_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '❌ Insurance is expired!';
    END IF;
END;
//

DELIMITER ;
