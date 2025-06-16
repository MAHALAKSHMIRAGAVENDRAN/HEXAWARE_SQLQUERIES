CREATE DATABASE Hexaware;  

CREATE TABLE screen (
    screen_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    class_type VARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    PRIMARY KEY (screen_id)
);
CREATE TABLE Seat (
    seat_id INT PRIMARY KEY,
    screen_id INT,
    seat_number VARCHAR(10),
    FOREIGN KEY (screen_id) REFERENCES Screen(screen_id)
);
CREATE TABLE Movie (
    movie_id INT PRIMARY KEY,
    title VARCHAR(200),
    genre VARCHAR(50),
    rating DECIMAL(3,1),
    status VARCHAR(30),
    poster_image_url VARCHAR(300)
);
CREATE TABLE MovieCast (
    cast_id INT PRIMARY KEY,
    movie_id INT,
    person_name VARCHAR(100),
    role VARCHAR(100),
    FOREIGN KEY (movie_id) REFERENCES Movie(movie_id)
);
CREATE TABLE Review (
    review_id INT PRIMARY KEY,
    movie_id INT,
    content TEXT,
    review_date DATETIME,
    reviewer_name VARCHAR(100),
    FOREIGN KEY (movie_id) REFERENCES Movie(movie_id)
);
CREATE TABLE Show (
    show_id INT PRIMARY KEY,
    screen_id INT,
    movie_id INT,
    show_datetime DATETIME,
    FOREIGN KEY (screen_id) REFERENCES Screen(screen_id),
    FOREIGN KEY (movie_id) REFERENCES Movie(movie_id)
);
CREATE TABLE ShowSeat (
    show_seat_id INT PRIMARY KEY,
    show_id INT,
    seat_id INT,
    is_booked BIT,
    FOREIGN KEY (show_id) REFERENCES Show(show_id),
    FOREIGN KEY (seat_id) REFERENCES Seat(seat_id)
);
CREATE TABLE [User] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,  
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(15) NULL                    
);
CREATE TABLE Membership (
    membership_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    current_points INT NOT NULL DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES [User](user_id)
);
CREATE TABLE Booking (
    booking_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    show_id INT NOT NULL,
    booking_datetime DATETIME NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES [User](user_id),
    FOREIGN KEY (show_id) REFERENCES [Show](show_id)
);

INSERT INTO Screen VALUES
(1, 'Screen A', 'Gold', 100),
(2, 'Screen B', 'Silver', 80),
(3, 'Screen C', 'Platinum', 120),
(4, 'Screen D', 'Gold', 90),
(5, 'Screen E', 'Silver', 85);

INSERT INTO Seat VALUES
(1, 1, 'A1'),
(2, 1, 'A2'),
(3, 2, 'B1'),
(4, 3, 'C1'),
(5, 4, 'D1');

INSERT INTO Movie VALUES
(1, 'Inception', 'Sci-Fi', 8.8, 'Now Showing', 'inception.jpg'),
(2, 'Avatar', 'Fantasy', 8.0, 'Now Showing', 'avatar.jpg'),
(3, 'Oppenheimer', 'Drama', 9.1, 'Upcoming', 'oppenheimer.jpg'),
(4, 'Interstellar', 'Sci-Fi', 8.6, 'Now Showing', 'interstellar.jpg'),
(5, 'Dune', 'Sci-Fi', 8.2, 'Now Showing', 'dune.jpg');

INSERT INTO MovieCast VALUES
(1, 1, 'Leonardo DiCaprio', 'Cobb'),
(2, 2, 'Sam Worthington', 'Jake Sully'),
(3, 3, 'Cillian Murphy', 'Oppenheimer'),
(4, 4, 'Matthew McConaughey', 'Cooper'),
(5, 5, 'Timothée Chalamet', 'Paul Atreides');

INSERT INTO Review VALUES
(1, 1, 'Mind-blowing visuals.', '2025-06-01', 'Alice'),
(2, 2, 'Epic world-building.', '2025-06-02', 'Bob'),
(3, 3, 'Intense and moving.', '2025-06-03', 'Charlie'),
(4, 4, 'Emotional space drama.', '2025-06-04', 'Daisy'),
(5, 5, 'Stunning visuals.', '2025-06-05', 'Eve');

INSERT INTO Show VALUES
(1, 1, 1, '2025-06-10 18:00'),
(2, 2, 2, '2025-06-11 15:00'),
(3, 3, 3, '2025-06-12 20:00'),
(4, 4, 4, '2025-06-13 14:00'),
(5, 5, 5, '2025-06-14 19:30');

INSERT INTO [User] (name, email, phone) VALUES
('Arun', 'arun@example.com', '9876543210'),
('Banu', 'banu@example.com', '9876543211'),
('Chitra', 'chitra@example.com', NULL),
('Deepak', 'deepak@example.com', '9876543212'),
('Elena', 'elena@example.com', '9876543213');

INSERT INTO Membership (user_id, current_points) VALUES
(1, 100),
(2, 50),
(3, 75),
(4, 20),
(5, 120);

INSERT INTO Booking (user_id, show_id, booking_datetime, total_cost) VALUES
(1, 1, '2025-06-10 10:00', 350.00),
(2, 2, '2025-06-11 12:00', 300.00),
(3, 3, '2025-06-12 13:45', 400.00),
(4, 4, '2025-06-13 10:30', 280.00),
(5, 5, '2025-06-14 16:00', 500.00);

DELETE FROM Review WHERE movie_id = 5;
ALTER TABLE Movie ADD language VARCHAR(50);
ALTER TABLE [User] ALTER COLUMN phone VARCHAR(20);
UPDATE Booking SET total_cost = 375.00 WHERE booking_id = 1;
UPDATE Movie SET status = 'Now Showing' WHERE movie_id = 3;
SELECT * FROM Seat WHERE screen_id = 1;
SELECT name, email FROM [User];
SELECT DISTINCT genre FROM Movie;
SELECT DISTINCT class_type FROM Screen;
SELECT * FROM [User] ORDER BY name ASC;
SELECT * FROM Movie ORDER BY rating DESC;
SELECT * FROM [User] ORDER BY user_id OFFSET 2 ROWS;
SELECT * FROM Review ORDER BY review_date OFFSET 3 ROWS;
SELECT * FROM Booking ORDER BY booking_datetime DESC OFFSET 0 ROWS FETCH NEXT 2 ROWS ONLY;
SELECT * FROM Movie ORDER BY movie_id OFFSET 1 ROWS FETCH NEXT 2 ROWS ONLY;
SELECT * FROM Movie
ORDER BY genre ASC, rating DESC;

SELECT title, rating FROM Movie
ORDER BY title
OFFSET 3 ROWS
FETCH NEXT 5 ROWS ONLY;

SELECT genre, COUNT(*) as movie_count FROM Movie
WHERE rating > 8.0
GROUP BY genre;

SELECT AVG(rating) FROM Movie;
SELECT AVG(rating) AS avg_rating FROM Movie;

SELECT u.name, b.total_cost FROM [User] u
INNER JOIN Booking b ON u.user_id = b.user_id;

SELECT u.name, b.total_cost FROM [User] u
LEFT JOIN Booking b ON u.user_id = b.user_id
WHERE b.total_cost IS NOT NULL;

SELECT u.name, b.total_cost FROM [User] u
RIGHT JOIN Booking b ON u.user_id = b.user_id;

SELECT u.name, b.total_cost FROM [User] u
FULL OUTER JOIN Booking b ON u.user_id = b.user_id;

SELECT 
    title,
    genre,
    LEN(title) AS title_length,
    UPPER(title) AS upper_title,
    LOWER(title) AS lower_title,
    LEFT(title, 5) AS left_title,
    RIGHT(title, 5) AS right_title,
    SUBSTRING(title, 2, 4) AS substring_title,
    REPLACE(title, 'e', 'E') AS replaced_title,
    CONCAT(title, ' - ', genre) AS concatenated,
    REVERSE(title) AS reversed_title
FROM Movie;

SELECT 
    movie_id, 
    title, 
    rating,
    rating + 1 AS add_one,
    rating - 1 AS sub_one,
    rating * 2 AS double_rating,
    rating / 2 AS half_rating,
    rating % 2 AS mod_two
FROM Movie;

SELECT 
    movie_id, 
    title, 
    rating
FROM Movie
WHERE rating > 8.5
  AND rating <= 9.0
  OR genre = 'Sci-Fi';

SELECT 
    movie_id, 
    title, 
    genre, 
    rating
FROM Movie
WHERE (genre = 'Sci-Fi' OR genre = 'Action')
  AND rating >= 8.0
  AND NOT status = 'Archived';

SELECT 
    movie_id,
    movie_id & 1 AS bitwise_and,
    movie_id | 2 AS bitwise_or,
    movie_id ^ 3 AS bitwise_xor
FROM Movie;

SELECT 
    movie_id, 
    title, 
    rating
FROM Movie
WHERE rating BETWEEN 8.0 AND 9.0;

SELECT 
    movie_id, 
    title, 
    genre
FROM Movie
WHERE genre IN ('Action', 'Drama', 'Sci-Fi');

SELECT 
    movie_id, 
    title
FROM Movie
WHERE title NOT LIKE '%Dark%';

SELECT 
    movie_id, 
    title,
    poster_image_url
FROM Movie
WHERE poster_image_url IS NOT NULL;

SELECT 
    m.title,
    r.content AS review_content,
    mc.person_name AS cast_name
FROM Movie m
LEFT JOIN Review r ON m.movie_id = r.movie_id
RIGHT JOIN MovieCast mc ON m.movie_id = mc.movie_id
WHERE m.genre = 'Sci-Fi';
--DAY 6
SELECT name, email
FROM [User]
WHERE user_id IN (
    SELECT user_id
    FROM Booking
    WHERE show_id IN (
        SELECT show_id
        FROM Show
        WHERE movie_id = (
            SELECT movie_id
            FROM Movie
            WHERE title = 'Inception'
        )
    )
);
SELECT u.name, avg_cost
FROM (
    SELECT user_id, AVG(total_cost) AS avg_cost
    FROM Booking
    GROUP BY user_id
) AS avg_table
JOIN [User] u ON u.user_id = avg_table.user_id
WHERE avg_cost > 200;

SELECT u.name, b.booking_datetime, m.title
FROM [User] u
JOIN Booking b ON u.user_id = b.user_id
LEFT JOIN Show s ON b.show_id = s.show_id
JOIN Movie m ON s.movie_id = m.movie_id;

SELECT u.name, s.show_datetime, m.title
FROM Booking b
RIGHT JOIN [User] u ON b.user_id = u.user_id
JOIN Show s ON b.show_id = s.show_id
JOIN Movie m ON s.movie_id = m.movie_id;

SELECT u.name AS UserName, b.booking_id
FROM [User] u
LEFT JOIN Booking b ON u.user_id = b.user_id
UNION
SELECT u.name, b.booking_id
FROM [User] u
RIGHT JOIN Booking b ON u.user_id = b.user_id;

SELECT user_id, COUNT(*) AS total_bookings
FROM Booking
GROUP BY user_id;

SELECT genre, MAX(rating) AS top_rating
FROM Movie
GROUP BY genre;

SELECT m.genre, COUNT(*) AS movie_count, AVG(rating) AS avg_rating
FROM Movie m
GROUP BY m.genre;

SELECT u.name, b.total_cost
FROM [User] u
JOIN Booking b ON u.user_id = b.user_id
WHERE b.total_cost = (SELECT MAX(total_cost) FROM Booking);

SELECT name,
    (SELECT COUNT(*) FROM Booking b WHERE b.user_id = u.user_id) AS total_bookings
FROM [User] u
WHERE user_id IN (SELECT user_id FROM Membership WHERE current_points > 50);


SELECT u.name, 
       UPPER(m.title) AS MovieName, 
       LEFT(CAST(r.content AS VARCHAR(MAX)), 20) AS ShortReview
FROM Review r
JOIN Movie m ON r.movie_id = m.movie_id
JOIN Show s ON s.movie_id = m.movie_id
JOIN Booking b ON b.show_id = s.show_id
JOIN [User] u ON u.user_id = b.user_id;





