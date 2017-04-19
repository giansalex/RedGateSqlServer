SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Act_Actividad_Mdf] 
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
    @FecReg datetime,
    @UsuCrea nvarchar(10),
    @UsuMdf nvarchar(10),
    @msj varchar(100) output
AS 
if not exists (select * from Actividad where Cd_Act=@Cd_Act)
	set @msj = 'Actividad no existe'
else
begin
	UPDATE [dbo].[Actividad]
	SET    [Cd_Act] = @Cd_Act, [Ruc] = @Ruc, [Nom] = @Nom, [Descrip] = @Descrip, [DescripInc] = @DescripInc, [FecInc] = @FecInc, [FecInicio] = @FecInicio, [HrsEstm] = @HrsEstm, [HrsReales] = @HrsReales, [FecFin] = @FecFin, [Prdad1L2L] = @Prdad1L2L, [Prdad4L] = @Prdad4L, [PorcAvzdo] = @PorcAvzdo, [Predec] = @Predec, [Cd_TrabEnc] = @Cd_TrabEnc, [Cd_TrabRsp] = @Cd_TrabRsp, [Cd_TA] = @Cd_TA, [Cd_EA] = @Cd_EA, [FecReg] = @FecReg, [UsuCrea] = @UsuCrea, [FecMdf] = getdate(), [UsuMdf] = @UsuMdf
	WHERE  [Cd_Act] = @Cd_Act
	if @@rowcount <= 0
		set @msj = 'Actividad no pudo ser modificada'
end
print @msj
GO
