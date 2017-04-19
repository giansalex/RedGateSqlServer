IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ISPrueba')
CREATE LOGIN [ISPrueba] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [ISPrueba] FOR LOGIN [ISPrueba]
GO
