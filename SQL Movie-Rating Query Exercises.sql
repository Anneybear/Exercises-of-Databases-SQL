-- Q1. Find the titles of all movies directed by Steven Spielberg.
select title
from Movie
where director = 'Steven Spielberg'

-- Q2. Find all years that have a movie that received a rating of 4 or 5, 
-- and sort them in increasing order.
select distinct year
from Movie M join Rating R
on M.mID = R.mID
where stars = 4 or stars = 5
order by year

-- Q3. Find the titles of all movies that have no ratings.
select distinct title
from Movie M left join Rating R
on M.mID = R.mID
where stars is null

-- Q4. Some reviewers didn't provide a date with their rating. 
-- Find the names of all reviewers who have ratings with a NULL value for the date.
select name from Reviewer R
join Rating Ra 
on R.rID = Ra.rID
where ratingDate is null

-- Q5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, 
-- first by reviewer name, then by movie title, and lastly by number of stars.
select name, title, stars, ratingDate
from Movie m join Rating ra
on m.mID = ra.mID
join Reviewer r on ra.rID = r.rID
order by name, title

-- Q6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
-- return the reviewer's name and the title of the movie.
select name,title
from Movie m join Rating ra1
on m.mID = ra1.mID
join Rating ra2
on ra1.rID = ra2.rID
join Reviewer r on ra1.rID = r.rID
where ra1.mID = ra2.mID and ra1.ratingDate < ra2.ratingDate and ra1.stars < ra2.stars;

-- Q7. For each movie that has at least one rating, find the highest number of stars that movie received. 
-- Return the movie title and number of stars. Sort by movie title.
select title, max(stars)
from Movie m join Rating r
on m.mID = r.mID
group by title
order by title;

-- Q8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
-- Sort by rating spread from highest to lowest, then by movie title.
select title, (max(stars) - min(stars)) as 'ratingspread'
from Movie m join Rating r
on m.mID = r.mID
group by title
order by ratingspread desc, title;

-- Q9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
-- (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
-- Don't just calculate the overall average rating before and after 1980.)
select AVG(s1) - AVG(s2) from
(select title, AVG(stars) as s1 from Movie
join Rating on Movie.mID = Rating.mID
where year < 1980
group by title) JOIN 
(select title, avg(stars) as s2 from Movie 
join Rating on Movie.mID = Rating.mID 
where year > 1980
group by title);