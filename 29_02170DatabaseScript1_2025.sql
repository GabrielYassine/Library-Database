Drop Database IF Exists LibrarySystem;
Create Database LibrarySystem;
Use LibrarySystem;

CREATE TABLE Library (
    library_ID INT PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE Section (
    section_ID INT PRIMARY KEY,
    shelf_count INT,
    library_ID INT,
    FOREIGN KEY (library_ID) REFERENCES Library(library_ID)
);

CREATE TABLE Bookshelf (
    bookshelf_ID INT PRIMARY KEY,
    genre VARCHAR(50),
    section_ID INT,
    FOREIGN KEY (section_ID) REFERENCES Section(section_ID)
);

CREATE TABLE Book (
    book_ID INT PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(100),
    Publisher VARCHAR(100),
    Year INT,
    borrow_status VARCHAR(20),
    bookshelf_ID INT,
    FOREIGN KEY (bookshelf_ID) REFERENCES Bookshelf(bookshelf_ID)
);

CREATE TABLE Member (
    member_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Debt DECIMAL(10,2),
    MembershipExpiration DATE
);

CREATE TABLE Staff (
    staff_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    work_hours INT,
    role VARCHAR(50),
    section_ID INT,
    FOREIGN KEY (section_ID) REFERENCES Section(section_ID)
);

CREATE TABLE Event (
    event_ID INT PRIMARY KEY,
    theme VARCHAR(100),
    date DATE,
    max_participants INT,
    curr_participants INT,
    section_ID INT,
    FOREIGN KEY (section_ID) REFERENCES Section(section_ID)
);


CREATE TABLE Shift (
    shift_ID INT PRIMARY KEY,
    Shift_date DATE,
    start_time TIME,
    end_time TIME,
    staff_ID INT,
    FOREIGN KEY (staff_ID) REFERENCES Staff(staff_ID)
);

CREATE TABLE Room (
    room_ID INT PRIMARY KEY,
    capacity INT,
    availability VARCHAR(20),
    section_ID INT,
    FOREIGN KEY (section_ID) REFERENCES Section(section_ID)
);

CREATE TABLE RoomBooking (
    Booking_ID INT PRIMARY KEY,
    member_ID INT,
    room_ID INT,
    booking_date DATE,
    start_time TIME,
    end_time TIME,
    FOREIGN KEY (member_ID) REFERENCES Member(member_ID),
    FOREIGN KEY (room_ID) REFERENCES Room(room_ID)
);

CREATE TABLE Borrows (
    member_ID INT,
    book_ID INT,
    borrow_date DATE,
    PRIMARY KEY (member_ID, book_ID),
    FOREIGN KEY (member_ID) REFERENCES Member(member_ID),
    FOREIGN KEY (book_ID) REFERENCES Book(book_ID)
);






/*--------------------------------------Populating the database------------------------------------- */
-- Populate Library Table
INSERT INTO Library (library_ID, name, address) VALUES
(1, 'Central Library', 'Anker Engelunds Vej 1, 2800 Kgs. Lyngby'),
(2, 'Community Library', 'Lyngby Hovedgade 23, 2800 Kgs. Lyngby');

-- Populate Section Table
INSERT INTO Section (section_ID, shelf_count, library_ID) VALUES
(1, 10, 1),
(2, 5, 1),
(3, 7, 2);

-- Populate Bookshelf Table
INSERT INTO Bookshelf (bookshelf_ID, genre, section_ID) VALUES
(1, 'Fiction', 1),
(2, 'Non-Fiction', 1),
(3, 'Science', 2),
(4, 'History', 3);

-- Populate Book Table
INSERT INTO Book (book_ID, Title, Author, Publisher, Year, borrow_status, bookshelf_ID) VALUES
(1, '1984', 'George Orwell', 'Secker & Warburg', 1949, 'Available', 1),
(2, 'A Brief History of Time', 'Stephen Hawking', 'Bantam Books', 1988, 'Borrowed', 3),
(3, 'Sapiens', 'Yuval Noah Harari', 'Harper', 2015, 'Available', 4);

-- Populate Member Table
INSERT INTO Member (member_ID, Name, Email, Debt, MembershipExpiration) VALUES
(1, 'Alice Johnson', 'alice@dtu.dk', 0.00, '2025-12-31'),
(2, 'Bob Smith', 'bob@dtu.dk', 15.50, '2024-06-30');

-- Populate Staff Table
INSERT INTO Staff (staff_ID, Name, work_hours, role, section_ID) VALUES
(1, 'Mads Jensen', 40, 'Librarian', 1),
(2, 'Sofie Nielsen', 35, 'Assistant', 2);

-- Populate Event Table
INSERT INTO Event (event_ID, theme, date, max_participants, curr_participants, section_ID) VALUES
(1, 'Book Reading', '2025-04-20', 30, 10, 2),
(2, 'Science Talk', '2025-05-15', 25, 20, 3);

-- Populate Shift Table
INSERT INTO Shift (shift_ID, Shift_date, start_time, end_time, staff_ID) VALUES
(1, '2025-03-25', '09:00:00', '17:00:00', 1),
(2, '2025-03-26', '12:00:00', '20:00:00', 2);

-- Populate Room Table
INSERT INTO Room (room_ID, capacity, availability, section_ID) VALUES
(1, 10, 'Available', 1),
(2, 20, 'Booked', 3);

-- Populate RoomBooking Table
INSERT INTO RoomBooking (Booking_ID, member_ID, room_ID, booking_date, start_time, end_time) VALUES
(1, 1, 2, '2025-04-01', '10:00:00', '12:00:00'),
(2, 2, 1, '2025-04-02', '14:00:00', '16:00:00');

-- Populate Borrows Table
INSERT INTO Borrows (member_ID, book_ID, borrow_date) VALUES
(1, 2, '2025-03-15'),
(2, 1, '2025-03-20');







