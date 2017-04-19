SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Act_Actividad_ConsUn] 
    @Cd_Act INT,
    @msj varchar(100) output
AS 

if not exists (select * from Actividad where Cd_Act=@Cd_Act)
	set @msj = 'Actividad no existe'
else	SELECT [Cd_Act], [Ruc], [Nom], [Descrip], [DescripInc], [FecInc], [FecInicio], [HrsEstm], [HrsReales], [FecFin], [Prdad1L2L], [Prdad4L], [PorcAvzdo], [Predec], [Cd_TrabRsp], [Cd_TrabEnc], [Cd_TA], [Cd_EA], [FecReg], [UsuCrea], [FecMdf], [UsuMdf] 
	FROM   [dbo].[Actividad] 
	WHERE  ([Cd_Act] = @Cd_Act OR @Cd_Act IS NULL) 
print @msj
GO
