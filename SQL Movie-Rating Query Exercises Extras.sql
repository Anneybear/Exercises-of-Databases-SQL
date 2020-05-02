-- Q1. Find the names of all reviewers who rated Gone with the Wind.
select distinct name from Reviewer re
join Rating r
on re.rID = r.rID
join Movie m 
on m.mID = r.mID
where m.mID = 101;

-- Q2. For any rating where the reviewer is the same as the director of the movie, 
-- return the reviewer name, movie title, and number of stars.
select name, title, stars
from Reviewer re
join Rating r
on re.rID = r.rID
join Movie m 
on m.mID = r.mID
where m.director = re.name;

-- Q3. Return all reviewer names and movie names together in a single list, alphabetized. 
-- (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)
select name from Reviewer
union
select title from Movie
order by name, title;

-- Q4. Find the titles of all movies not reviewed by Chris Jackson. 
select m.title from Movie m
where m.mID not in 
(select distinct r.mID from Rating r
where r.rID = (select re.rID from Reviewer re 
where re.name = 'Chris Jackson'))

-- Q5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
-- Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
-- For each pair, return the names in the pair in alphabetical order.
SELECT DISTINCT rev1.name, rev2.name
FROM Reviewer rev1, Reviewer rev2, Rating r1, Rating r2
WHERE r1.rID = rev1.rID
AND r2.rID = rev2.rID
AND r1.mID = r2.mID
AND rev1.name < rev2.name
order by rev1.name, rev2.name;

-- Q6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
select r.name, m.title, rat.stars
from (select * from Rating
      where stars = (select min(stars) from rating)) rat, Movie m, Reviewer r
					 where r.rID = rat.rID and M.mID = rat.mID;

-- Q7. List movie titles and average ratings, from highest-rated to lowest-rated. 
-- If two or more movies have the same average rating, list them in alphabetical order.
select title, avg(stars) as avg_rating
from Movie join Rating
on Rating.mID = Movie.mID
group by title
order by avg_rating desc;

-- Q8. Find the names of all reviewers who have contributed three or more ratings. 
select name from 
(select rID
from rating group by rID
having count(*)>= 3) ra
join reviewer r on r.rID = ra.rID;

-- Q9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title.
select m.title, m.director
from (select director 
	  from Movie
      group by director
      having count(*) > 1) m2
join Movie m on m.director = m2.director
order by m.director, m.title;

-- Q10. Find the movie(s) with the highest average rating.
SELECT mov.title, AVG(rat.stars) 
FROM movie mov, rating rat
WHERE mov.mID = rat.mID
GROUP BY mov.title
HAVING AVG(rat.stars) = (SELECT MAX(ma.avg) 
      FROM (SELECT mID, AVG(stars) AS avg FROM Rating
            GROUP BY mID) ma)
ORDER BY mov.title DESC;

-- Q11. Find the movie(s) with the lowest average rating.
SELECT mov.title, AVG(rat.stars) 
FROM movie mov, rating rat
WHERE mov.mID = rat.mID
GROUP BY mov.title
HAVING AVG(rat.stars) = (SELECT MIN(ma.avg) 
      FROM (SELECT mID, AVG(stars) AS avg FROM Rating
            GROUP BY mID) ma)
ORDER BY mov.title DESC;

-- Q12. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. 
-- Ignore movies whose director is NULL.
SELECT mov.director, mov.title, MAX(rat.stars)
FROM movie mov, rating rat
WHERE mov.mid = rat.mid
GROUP BY mov.director
HAVING mov.director is not null;