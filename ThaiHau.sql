DROP	DATABASE	IF EXISTS	ThucTap;
CREATE	DATABASE	ThucTap;
USE	ThucTap;
CREATE TABLE Country (
  country_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  country_name VARCHAR(50) NOT NULL
);

CREATE TABLE Location (
  location_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  street_address VARCHAR(50),
  postal_code VARCHAR(20),
  country_id INT,
  FOREIGN KEY (country_id) REFERENCES Country(country_id) ON DELETE CASCADE
);

CREATE TABLE Employee (
  employee_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  location_id INT,
  FOREIGN KEY (location_id) REFERENCES Location(location_id) ON DELETE CASCADE
);

INSERT	INTO	`Country`(Country_Name)	VALUES
	('Vietnam'),
	('australia'),
	('america'),
	('Cambodia'),
	('England'),
	('Malaysia'),
	('Singapore'),
	('canada'),
	('Laos');
    
INSERT	INTO	Location(Street_Address, postal_code, country_id)	VALUES
	('hoang hoa tham','s001',1),
	('cau giay','s002',2),
	('tran duy hung','s003',3),
	('hoang mai','s004',4),
	('hoan kiem','s005',5);
    

INSERT	INTO	Employee(full_name, email, location_id)	VALUES
	('John Wick','email@gmail.com', 1),
	('Brack Obama','Brack@gmail.com',2),
	('Shinzao','Shinzao@gmail.com', 3),
	('JavanIV','Javan@gmail.com', 4),
	('Goole','nn03@gmail.com', 5),
	('Alaska','Alaska@gmail.com', 5);


-- A. Lấy ra tất cả nhân viên thuộc Việt Nam

SELECT employee_id, country_name FROM Employee
JOIN Location 
USING (location_id)
JOIN Country 
USING (country_id)
WHERE country_name = 'Vietnam';

-- B. Lấy ra tên quốc gia của employee có email là "nn03@gmail.com"

SELECT country_name FROM Country
JOIN Location
USING (country_id)
JOIN  Employee
USING (location_id)
WHERE email = 'nn03@gmail.com';

-- C.Thống kê mỗi country, mỗi location có bao nhiêu employee đang làm việc.

SELECT country_id, location_id, COUNT(*) sl
FROM Country
JOIN  Location
USING (country_id)
JOIN  Employee
USING (location_id)
GROUP BY country_id, location_id;

-- 3. Tạo trigger cho table Employee chỉ cho phép insert mỗi quốc gia có tối đa 10 employee

DROP TRIGGER IF EXISTS max_employee;

DELIMITER $$
CREATE TRIGGER max_employee
BEFORE INSERT ON Employee
FOR EACH ROW
 BEGIN
	DECLARE employee_count INT;
    SELECT COUNT(*) INTO employee_count 
    FROM Employee
    JOIN Location 
    USING (location_id) 
    JOIN Country 
    USING (country_id) WHERE location_id = NEW.location_id;
			IF		employee_count >= 10	THEN
			SIGNAL	SQLSTATE	'12345'
			SET	MESSAGE_TEXT	=	'Chỉ thêm được tối đa 10 nhân viên cho mỗi quốc gia';
			END IF;
    
 END $$
 DELIMITER ;
 
INSERT	INTO	Employee(full_name, email, location_id)	VALUES
	('binyd','hpemail@gmail.com', 1);

-- 4. Hãy cấu hình table sao cho khi xóa 1 location nào đó thì tất cả employee ở location đó sẽ có location_id = null

DROP TRIGGER IF EXISTS delete_location;

DELIMITER $$
CREATE TRIGGER delete_location
AFTER DELETE ON Location
FOR EACH ROW
 BEGIN
	
     UPDATE Employee SET location_id = NULL WHERE location_id = OLD.location_id;
     
 END $$
 DELIMITER ;
 


