SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Rpt_RubrosRptConsXTipoRpt]

@Cd_TR nvarchar(2),
@msj varchar(100) output

AS
	Select * From RubrosRpt Where Cd_TR=@Cd_TR and Estado=1
	
GO
