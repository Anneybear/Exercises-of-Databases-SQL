-- Q1 Find the names of all students who are friends with someone named Gabriel.
SELECT h1.name
FROM highschooler h1 JOIN friend f
ON h1.ID = f.ID1
JOIN highschooler h2
on h2.ID = f.ID2
WHERE h2.name = 'Gabriel'

-- Q2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.
SELECT h1.name,h1.grade,h2.name,h2.grade
FROM highschooler h1 JOIN likes l
ON h1.ID = l.ID1
JOIN highschooler h2
on h2.ID = l.ID2
WHERE (h1.grade - h2.grade) >=2

-- Q3. For every pair of students who both like each other, return the name and grade of both students.
SELECT h1.name,h1.grade,h2.name,h2.grade
FROM highschooler h1 JOIN likes l
ON h1.ID = l.ID1
JOIN highschooler h2
on h2.ID = l.ID2
JOIN likes l2
on h2.ID = l2.ID1 AND h1.ID = l2.ID2
WHERE h1.name < h2.name
ORDER BY h1.name, h2.name;

-- Q4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
SELECT name, grade
FROM highschooler
WHERE ID NOT IN (SELECT DISTINCT ID1 FROM Likes
UNION
SELECT DISTINCT ID2 FROM Likes)
ORDER BY grade, name;

-- Q5. For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
SELECT h1.name,h1.grade,h2.name,h2.grade
FROM highschooler h1 JOIN likes l
ON h1.ID = l.ID1
JOIN highschooler h2
on h2.ID = l.ID2
WHERE h2.ID NOT IN (SELECT ID1 from likes);

-- Q6. Find names and grades of students who only have friends in the same grade.
SELECT DISTINCT h1.name, h1.grade
FROM Highschooler h1 JOIN Friend f
ON h1.ID = f.ID1
JOIN Highschooler h2
ON h2.ID = f.ID2
WHERE h1.ID NOT IN (SELECT h1.ID FROM Highschooler h1,highschooler h2, friend f
                    WHERE h1.id = f.id1
                    AND h2.id = f.id2 
                    AND h1.grade <> h2.grade)
ORDER BY h1.grade, h1.name;

-- Q7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.
-- THE ANSWER IS EASY TO UNDERSTAND
SELECT h.name,h.grade,h2.name,h2.grade,h3.name,h3.grade
FROM (SELECT * FROM likes l2
WHERE l2.ID1 NOT IN (SELECT l1.id1 FROM friend f1, likes l1
					 WHERE f1.ID1 = l1.ID1 AND f1.ID2 = l1.ID2)) sub
JOIN friend F2 ON sub.ID1=F2.ID1
JOIN friend f3 ON sub.id2=f3.id1 AND f2.id2=f3.id2
JOIN highschooler h ON sub.id1 = h.id
JOIN highschooler h2 ON sub.id2 = h2.id
JOIN highschooler h3 ON f2.id2 = h3.id

-- Q8. Find the difference between the number of students in the school and the number of different first names.
SELECT COUNT(*) -  COUNT(DISTINCT(name)) 
FROM Highschooler;

-- Q9. Find the name and grade of all students who are liked by more than one other student.
SELECT h2.name, h2.grade 
FROM highschooler h1,highschooler h2, likes li
WHERE h1.ID = li.ID1 AND h2.ID = li.ID2
GROUP BY ID2
HAVING COUNT(ID2) > 1