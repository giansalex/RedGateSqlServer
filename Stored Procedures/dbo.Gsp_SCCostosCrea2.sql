SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SCCostosCrea2]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
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
if exists (select * from CCSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC)
	set @msj = 'Ya existe Sub Centro de Costos'
else
begin
	insert into CCSub(RucE,Cd_CC,Cd_SC,Descrip,NCorto,IB_Psp,CA01,CA02,CA03,CA04,CA05)
		   values(@RucE,@Cd_CC,@Cd_SC,@Descrip,@NCorto,@IB_Psp,@CA01,@CA02,@CA03,@CA04,@CA05)
	if @@rowcount <= 0
	   set @msj = 'Sub Centro de Costos no pudo ser ingresado'
	else
	begin
		insert into CCSubSub values(@RucE,@Cd_CC,@Cd_SC,'01010101','GENERAL','GN',0,null,null,null,null,null)
	end
end
print @msj

--MP : 20/03/2012 : <Creacion del procedimiento almacenado con Campos Adicionales>
--02/01/2013 NCorto modificado de 6 a 10 caracteres
GO
