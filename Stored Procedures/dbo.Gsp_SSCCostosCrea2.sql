SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SSCCostosCrea2]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Descrip varchar(50),
@NCorto varchar(10),
@CA01 varchar(8000),
@CA02 varchar(8000),
@CA03 varchar(8000),
@CA04 varchar(8000),
@CA05 varchar(8000),
@IB_Psp bit,
@msj varchar(100) output
as
if not exists (select * from CCSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC)
	set @msj = 'No existe Sub Centro de Costos'
else if exists (select * from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS)
	set @msj = 'Ya existe Sub Sub Centro de Costos'
else
begin
	insert into CCSubSub(RucE,Cd_CC,Cd_SC,Cd_SS,Descrip,NCorto,IB_Psp,CA01,CA02,CA03,CA04,CA05)
	              values(@RucE,@Cd_CC,@Cd_SC,@Cd_SS,@Descrip,@NCorto,@IB_Psp,@CA01,@CA02,@CA03,@CA04,@CA05)
	
	if @@rowcount <= 0
	   set @msj = 'Sub Sub Centro de Costos no pudo ser ingresado'
end
print @msj

--MP : 21/03/2012 : <Creacion del procedimiento almacenado con Campos Adicionales>
--AC : 02/01/2013 : <NCorto modificado de 6 a 10 caracteres>


GO
