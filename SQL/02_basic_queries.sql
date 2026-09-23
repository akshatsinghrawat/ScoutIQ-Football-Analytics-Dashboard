/*
===============================================================================
                           ScoutIQ
              Football Analytics & Player Scouting Platform
===============================================================================

File Name : 02_basic_queries.sql

Objective:
-----------
Learn the fundamentals of SQL by answering real football scouting
business questions.

Topics Covered:
---------------
1. SELECT
2. WHERE
3. ORDER BY
4. LIMIT
5. DISTINCT
6. LIKE
7. BETWEEN
8. IN

===============================================================================
*/

USE scoutiq;

-- (1) Total Players
SELECT COUNT(*) AS total_players FROM players;

-- (2) Basic Player Information
SELECT player,squad,comp,pos,age FROM players;

-- (3) Top 20 Goal Scorers in descending order
SELECT player,gls,squad,comp FROM players ORDER BY gls DESC LIMIT 20;

-- (4) Young Talents(age<=21)
SELECT player,age,squad FROM players WHERE age <=21 ORDER BY AGE;

-- (5) Premier League Players
SELECT player,squad,comp FROM players WHERE comp = 'eng Premier League' ORDER BY squad;

-- (6) Top 10 Youngest Players
SELECT player,age,squad FROM players ORDER BY age ASC LIMIT 10;

-- (7) Finding All The Available Leagues
SELECT DISTINCT comp FROM players;

-- (8) Players Between Ages 20 and 25
SELECT player,age,squad FROM players WHERE age BETWEEN 20 AND 25 ORDER BY age;

-- (9) Players from Multiple Leagues
SELECT player,squad,comp FROM players WHERE comp in ('eng Premier League','es La Liga') ORDER BY comp;

-- (10) Players whose club name contains the word "United"
SELECT player,squad,comp FROM players WHERE squad LIKE '%Utd%' ORDER BY player;

-- (11) Players that are 21 years old or younger and have scored more than 10 goals?
SELECT player,gls,age,squad FROM players WHERE age<=21 AND gls>10 ORDER BY gls DESC;

-- (12) Players who play either in the Premier League or in La Liga
SELECT player,squad,comp FROM players WHERE comp='eng Premier League' OR comp='es La Liga' ORDER BY comp,player;

-- (13) Players that are not playing in the Premier League
SELECT player,squad,comp FROM players WHERE NOT comp='eng Premier League' ORDER BY comp;

-- (14) The total goal contribution (Goals + Assists) of each player
SELECT player,squad,gls,ast,(gls+ast) AS total_contribution FROM players ORDER BY total_contribution DESC;
 
-- (15) Young attackers (≤ 23 years old) that have the highest goal contributions 

SELECT player,squad,age,gls,ast,Goal_Contributions FROM players WHERE age<=23 AND pos='FW' ORDER BY Goal_Contributions DESC LIMIT 15;

-- (16) Midfielders that have created the most goals through assists
SELECT Player,Squad,Age,Ast,Gls FROM players WHERE Pos LIKE '%MF%'ORDER BY Ast DESC LIMIT 15;

-- (17) Players have scored the most goals while playing at least 900 minutes
SELECT player,squad,gls,min FROM players WHERE min>=900 ORDER BY gls DESC LIMIT 15;

-- (18) Players with the Highest Goals per 90 Minutes
SELECT Player, Squad, Min, Goals_per90 FROM players WHERE Min >= 900 ORDER BY Goals_per90 DESC LIMIT 15;

-- (19) Top players by Goal Contributions per 90 (minimum 900 minutes)
SELECT Player, Squad, Min, GC_per90 FROM players WHERE Min >= 900 ORDER BY GC_per90 DESC LIMIT 15;

-- (20) Top young players by Goal Contributions
SELECT Player, Squad, Age, Gls, Ast, (Gls + Ast) AS Total_Contribution FROM players WHERE Age <= 23 ORDER BY Total_Contribution DESC LIMIT 15;

-- (21) Top goalscorers aged 30 or above
SELECT Player, Squad, Age, Gls FROM players WHERE Age >= 30 ORDER BY Gls DESC LIMIT 15;

-- (22) Young forwards with at least 10 goals
SELECT Player, Squad, Age, Gls FROM players WHERE Age <= 23 AND Pos LIKE '%FW%' AND Gls >= 10 ORDER BY Gls DESC;

-- (23) Players with at least 10 goals and 10 assists
SELECT Player, Squad, Gls, Ast FROM players WHERE Gls >= 10 AND Ast >= 10 ORDER BY Gls DESC;

-- (24) Players with at least 20 total goal contributions
SELECT Player, Squad, Gls, Ast, (Gls + Ast) AS Total_Contribution FROM players WHERE (Gls + Ast) >= 20 ORDER BY Total_Contribution DESC;

-- (25) ScoutIQ transfer shortlist
SELECT Player, Squad, Age, Min, Gls, Ast, (Gls + Ast) AS Total_Contribution FROM players WHERE Age <= 23 AND Pos LIKE '%FW%' AND Min >= 900 AND (Gls + Ast) >= 15 ORDER BY Total_Contribution DESC;