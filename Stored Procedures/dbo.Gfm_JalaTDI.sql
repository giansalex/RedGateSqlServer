SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_JalaTDI]
@RucE nvarchar(11)
as 

SELECT RucE,Cd_TDIClt,Cd_TDIPrv,Cd_TDIVdr,Cd_TDITra FROM dbo.CfgGeneral WHERE RucE=@RucE
GO
