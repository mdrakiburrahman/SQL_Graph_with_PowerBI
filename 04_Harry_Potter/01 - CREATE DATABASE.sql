-- Cleanup
USE master
GO

DROP DATABASE IF EXISTS [SQL_GRAPH_Weasley_Family]
GO

-- Create empty Database
CREATE DATABASE [SQL_GRAPH_Weasley_Family]
 CONTAINMENT = NONE
GO