USE maven_advanced_sql;
/*
Using the Sean Lahman Baseball Database, answer the following questions (hints below)\
a) Return the top 20% of teams in terms of average annual spending
b) For each team, show the cummulative sum of spending over the years
c) Return the first year that each team's cumulative spending surpassed 1 billion
*/

SELECT * FROM players;
SELECT * FROM salaries;

-- a) Return the top 20% of teams in terms of average annual spending
WITH total_spend AS (
	SELECT
		teamID
        ,yearID
        ,SUM(salary) AS total_spend
	FROM
		salaries
	GROUP BY
		teamID
        ,yearID
	ORDER BY
		teamID
        ,yearID
    )
	,avg_spend AS (    
	SELECT
		teamID
		,AVG(total_spend) AS avg_spending
		,NTILE(5) OVER (ORDER BY AVG(total_spend) DESC) AS spend_percentg
	FROM
		total_spend
	GROUP BY
		teamID
	)
SELECT
	teamID
    ,ROUND(avg_spending/1000000, 2) AS avg_spending_in_mil
FROM
	avg_spend
WHERE
	spend_percentg = 1;


-- b) For each team, show the cummulative sum of spending over the years    
WITH team_spending AS (    
	SELECT
		yearID
		,teamID
		,SUM(salary) AS total_spend
	FROM 
		salaries
	GROUP BY
		yearID
		,teamID
	)
SELECT
	yearID
    ,teamID
    ,ROUND(total_spend/1000000, 2) AS total_spend_in_mil
    ,ROUND(SUM(total_spend) OVER(PARTITION BY teamID ORDER BY yearID)/1000000, 2) AS cum_spend_in_mil
FROM
	team_spending;
    
 -- c) Return the first year that each team's cumulative spending surpassed 1 billion   
WITH team_spending AS (    
	SELECT
		yearID
		,teamID
		,SUM(salary) AS spending
	FROM 
		salaries
	GROUP BY
		yearID
		,teamID
	)
	,cumulative_spending AS (
	SELECT
		yearID
		,teamID
		,SUM(spending) OVER(PARTITION BY teamID ORDER BY yearID) AS cum_spend
	FROM
		team_spending
	)
SELECT
	teamID
    ,MIN(yearID) AS year_spend
FROM
	cumulative_spending
WHERE
	cum_spend > 1000000000
GROUP BY
	teamID;