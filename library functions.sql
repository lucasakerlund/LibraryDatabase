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
        SET succeed = 1;
        IF `rollback` THEN
			ROLLBACK;
            SET succeed = 0;
		END IF;
    COMMIT;
END//

CALL `loan_book`(2, "9781387207770", 1, "","", @result);
SELECT @result

DROP PROCEDURE IF EXISTS `get_books`;
DELIMITER //
CREATE PROCEDURE `get_books`()
BEGIN
	SELECT
    bd.*,
    (SELECT GROUP_CONCAT(`name`) from `books_with_authors` ba, `authors` a WHERE bd.`isbn` = ba.`isbn` AND ba.`author_id` = a.`author_id`) AS authors,
    (SELECT GROUP_CONCAT(`name`) from `books_with_genre` bg, `genre` g WHERE bd.`isbn` = bg.`isbn` AND bg.`genre_id` = g.`genre_id`) AS genres
    FROM `book_details` bd
    GROUP BY bd.`isbn`;
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

DROP PROCEDURE IF EXISTS `get_book_by_id`
DELIMITER //
CREATE PROCEDURE `get_book_by_id`(bookId INT)
BEGIN
	SELECT b.`book_id`, b.`isbn`, b.`library_id`, bd.`title`, bd.`description`, bd.`language`, bd.`published`, bd.`image_source`, bd.`pages`,
    (SELECT GROUP_CONCAT(`name`) from `books_with_authors` ba, `authors` a WHERE bd.`isbn` = ba.`isbn` AND ba.`author_id` = a.`author_id`) AS authors,
    (SELECT GROUP_CONCAT(`name`) from `books_with_genre` bg, `genre` g WHERE bd.`isbn` = bg.`isbn` AND bg.`genre_id` = g.`genre_id`) AS genres
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

DROP PROCEDURE IF EXISTS `create_customer`;
DELIMITER //
CREATE PROCEDURE `create_customer`(first_name VARCHAR(40), last_name VARCHAR(40), email VARCHAR(70), `password` VARCHAR(40), OUT succeed INT)
BEGIN
	START TRANSACTION;
		SET @customer_exists = 0;
		SELECT COUNT(*) FROM customers c WHERE c.`email` = email INTO @customer_exists;
		IF (@customer_exists > 0) THEN
			SET succeed = 0;
		ELSE
			SET succeed = 1;
			INSERT INTO customers (`first_name`,`last_name`,`email`,`password`) VALUES(first_name, last_name, email, `password`);
		END IF;
    COMMIT;
END //

DROP PROCEDURE IF EXISTS `create_employee`;
DELIMITER //
CREATE PROCEDURE `create_employee`(first_name VARCHAR(40), last_name VARCHAR(40), username VARCHAR(70), `password` VARCHAR(40), `role` VARCHAR(55), OUT succeed INT)
BEGIN
	START TRANSACTION;
		SET @employee_exists = 0;
		SELECT COUNT(*) FROM employees e WHERE e.`username` = username INTO @employee_exists;
		IF (@employee_exists > 0) THEN
			SET succeed = 0;
		ELSE
			SET succeed = 1;
			INSERT INTO employees (`first_name`,`last_name`,`username`,`password`,`role`) VALUES(first_name, last_name, username, `password`, `role`);
		END IF;
    COMMIT;
END //

CALL create_employee("test", "test", "test", "123", "ADMIN", @result);
SELECT @result;
