-- Q1. For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.
SELECT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM highschooler h1 
JOIN likes l, highschooler h2, likes l2, likes l3, highschooler h3
WHERE h1.ID = l.ID1 AND h2.ID = l.ID2
AND h2.ID = l2.ID1 AND h1.ID != l2.ID2
AND h2.ID = l3.ID1 AND h3.ID = l3.ID2

-- Q2. Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.
SELECT DISTINCT h1.name, h1.grade
FROM Highschooler h1, Friend f, Highschooler h2
WHERE h1.ID = f.ID1 AND h2.ID = f.ID2
AND h1.ID NOT IN (SELECT h1.ID FROM Highschooler h1,highschooler h2, friend f
                    WHERE h1.id = f.id1
                    AND h2.id = f.id2 
                    AND h1.grade = h2.grade)
ORDER BY h1.grade, h1.name;

-- Q3. What is the average number of friends per student? 
SELECT AVG(SUB.COUNT)
FROM (SELECT ID1, COUNT(ID2) AS COUNT
FROM friend
GROUP BY ID1) SUB

-- Q4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.
SELECT COUNT(*)
FROM Friend
WHERE ID1 IN(SELECT ID2
			FROM Friend 
            WHERE ID1 in (SELECT ID 
			FROM Highschooler
			WHERE name = 'Cassandra'));

-- Q5. Find the name and grade of the student(s) with the greatest number of friends.
SELECT h.name, h.grade
FROM highschooler h, friend f
WHERE  h.ID = f.ID1
GROUP BY h.name, h.grade
HAVING COUNT(f.ID2) = 
(SELECT MAX(SUB.COUNT) FROM (SELECT ID1, COUNT(ID2) AS COUNT
FROM friend
GROUP BY ID1) SUB)