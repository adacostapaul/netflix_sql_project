-- Netflix Project


-- CREATING TABLE
CREATE TABLE netflix
(
	show_id VARCHAR (6),
	type VARCHAR (10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
);

--- SELECT TABLE

SELECT * FROM netflix;

-- total content in DB

SELECT
COUNT(*) as total_content 
FROM netflix;

-- Content Types
SELECT 
	DISTINCT type 
FROM netflix


-- 15 Business Problems 

-- 1. Count the number of Movies vs TV Shows


SELECT 
	type,
	COUNT(*) as total_content

FROM netflix
GROUP BY type;


-- 2. Find the most common rating for movies and TV shows
SELECT 
	type,
	rating
FROM
(SELECT 
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking 
FROM netflix
GROUP BY 1,2
) as t1

WHERE
	ranking = 1

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT 
*
FROM netflix
WHERE 
type = 'Movie'
AND
release_year = 2020


-- 4. Identify the longest movie

SELECT 
	*
FROM netflix
WHERE 
type = 'Movie'
AND
duration = (SELECT MAX (duration)FROM netflix)

-- 5. Find content added in the last 5 years
SELECT * , TO_DATE(date_Added, 'Month,DD, YYYY')
FROM NETFLIX
WHERE
date_added = CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years'

6.-- Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT *
FROM
(

SELECT 
	*,
	UNNEST(STRING_TO_ARRAY(director, ',')) as director_name
FROM 
netflix
)
WHERE 
	director_name = 'Rajiv Chilaka'

-- 7. List all TV shows with more than 5 seasons

SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5


-- 8. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1



-- 9. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !


SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5


-- 10. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries'



-- 11. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL


-- 12. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- 13. Find the top 10 actors who have appeared in the highest number of movies produced in India.



SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/*
Question 14:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2




-- End of reports
