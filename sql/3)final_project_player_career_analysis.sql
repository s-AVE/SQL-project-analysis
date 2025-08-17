USE maven_advanced_sql;
/*
Using the Sean Lahman Baseball Database, answer the following questions (hints below)
a) For each player, calculate their age at their first (debut) game, their last game, and their career length (all in years). Sort from longest career to shortest career
b) What team did each player play on for their starting and ending years?
c) How many players started and ended on the same team and also played for over a decade?
*/

SELECT 	* FROM players;
SELECT * FROM salaries;

-- a) For each player, calculate their age at their first (debut) game, their last game, and their career length (all in years). Sort from longest career to shortest career
WITH datePlayers AS (
	SELECT
		playerID
		,CONCAT(nameFirst, ' ', nameLast) AS playerName
		,CAST(CONCAT(birthYear, '-', birthMonth, '-',birthDay) AS DATE) AS dateBirth
		,debut
		,finalGame
	FROM
		players
	)
SELECT
	playerName
    ,ROUND(DATEDIFF(debut, dateBirth)/364) AS ageDebut
    ,ROUND(DATEDIFF(finalGame, dateBirth)/364) AS ageRetire
    ,ROUND(DATEDIFF(finalGame, debut)/364) AS lenghtCareerInYear
FROM
	datePlayers
ORDER BY
	lenghtCareerInYear DESC;

-- b) What team did each player play on for their starting and ending years?  
SELECT
	pl.playerID
    ,CONCAT(pl.nameFirst, ' ', pl.nameLast) AS playerName
    ,sl1.yearID
    ,sl1.teamID
    ,sl2.yearID
    ,sl2.teamID
FROM
	players AS pl
INNER JOIN
	salaries AS sl1
    ON pl.playerID = sl1.playerID
    AND YEAR(pl.debut) = sl1.yearID
INNER JOIN
	salaries AS sl2
    ON pl.playerID = sl2.playerID
    AND YEAR(finalGame) = sl2.yearID
ORDER BY
	YEAR(finalGame) DESC;

-- c) How many players started and ended on the same team and also played for over a decade?
SELECT
	pl.playerID
    ,CONCAT(pl.nameFirst, ' ', pl.nameLast) AS playerName
    ,sl1.yearID AS debutYear
    ,sl1.teamID AS debutTeam
    ,sl2.yearID AS retireYear
    ,sl2.teamID AS retireTeam
    ,sl2.yearID - sl1.yearID AS lengthCareer
FROM
	players AS pl
INNER JOIN
	salaries AS sl1
    ON pl.playerID = sl1.playerID
    AND YEAR(pl.debut) = sl1.yearID
INNER JOIN
	salaries AS sl2
    ON pl.playerID = sl2.playerID
    AND YEAR(finalGame) = sl2.yearID
WHERE
	sl2.yearID - sl1.yearID > 10
ORDER BY
	YEAR(finalGame) DESC;

	