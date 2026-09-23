-- (1) Number of Players in Each League
SELECT comp,COUNT(*) AS total_players
FROM players
GROUP BY comp
ORDER BY total_players DESC;

-- (2) Number of Players in Each Club
SELECT squad,COUNT(*) as squad_size
FROM players 
GROUP BY squad
ORDER BY squad_size DESC;

-- (3) Average Age of Players in Each League
SELECT comp,ROUND(AVG(age),2) AS avg_age
FROM players
GROUP BY comp
ORDER BY avg_age;

-- (4) Average Age of Each Club
SELECT squad,ROUND(AVG(age),2) AS average_age
FROM players
GROUP BY squad
ORDER BY average_age DESC;

-- (5) Total Goals Scored by Each League
SELECT comp,SUM(gls) AS total_goals
FROM players 
GROUP BY comp
ORDER BY total_goals DESC;

-- (6) Total Goals scored by each club
SELECT squad,SUM(gls) AS total_goals
FROM players
GROUP BY squad
ORDER BY total_goals DESC;

-- (7) League with the Highest Average Goals per Player
SELECT comp,ROUND(AVG(gls),2) as average_goals
FROM players
GROUP BY comp
ORDER BY average_goals DESC;

-- (8) Maximum Goals Scored by a Player in Each League
SELECT comp,MAX(gls) as maximum_goals
FROM players
GROUP BY comp
ORDER BY maximum_goals DESC;

-- (9) Youngest Player in Each League
SELECT comp,MIN(age) as youngest_player
FROM players
GROUP BY comp
ORDER BY youngest_player;

-- (10) Club Performance Summary
SELECT Squad,COUNT(*) AS Total_Players,ROUND(AVG(Age),2) AS Average_Age,SUM(Gls) AS Total_Goals
FROM players
GROUP BY Squad
ORDER BY Total_Goals DESC;

-- (11) Clubs with More Than 20 Players
SELECT squad,COUNT(*) AS total_players
FROM players
GROUP BY squad
HAVING COUNT(*)>20
ORDER BY total_players DESC;

-- (12) Clubs with More Than 50 Total Goals
SELECT squad,SUM(gls) as total_goals
FROM players 
GROUP BY squad 
HAVING SUM(gls)>50
ORDER BY total_goals DESC;

-- (13) Clubs with the Most Young Players (U23)
SELECT Squad, COUNT(*) AS Young_Players
FROM players
WHERE Age <= 23
GROUP BY Squad
ORDER BY Young_Players DESC;

-- (14) Average Goals per 90 Minutes by League
SELECT Comp, ROUND(AVG(Goals_per90),2) AS Avg_Goals_per90
FROM players
GROUP BY Comp
ORDER BY Avg_Goals_per90 DESC;

-- (15) Average Goal Contribution by Club
SELECT Squad, ROUND(AVG(Gls + Ast),2) AS Avg_Goal_Contribution
FROM players
GROUP BY Squad
ORDER BY Avg_Goal_Contribution DESC;

-- (16) Clubs with More Than 3 Players Under 21
SELECT Squad, COUNT(*) AS Under21_Players
FROM players
WHERE Age <= 21
GROUP BY Squad
HAVING COUNT(*) > 3
ORDER BY Under21_Players DESC;

-- (17) Leagues with More Than 300 Total Goals
SELECT Comp, SUM(Gls) AS Total_Goals
FROM players
GROUP BY Comp
HAVING SUM(Gls) > 300
ORDER BY Total_Goals DESC;

-- (18) Average Assists by League
SELECT Comp, ROUND(AVG(Ast),2) AS Avg_Assists
FROM players
GROUP BY Comp
ORDER BY Avg_Assists DESC;

-- (19) Club Statistics Summary
SELECT Squad,
       COUNT(*) AS Total_Players,
       ROUND(AVG(Age),2) AS Avg_Age,
       SUM(Gls) AS Total_Goals,
       SUM(Ast) AS Total_Assists
FROM players
GROUP BY Squad
ORDER BY Total_Goals DESC;

-- (20) Elite Attacking Clubs
SELECT Squad, SUM(Gls + Ast) AS Total_Goal_Contributions
FROM players
GROUP BY Squad
HAVING SUM(Gls + Ast) > 50
ORDER BY Total_Goal_Contributions DESC;



