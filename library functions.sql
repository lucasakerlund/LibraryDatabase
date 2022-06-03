DROP PROCEDURE IF EXISTS `loan_book`;
DELIMITER //
CREATE PROCEDURE `loan_book` (library_id INT, ISBN VARCHAR(255), customer_id INT, loan_date VARCHAR(10), return_date VARCHAR(10), OUT succeed INT)
BEGIN
	DECLARE `rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `rollback` = 1;
    
	START TRANSACTION;
		SET @bookId = "";
		SELECT
		b.`book_id`
		FROM `books` b
		WHERE 
		b.`isbn` = ISBN AND
        b.`library_id` = library_id AND
		NOT EXISTS(
			  SELECT NULL
			  FROM `loans` l
			  WHERE b.`book_id` = l.`book_id`) LIMIT 1
		INTO @bookId;
		INSERT INTO loans VALUES(@bookId, customer_id, loan_date, return_date);
        INSERT INTO `loans_history`(`book_id`, `customer_id`, `loan_date`, `return_date`) VALUES(@bookId, customer_id, loan_date, return_date);
        SET succeed = 1;
        IF `rollback` THEN
			ROLLBACK;
            SET succeed = 0;
		END IF;
    COMMIT;
END//

CALL `loan_book`(1, "9781387207770", 1, "","", @result);
SELECT @result;

DROP PROCEDURE IF EXISTS `get_books`;
DELIMITER //
CREATE PROCEDURE `get_books`()
BEGIN
	SELECT
    bd.*,
    (SELECT GROUP_CONCAT(`name`) FROM `books_with_authors` ba, `authors` a WHERE bd.`isbn` = ba.`isbn` AND ba.`author_id` = a.`author_id`) AS authors,
    (SELECT GROUP_CONCAT(`name`) FROM `books_with_genre` bg, `genre` g WHERE bd.`isbn` = bg.`isbn` AND bg.`genre_id` = g.`genre_id`) AS genres,
    (SELECT GROUP_CONCAT(DISTINCT l.`name`) FROM `libraries` l, `books` b WHERE bd.`isbn` = b.`isbn` AND b.`library_id` = l.`library_id` AND NOT EXISTS(SELECT * FROM `loans` l WHERE b.`book_id` = l.`book_id`)) AS available_libraries,
    (SELECT COUNT(*) FROM `loans_history` l, `books` b WHERE l.`book_id` = b.`book_id` AND b.`isbn` = bd.`isbn`) AS popular_all_time,
    (SELECT COUNT(*) FROM `loans_history` l, `books` b WHERE l.`book_id` = b.`book_id` AND b.`isbn` = bd.`isbn` AND l.`loan_date` > DATE_SUB(CURDATE(), INTERVAL 1 YEAR)) AS popular_year,
    (SELECT COUNT(*) FROM `loans_history` l, `books` b WHERE l.`book_id` = b.`book_id` AND b.`isbn` = bd.`isbn` AND l.`loan_date` > DATE_SUB(CURDATE(), INTERVAL 1 MONTH)) AS popular_month,
    (SELECT COUNT(*) FROM `loans_history` l, `books` b WHERE l.`book_id` = b.`book_id` AND b.`isbn` = bd.`isbn` AND l.`loan_date` > DATE_SUB(CURDATE(), INTERVAL 1 WEEK)) AS popular_week
    FROM `book_details` bd
    GROUP BY bd.`isbn`;
END //

CALL `get_books`();

DROP PROCEDURE IF EXISTS `add_book`;
DELIMITER //
CREATE PROCEDURE `add_book`(title VARCHAR(50), description VARCHAR(3000), authors VARCHAR(200), genres VARCHAR(200), isbn VARCHAR(20), published VARCHAR(10), page_count INT, language VARCHAR(50), image_source VARCHAR(500), OUT succeed INT)
BEGIN
	DECLARE `rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `rollback` = 1;

	START TRANSACTION;
		SET FOREIGN_KEY_CHECKS=0;
		INSERT INTO book_details VALUES(isbn, title, description, language, published, image_source, pages);
		-- authors
		SET @total_authors = LENGTH(authors) - LENGTH(REPLACE(authors, ",", ""))+1;
		SET @currentCount = 1;

		WHILE @currentCount <= @total_authors DO

			SET @author = SUBSTRING_INDEX(SUBSTRING_INDEX(authors, ',', @currentCount), ',', -1);
			SELECT `name` FROM `authors` WHERE `name` = @author INTO @exists;
			IF(@exists IS NULL) THEN
				INSERT INTO `authors`(`name`) VALUES(@author);
                SET @author_id = last_insert_id();
                INSERT INTO `books_with_authors` VALUES (isbn, @author_id);
			END IF;
			SET @currentCount = @currentCount + 1;
		END WHILE;
		-- genres
		SET @total_genres = LENGTH(genres) - LENGTH(REPLACE(genres, ",", ""))+1;
		SET @currentCount = 1;

		WHILE @currentCount <= @total_genres DO

			SET @genre = SUBSTRING_INDEX(SUBSTRING_INDEX(genres, ',', @currentCount), ',', -1);
			SELECT name FROM genre WHERE name = @genre INTO @exists;
			IF(@exists IS NULL) THEN
				INSERT INTO genre(name) VALUES(@genre);
                SET @genre_id = last_insert_id();
                INSERT INTO books_with_genre VALUES(isbn, @genre_id);
			END IF;
			SET @currentCount = @currentCount + 1;
		END WHILE;
        SET succeed = 1;
        IF `rollback` THEN
			ROLLBACK;
            SET succeed = 0;
		END IF;
        SET FOREIGN_KEY_CHECKS=1;
    COMMIT;
END //

DROP PROCEDURE IF EXISTS `add_copies`;
DELIMITER //
CREATE PROCEDURE `add_copies`(isbn VARCHAR(20), library_id INT, amount INT, OUT succeed INT)
BEGIN
	DECLARE `rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `rollback` = 1;

	START TRANSACTION;
		SET @start = 0;
		WHILE @start < amount DO
			INSERT INTO `books`(`isbn`, `library_id`) VALUES(isbn, library_id);
			SET @start = @start + 1;
		END WHILE;
        SET succeed = 1;
        IF `rollback` THEN
			ROLLBACK;
            SET succeed = 0;
		END IF;
    COMMIT;
END //

DROP PROCEDURE IF EXISTS `get_amount_of_books_in_stock`;
DELIMITER //
CREATE PROCEDURE `get_amount_of_books_in_stock`(isbn VARCHAR(50))
BEGIN
	SELECT
    COUNT(*) AS amount
    FROM `books` b
    WHERE
    b.`isbn` = isbn AND
    NOT EXISTS(
		SELECT *
		FROM `loans` l
		WHERE b.`book_id` = l.`book_id`
    );
END //

CALL `get_amount_of_books_in_stock`("9781387207770");

DROP PROCEDURE IF EXISTS `get_book_by_isbn`
DELIMITER //
CREATE PROCEDURE `get_book_by_isbn`(isbn VARCHAR(30))
BEGIN
	SELECT
    bd.*,
    (SELECT GROUP_CONCAT(`name`) FROM `books_with_authors` ba, `authors` a WHERE bd.`isbn` = ba.`isbn` AND ba.`author_id` = a.`author_id`) AS authors,
    (SELECT GROUP_CONCAT(`name`) FROM `books_with_genre` bg, `genre` g WHERE bd.`isbn` = bg.`isbn` AND bg.`genre_id` = g.`genre_id`) AS genres,
    (SELECT GROUP_CONCAT(DISTINCT l.`name`) FROM `libraries` l, `books` b WHERE bd.`isbn` = b.`isbn` AND b.`library_id` = l.`library_id` AND NOT EXISTS(SELECT * FROM `loans` l WHERE b.`book_id` = l.`book_id`)) AS available_libraries
    FROM `book_details` bd WHERE bd.`isbn` = isbn;
END //

CALL get_book_by_isbn(9781387207770);

DROP PROCEDURE IF EXISTS `get_book_by_id`
DELIMITER //
CREATE PROCEDURE `get_book_by_id`(bookId INT)
BEGIN
	SELECT b.`book_id`, b.`isbn`, b.`library_id`, bd.`title`, bd.`description`, bd.`language`, bd.`published`, bd.`image_source`, bd.`pages`,
    (SELECT GROUP_CONCAT(`name`) FROM `books_with_authors` ba, `authors` a WHERE bd.`isbn` = ba.`isbn` AND ba.`author_id` = a.`author_id`) AS authors,
    (SELECT GROUP_CONCAT(`name`) FROM `books_with_genre` bg, `genre` g WHERE bd.`isbn` = bg.`isbn` AND bg.`genre_id` = g.`genre_id`) AS genres
	FROM `books` b, `book_details` bd
	WHERE b.`book_id` = bookId AND b.`isbn` = bd.`isbn`;
END //

DROP PROCEDURE IF EXISTS `available_amount_of_book_in_libraries`;
DELIMITER //
CREATE PROCEDURE `available_amount_of_book_in_libraries`(isbn VARCHAR(50))
BEGIN
	SELECT
    l.`library_id` AS library_id,
    l.`name` AS name,
    (SELECT COUNT(`book_id`) FROM `books` b
    WHERE b.`library_id` = l.`library_id` AND
    b.`isbn` = isbn AND
    NOT EXISTS(
	  SELECT NULL
	  FROM `loans` l
	  WHERE b.`book_id` = l.`book_id`)) AS amount
    FROM `libraries` l;
END //

CALL available_amount_of_book_in_libraries("9781387207770");

DROP PROCEDURE IF EXISTS `get_copies_in_library`;
DELIMITER //
CREATE PROCEDURE `get_copies_in_library`(library_id INT, isbn VARCHAR(20))
BEGIN
	SELECT *, (NOT EXISTS(SELECT * FROM `loans` l WHERE l.`book_id` = b.`book_id`) = 1) AS available
    FROM `books` b
    WHERE b.`library_id` = library_id AND
    b.`isbn` = isbn;
END //

CALL `get_copies_in_library`(1, "0132350882");

DROP PROCEDURE IF EXISTS `get_loaned_books_with_isbn`;
DELIMITER //
CREATE PROCEDURE `get_loaned_books_with_isbn`(isbn VARCHAR(50))
BEGIN
	SELECT
    *
    FROM `loans` l
    WHERE
    EXISTS(
		SELECT *
        FROM `books` b
        WHERE b.`isbn` = isbn AND
        l.`book_id` = b.`book_id`
    );
END //

CALL get_loaned_books_with_isbn("1251253223423");

-- produces for customer
DROP PROCEDURE IF EXISTS `create_customer`;
DELIMITER //

CREATE DEFINER=root@localhost PROCEDURE create_customer(in first_name VARCHAR(40), in last_name VARCHAR(40), in username VARCHAR(70), in password VARCHAR(300), out succeed int)
BEGIN

DECLARE customer_exists VARCHAR(70) DEFAULT (SELECT email FROM customers WHERE email = username);

SET @salt=SUBSTRING(MD5(RAND()), -10);

IF customer_exists IS NULL THEN

INSERT INTO customers (first_name, last_name, email, password, salt) VALUES (first_name, last_name, username, concat(sha2(password, 224), @salt), @salt);

SET succeed = 1;

ELSE
SET succeed = 0;
END IF;

END //

DROP PROCEDURE IF EXISTS `authenticator`;
DELIMITER //
CREATE DEFINER=root@localhost PROCEDURE authenticator(in username varchar(70), in userpassword varchar(300), out succeed int)
BEGIN

DECLARE customer_exists VARCHAR(20) DEFAULT (SELECT salt FROM customers WHERE email = username);

IF customer_exists IS NULL THEN

SET succeed = 0;

END IF;

SET @salt = (SELECT salt FROM customers WHERE email = username);
SET @pass_the_hash = concat(sha2(userpassword, 224), @salt);
SET @pValue = (SELECT COUNT("UserName") FROM customers WHERE email = username AND password = @pass_the_hash);

IF @pValue = 1 THEN SET succeed = 1;

ELSE
SET succeed = 0;
END IF;

END //

DROP PROCEDURE IF EXISTS `create_employee`;
DELIMITER //
CREATE PROCEDURE `create_employee`(first_name VARCHAR(40), last_name VARCHAR(40), email VARCHAR(70), `password` VARCHAR(40), `role` VARCHAR(55), OUT succeed INT)

CREATE DEFINER=root@localhost PROCEDURE create_employee(in first_name VARCHAR(40), in last_name VARCHAR(40), in username VARCHAR(70), in password VARCHAR(300), in role VARCHAR (55), out succeed int)
BEGIN
	START TRANSACTION;
		SET @employee_exists = 0;
		SELECT COUNT(*) FROM employees e WHERE e.`email` = email INTO @employee_exists;
		IF (@employee_exists > 0) THEN
			SET succeed = 0;
		ELSE
			SET succeed = 1;
			INSERT INTO employees (`first_name`,`last_name`,`email`,`password`,`role`) VALUES(first_name, last_name, email, `password`, `role`);
		END IF;
    COMMIT;
END //

DECLARE employee_exists VARCHAR(70) DEFAULT (SELECT email FROM employees WHERE email = username);

SET @salt=SUBSTRING(MD5(RAND()), -10);

IF employee_exists IS NULL THEN

INSERT INTO employees (first_name, last_name, email, password, salt, role) VALUES (first_name, last_name, username, concat(sha2(password, 224), @salt), @salt,role);

SET succeed = 1;

ELSE
SET succeed = 0;
END IF;

END //

DROP PROCEDURE IF EXISTS `employee_authenticator`;
DELIMITER //

CREATE DEFINER=root@localhost PROCEDURE employee_authenticator(in username varchar(70), in userpassword varchar(300), out succeed int)
BEGIN

DECLARE employee_exists VARCHAR(20) DEFAULT (SELECT salt FROM employees WHERE email = username);

IF employee_exists IS NULL THEN

SET succeed = 0;

END IF;

SET @salt = (SELECT salt FROM employees WHERE email = username);
SET @pass_the_hash = concat(sha2(userpassword, 224), @salt);
SET @pValue = (SELECT COUNT("UserName") FROM employees WHERE email = username AND password = @pass_the_hash);

IF @pValue = 1 THEN SET succeed = 1;

ELSE
SET succeed = 0;
END IF;

END //


    --  group_rooms
    DROP PROCEDURE IF EXISTS `create_customers_with_group_rooms`;
DELIMITER //
CREATE PROCEDURE `create_customers_with_group_rooms`(time_id INT, customer_id INT ,OUT succeed INT)
BEGIN
	START TRANSACTION;
		SET @customers_with_group_rooms_exists = 0;
		SELECT COUNT(*) FROM customers_with_group_rooms cwgr WHERE (cwgr.`time_id`, cwgr.`customer_id`) = (time_id, customer_id) INTO @customers_with_group_rooms_exists;
		IF (@customers_with_group_rooms_exists > 0) THEN
			SET succeed = 0;
		ELSE
			SET succeed = 1;
			INSERT INTO customers_with_group_rooms (`time_id`, `customer_id`) VALUES(time_id, customer_id);
		END IF;
    COMMIT;
END //


 DROP PROCEDURE IF EXISTS `create_group_rooms`;
DELIMITER //
CREATE PROCEDURE `create_group_rooms`(name varchar(40), library_id int ,OUT succeed INT)
BEGIN
	START TRANSACTION;
		SET @group_rooms_exists = 0;
		SELECT COUNT(*) FROM group_rooms r WHERE r.`name` = name INTO @group_rooms_exists;
		IF (@group_rooms_exists > 0) THEN
			SET succeed = 0;
		ELSE
			SET succeed = 1;
			INSERT INTO group_rooms (`name`,`library_id`) VALUES(name, library_id);
		END IF;
    COMMIT;
END //


DROP PROCEDURE IF EXISTS `create_group_room_times`;
DELIMITER //
CREATE PROCEDURE `create_group_room_times`(room_id int, time varchar(11), date VARCHAR(10) ,OUT succeed INT)
BEGIN
	START TRANSACTION;
		SET @group_room_times_exists = 0;
		SELECT COUNT(*) FROM group_room_times r WHERE (r.`room_id`, r.`time`, r.`date`) = (room_id, time, date) INTO @group_room_times_exists;
		IF (@group_room_times_exists > 0) THEN
			SET succeed = 0;
		ELSE
			SET succeed = 1;
			INSERT INTO group_room_times (`room_id`,`time`,`date`) VALUES(room_id, time, date);
		END IF;
    COMMIT;
END //


DROP PROCEDURE IF EXISTS `get_customers_with_group_rooms`;
DELIMITER //
CREATE PROCEDURE `get_customers_with_group_rooms`()
BEGIN
	SELECT
    c.`first_name` AS FirstName, c.`last_name` AS LastName, (grt.`time`) AS Time, (grt.`date`) AS Booking,
    gr.`name` AS Room , l.`name` AS Library
    FROM (`customers` c, `libraries` l)
INNER
  JOIN `customers_with_group_rooms` cwgr
    ON c.`customer_id` = cwgr.`customer_id`
INNER
  JOIN `group_rooms` gr
    ON l.`library_id` = gr.`library_id`
INNER
  JOIN `group_room_times` grt
    ON gr.`room_id` = grt.`room_id` AND cwgr.`time_id` = grt.`time_id`;
END //

DROP PROCEDURE IF EXISTS `get_available_group_room_times`;
DELIMITER //
CREATE PROCEDURE `get_available_group_room_times`(room_id INT)
BEGIN
	SELECT *
    FROM `group_room_times` g
    WHERE
    g.`room_id` = room_id AND
    NOT EXISTS(
		SELECT *
        FROM `customers_with_group_rooms` c
        WHERE g.`time_id` = c.`time_id`
    );
END //

CALL get_available_group_room_times_by_room_id();

DROP PROCEDURE IF EXISTS `get_available_group_rooms`;
DELIMITER //
CREATE PROCEDURE `get_available_group_rooms`()
BEGIN
SELECT * FROM group_rooms;
/*
BEGIN
	SELECT
    gr.`name` AS Room, (grt.`time`) AS Time, (grt.`date`) AS Date,
	l.`name` AS Library
    FROM (`group_room_times` grt, `libraries` l)
INNER
  JOIN `group_rooms` gr
    ON grt.`room_id` = gr.`room_id` AND gr.`library_id` = l.`library_id`
ORDER BY Date;
*/
END //

USE `library_management_system`;
DROP procedure IF EXISTS `get_customer_room_bookings`;

DELIMITER $$
USE `library_management_system`$$
CREATE PROCEDURE `get_customer_room_bookings` (customer_id_frontend INT)
BEGIN

SELECT c.customer_id, g.*, r.name
FROM customers_with_group_rooms c, group_room_times g, group_rooms r
WHERE c.customer_id = customer_id_frontend AND
g.time_id = c.time_id AND
r.room_id = g.room_id;
    
END$$

DELIMITER ;

Select * from loans where str_to_date(return_date,'%Y-%m-%d') between str_to_date('2022-5-02','%Y-%m-%d') and str_to_date('2022-6-02','%Y-%m-%d');


CALL get_customer_room_bookings(1);

