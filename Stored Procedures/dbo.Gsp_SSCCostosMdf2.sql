SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SSCCostosMdf2]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Descrip varchar(50),
@NCorto varchar(10),
@IB_Psp bit,
@CA01 varchar(8000),
@CA02 varchar(8000),
@CA03 varchar(8000),
@CA04 varchar(8000),
@CA05 varchar(8000),
@msj varchar(100) output
as
if not exists (select * from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS)
	set @msj = 'Sub Sub Centro de Costos no existe'
else
begin
	update CCSubSub set RucE=@RucE, Cd_CC=@Cd_CC, Cd_SC=@Cd_SC, Cd_SS=@Cd_SS, Descrip=@Descrip, NCorto=@NCorto,
			IB_Psp=@IB_Psp, CA01 = @CA01, CA02 = @CA02, CA03 = @CA03, CA04 = @CA04, CA05 = @CA05
	where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS
	
	if @@rowcount <= 0
	   set @msj = 'Sub Sub Centro de Costos no pudo ser modificado'
end
print @msj


--MP : 21/03/2012 : <Creacion del procedimiento almacenado con Campos Adicionales>
--AC : 02/01/2013 : <NCorto modificado de 6 a 10 caracteres>


GO
