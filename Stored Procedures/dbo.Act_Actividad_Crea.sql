SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Act_Actividad_Crea] 
    @Cd_Act int,
    @Ruc nvarchar(11),
    @Nom varchar(300),
    @Descrip varchar(2000),
    @DescripInc varchar(2000),
    @FecInc datetime,
    @FecInicio datetime,
    @HrsEstm numeric(5, 2),
    @HrsReales numeric(5, 2),
    @FecFin datetime,
    @Prdad1L2L numeric(3, 2),
    @Prdad4L numeric(3, 2),
    @PorcAvzdo numeric(5, 2),
    @Predec int,
    @Cd_TrabEnc nvarchar(10),
    @Cd_TrabRsp nvarchar(10),
    @Cd_TA char(2),
    @Cd_EA char(2),
    @UsuCrea nvarchar(10),
    @msj varchar(100) output
AS

if exists (select * from Actividad where Cd_Act=@Cd_Act)
	set @msj = 'Actividad ya existe'
else
begin
	INSERT INTO [dbo].[Actividad] ([Cd_Act], [Ruc], [Nom], [Descrip], [DescripInc], [FecInc], [FecInicio], [HrsEstm], [HrsReales], [FecFin], [Prdad1L2L], [Prdad4L], [PorcAvzdo], [Predec], [Cd_TrabEnc], [Cd_TrabRsp], [Cd_TA], [Cd_EA], [FecReg], [UsuCrea])
	SELECT @Cd_Act, @Ruc, @Nom, @Descrip, @DescripInc, @FecInc, @FecInicio, @HrsEstm, @HrsReales, @FecFin, @Prdad1L2L, @Prdad4L, @PorcAvzdo, @Predec, @Cd_TrabEnc, @Cd_TrabRsp, @Cd_TA, @Cd_EA, getdate(), @UsuCrea
	
	if @@rowcount <= 0
		set @msj = 'Actividad no pudo ser ingresada'
end
print @msj
GO
