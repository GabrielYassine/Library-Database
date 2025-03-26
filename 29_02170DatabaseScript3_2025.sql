USE LibrarySystem;
DELIMITER $$
-- fn_countBooksBorrowed: Returns how many books a particular member is currently borrowing.
CREATE FUNCTION fn_countBooksBorrowed (
    p_memberID INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_count INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_count
    FROM Borrows
    WHERE member_ID = p_memberID;
    
    RETURN v_count;
END $$

DELIMITER ;
SELECT fn_countBooksBorrowed(1) AS BooksCurrentlyBorrowed


-- sp_borrowBook: Checks if a book is “Available” before recording the borrow transaction, and updates its status.
DELIMITER $$
CREATE PROCEDURE sp_borrowBook(
    IN p_memberID INT,
    IN p_bookID INT,
    OUT p_message VARCHAR(100)
)
BEGIN
    DECLARE v_status VARCHAR(20);

    -- Check the book's current status
    SELECT borrow_status
      INTO v_status
      FROM Book
     WHERE book_ID = p_bookID;

    IF v_status IS NULL THEN
        SET p_message = CONCAT('No such book ID: ', p_bookID);
    ELSEIF v_status <> 'Available' THEN
        SET p_message = 'Book is not currently available.';
    ELSE
        -- Mark book as borrowed
        UPDATE Book
           SET borrow_status = 'Borrowed'
         WHERE book_ID = p_bookID;
        
        -- Insert into Borrows table
        INSERT INTO Borrows (member_ID, book_ID, borrow_date)
        VALUES (p_memberID, p_bookID, CURDATE());
        
        SET p_message = 'Borrowed successfully.';
    END IF;
END $$
DELIMITER ;
-- Attempt to borrow book #3 for member #1
CALL sp_borrowBook(2, 3, @msg);
SELECT @msg AS ResultMessage



-- trg_Event_EnforceCapacity: Prevents an UPDATE on Event that would raise curr_participants above max_participants.
DELIMITER $$

CREATE TRIGGER trg_Event_EnforceCapacity
BEFORE UPDATE ON Event
FOR EACH ROW
BEGIN
    IF NEW.curr_participants > NEW.max_participants THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot exceed max_participants for this event.';
    END IF;
END $$

DELIMITER ;
UPDATE Event
   SET curr_participants = 35
 WHERE event_ID = 1; 

