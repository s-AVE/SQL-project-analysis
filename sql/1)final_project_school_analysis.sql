USE maven_advanced_sql;
/*
Using the Sean Lahman Baseball Database, answer the following questions (hints below)\
a) In each decade, how many schools were there that produced MLB players?
b) What are the names of the top 5 schools that produced the most players?
c) For each decade, what were the names of the top 3 schools that produced the most players?
*/

SELECT * FROM players;
SELECT * FROM schools;
SELECT * FROM school_details;


-- a) In each decade, how many schools were there that produced MLB players?
SELECT
	FLOOR(yearID/10)*10 AS decade
    ,COUNT(DISTINCT schoolID) AS total_school
FROM
	schools
GROUP BY
	decade
ORDER BY
	decade DESC;

-- b) What are the names of the top 5 schools that produced the most players?  
WITH sch_d AS (
	SELECT 
		pl.playerID
		,pl.nameFirst
		,pl.nameLast
		,pl.debut
		,sch.schoolID
		,sch.yearID
		,sd.name_full AS school_name
	FROM
		players AS pl
	LEFT JOIN
		schools AS sch
		ON pl.playerID = sch.playerID
	LEFT JOIN
		school_details AS sd
		ON sch.schoolID = sd.schoolID
	)
SELECT
	school_name
    ,COUNT(playerID) AS total_player
FROM
	sch_d
WHERE
	school_name IS NOT NULL
GROUP BY
	school_name
ORDER BY
	COUNT(playerID) DESC
LIMIT 5;


-- c) For each decade, what were the names of the top 3 schools that produced the most players?
WITH sch_d AS (
	SELECT 
		pl.playerID
		,pl.nameFirst
		,pl.nameLast
		,pl.debut
		,sch.schoolID
		,sch.yearID
		,sd.name_full AS school_name
	FROM
		players AS pl
	LEFT JOIN
		schools AS sch
		ON pl.playerID = sch.playerID
	LEFT JOIN
		school_details AS sd
		ON sch.schoolID = sd.schoolID
	)
    
	,rank_total_player AS (
	SELECT
		DISTINCT school_name
		,FLOOR(yearID/10)*10 AS decade
		,COUNT(DISTINCT playerID) AS total_player
        ,ROW_NUMBER() OVER(PARTITION BY FLOOR(yearID/10)*10 ORDER BY COUNT(playerID) DESC) AS ranking
	FROM
		sch_d
	WHERE
		school_name IS NOT NULL
	GROUP BY
		school_name
		,decade
	ORDER BY
		decade DESC, total_player DESC
	)
    
SELECT
	school_name
    ,decade
    ,total_player
FROM
	rank_total_player
WHERE 
	ranking BETWEEN 1 AND 3;



