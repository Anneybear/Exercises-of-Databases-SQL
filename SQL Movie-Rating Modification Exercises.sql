-- Q1. Add the reviewer Roger Ebert to your database, with an rID of 209.
INSERT INTO reviewer VALUES (209, 'Roger Ebert')

-- Q2. For all movies that have an average rating of 4 stars or higher, add 25 to the release year.
UPDATE movie
SET year = year + 25
WHERE mID in (SELECT mID FROM rating 
			  GROUP BY mID
			  HAVING AVG(stars)>=4);

-- Q3. Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.
DELETE FROM rating
WHERE mID IN (SELECT mID FROM movie
			  WHERE year < 1970 OR year > 2000)
AND stars < 4;