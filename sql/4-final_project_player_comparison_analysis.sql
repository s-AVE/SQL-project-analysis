USE maven_advanced_sql;

-- ASSIGNMENT: Player Comparison Analysis
/*
Using the Sean Lahman Baseball Database, answer the following questions (hints below)
a) Wich player have the same birthday?
b) Create a summary table that shows for each team, what percent of players bat right, left, and both
c) How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?
*/

SELECT * FROM players;
SELECT * FROM salaries;

-- a) Wich player have the same birthday?
WITH birth AS (
	SELECT
		playerID
		,CONCAT(nameFirst, ' ', nameLast) AS namePlayer
		,CAST(CONCAT(birthYear, '-', birthMonth, '-', birthDay) AS DATE) AS birthDate
	FROM
		players
	)
SELECT
	birthDate
    ,GROUP_CONCAT(namePlayer SEPARATOR'; ') AS players
FROM
	birth
WHERE
	birthDATE IS NOT NULL
GROUP BY
	birthDate
HAVING
	COUNT(namePlayer) >1;

-- b) Create a summary table that shows for each team, what percent of players bat right, left, and both
SELECT
	playerID, bats
FROM
	players;

SELECT
	sl.teamID
    ,COUNT(sl.playerID) AS total_players
    ,ROUND(SUM(CASE WHEN bats = 'R' THEN 1 ELSE 0 END) / COUNT(sl.playerID) *100, 2) AS bats_right_inPercent
    ,ROUND(SUM(CASE WHEN bats = 'L' THEN 1 ELSE 0 END) / COUNT(sl.playerID) *100, 2) AS bats_left_inPercent
    ,ROUND(SUM(CASE WHEN bats = 'B' THEN 1 ELSE 0 END) / COUNT(sl.playerID) *100, 2) AS bats_both_inPercent
FROM
	salaries AS sl
LEFT JOIN
	players AS pl
    ON sl.playerID = pl.playerID
GROUP BY
	sl.teamID
ORDER BY
	COUNT(sl.playerID) DESC;
    
-- c) How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?
    
WITH wh AS (
SELECT
	FLOOR(YEAR(debut)/10)*10 AS decade
    ,ROUND(AVG(weight), 2) AS avg_weight
    ,ROUND(AVG(height), 2) AS avg_height
FROM
	players
GROUP BY
    decade
	)
SELECT
	decade
    ,avg_weight - LAG(avg_weight) OVER(ORDER BY decade) weight_diff
    ,avg_height - LAG(avg_height) OVER(ORDER BY decade) height_diff
FROM
	wh
WHERE
	decade IS NOT NULL;
