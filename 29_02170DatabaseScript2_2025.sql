-- 1. Query using JOIN: List all books along with their bookshelf genre and library name
SELECT Book.Title, Bookshelf.genre, Library.name AS LibraryName
FROM Book
JOIN Bookshelf ON Book.bookshelf_ID = Bookshelf.bookshelf_ID
JOIN Section ON Bookshelf.section_ID = Section.section_ID
JOIN Library ON Section.library_ID = Library.library_ID;

/*Explanation:
This query retrieves the title of each book together with the genre of its associated bookshelf and the name of the library where the book is located. It uses JOIN operations to combine data across multiple tables based on their foreign key relationships.
*/

-- 2. Query using GROUP BY: Count how many books each bookshelf genre contains
SELECT Bookshelf.genre, COUNT(Book.book_ID) AS NumberOfBooks
FROM Book
JOIN Bookshelf ON Book.bookshelf_ID = Bookshelf.bookshelf_ID
GROUP BY Bookshelf.genre;

/*
Explanation:
This query calculates how many books are present in each genre by grouping the books according to the genre of their bookshelf. The COUNT function is used to count the number of books within each genre group.
*/


-- 3. Query to list members with borrow books, ordered by oldest first.
-- Author: Gabriel

SELECT Name, Title, borrow_date
FROM Borrows
NATURAL JOIN Member
NATURAL JOIN Book
ORDER BY borrow_date ASC;

/*
Explanation:
This query retrives a list of members who have borrow books, along with the title of the borrowed book,
and the borrow date. It sorts by borrow date in ascending order, that way you can see keep tab of the oldest borrow dates.
Might be nice to also have one descending.
*/


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

