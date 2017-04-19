SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[Srv_ConsultaReporteAConsultar] 
	@RucE nvarchar(11),
	@TareaProgramadaID char(10)
As
SELECT *
  FROM [dbo].[View_ParametrosXReporte]
 Where RucE = @RucE And TareaProgramadaID = @TareaProgramadaID
GO
