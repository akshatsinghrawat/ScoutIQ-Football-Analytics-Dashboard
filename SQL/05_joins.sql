CREATE TABLE clubs AS
SELECT DISTINCT Squad, Comp
FROM players;

CREATE TABLE leagues AS
SELECT DISTINCT Comp
FROM players;

-- Query 1
-- Which league does each player belong to?

SELECT p.Player, p.Squad, c.Comp
FROM players p
INNER JOIN clubs c
ON p.Squad = c.Squad;


-- Query 2
-- Show all players along with their league information.

SELECT p.Player, p.Squad, c.Comp
FROM players p
LEFT JOIN clubs c
ON p.Squad = c.Squad;


-- Query 3
-- Which players have scored more goals than the overall
-- average player?

SELECT Player, Squad, Gls
FROM players
WHERE Gls >
(
    SELECT AVG(Gls)
    FROM players
);


-- Query 4
-- What is the average number of goals scored by players in each club?
-- (CTE Example)

WITH ClubGoals AS
(
    SELECT Squad,
           AVG(Gls) AS Avg_Goals
    FROM players
    GROUP BY Squad
)

SELECT *
FROM ClubGoals
ORDER BY Avg_Goals DESC;


-- Query 5
-- Who are the Top 10 goal scorers?
-- (CTE + ROW_NUMBER)

WITH RankedPlayers AS
(
    SELECT Player,
           Squad,
           Gls,
           ROW_NUMBER() OVER(ORDER BY Gls DESC) AS Goal_Rank
    FROM players
)

SELECT *
FROM RankedPlayers
WHERE Goal_Rank <= 10;


-- Query 6
-- Which players have scored more goals than the overall average?
-- (Subquery)

SELECT Player,
       Squad,
       Gls
FROM players
WHERE Gls >
(
    SELECT AVG(Gls)
    FROM players
);


-- Query 7
-- Which players aged 23 or below have scored above their league average?
-- (Correlated Subquery)

SELECT Player,
       Squad,
       Comp,
       Age,
       Gls
FROM players p
WHERE Age <= 23
AND Gls >
(
    SELECT AVG(Gls)
    FROM players
    WHERE Comp = p.Comp
);


-- Query 8
-- Who are the Top 5 goal scorers in every league?
-- (CTE + Window Function)

WITH RankedPlayers AS
(
    SELECT Player,
           Squad,
           Comp,
           Gls,
           ROW_NUMBER() OVER(PARTITION BY Comp ORDER BY Gls DESC) AS League_Rank
    FROM players
)

SELECT *
FROM RankedPlayers
WHERE League_Rank <= 5;


-- Query 9
-- Which club has scored the highest number of goals?

SELECT Squad,
       SUM(Gls) AS Total_Goals
FROM players
GROUP BY Squad
HAVING SUM(Gls) =
(
    SELECT MAX(Total_Goals)
    FROM
    (
        SELECT SUM(Gls) AS Total_Goals
        FROM players
        GROUP BY Squad
    ) t
);


-- Query 10
-- Which clubs have the highest total attacking contribution?
-- (Goals + Assists)

WITH ClubStats AS
(
    SELECT Squad,
           SUM(Gls) AS Goals,
           SUM(Ast) AS Assists
    FROM players
    GROUP BY Squad
),
ClubContribution AS
(
    SELECT Squad,
           Goals + Assists AS Goal_Contribution
    FROM ClubStats
)

SELECT *
FROM ClubContribution
ORDER BY Goal_Contribution DESC;