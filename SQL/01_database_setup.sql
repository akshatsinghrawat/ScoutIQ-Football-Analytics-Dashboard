/*
===============================================================================
                           ScoutIQ
        Football Analytics & Player Scouting Platform
===============================================================================

File Name : 01_database_setup.sql

Objective:
-----------
This file initializes the ScoutIQ database and verifies that the
player dataset has been successfully imported into MySQL.

Dataset:
--------
players_final.csv

Total Records : 2846
Total Columns : 171

Import Method:
--------------
Python (Pandas + SQLAlchemy)

Database:
---------
scoutiq

Table:
------
players

===============================================================================
*/

-- ============================================================================
-- Step 1 : Create Database
-- ============================================================================

CREATE DATABASE IF NOT EXISTS scoutiq;

-- ============================================================================
-- Step 2 : Use Database
-- ============================================================================

USE scoutiq;

-- ============================================================================
-- Verification 1
-- Total number of players
-- ============================================================================

SELECT COUNT(*) AS total_players
FROM players;

-- Expected Output:
-- 2846

-- ============================================================================
-- Verification 2
-- View table structure
-- ============================================================================

DESCRIBE players;

-- ============================================================================
-- Verification 3
-- Preview first five records
-- ============================================================================

SELECT *
FROM players
LIMIT 5;

-- ============================================================================
-- Verification 4
-- Total number of columns
-- ============================================================================

SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'scoutiq'
AND TABLE_NAME = 'players';

-- Expected Output:
-- 171