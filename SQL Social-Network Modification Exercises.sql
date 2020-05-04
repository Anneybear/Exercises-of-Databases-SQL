-- Q1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
DELETE FROM highschooler
WHERE grade = 12;

-- Q2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
DELETE FROM likes
WHERE likes.id1 IN
   (SELECT f.id2
    FROM friend AS f
    WHERE f.id1 = likes.id2)
AND likes.id2 IN
   (SELECT l.id2
    FROM likes AS l
    WHERE l.id1 = likes.id1)
AND likes.id1 NOT IN
   (SELECT l.id2
    FROM likes AS l
    WHERE l.id1 = likes.id2);

-- Q3. For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself.
INSERT INTO friend(id1, id2)
SELECT DISTINCT f.id1, f2.id2
FROM friend f, friend f2
WHERE f.id2 = f2.id1 
AND f.id1 != f2.id2 
AND f2.id2 NOT IN (SELECT id2 FROM friend f3 WHERE f3.id1 = f.id1)