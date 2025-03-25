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