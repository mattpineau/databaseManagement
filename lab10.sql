
--Matt Pineau
--Lab 10
--November 29, 2014

--Query to get the course number, name, and number of credits of prerequisites for a certain course number--
--Note: The stored procedure takes the course number as an argument--
--Note: This script also calls the stored procedure--

CREATE OR REPLACE FUNCTION preReqsFor(int, REFCURSOR)
RETURNS REFCURSOR AS
$$
DECLARE
    course int  := $1;
    resultset REFCURSOR := $2;
BEGIN
    OPEN RESULTSET FOR
        SELECT num, name, credits
        FROM   Courses
        JOIN   Prerequisites
        ON     Courses.num = Prerequisites.preReqNum
        WHERE  Prerequisites.courseNum = course;
    RETURN resultset;
END;
$$
language plpgsql;

select preReqsFor(499,'results');
Fetch all from results;



--Query to get the course number, name, and number of credits of courses that a specified course is a prerequisite for--
--Note: The stored procedure takes the course number as an argument--
--Note: This script also calls the stored procedure--

CREATE OR REPLACE FUNCTION isPreReqFor(int, REFCURSOR)
RETURNS REFCURSOR AS
$$
DECLARE
    course int := $1;
    resultset REFCURSOR := $2;
BEGIN
    OPEN RESULTSET FOR
        SELECT num, name, credits
        FROM Courses
        JOIN Prerequisites
        ON Courses.num = Prerequisites.courseNum
        WHERE Prerequisites.preReqNum = course;
    RETURN resultset;
END;
$$
language plpgsql;

select isPreReqFor(120, 'results');
Fetch all from results;