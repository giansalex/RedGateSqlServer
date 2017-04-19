SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CfgCajaConsUn]
@RucE nvarchar(11),
@Cd_Caja nvarchar(6),
@msj varchar(100) output
as
if not exists (select * from CfgCaja where RucE=@RucE and Cd_Caja=@Cd_Caja)
	set @msj = 'Configuracion Caja no existe'
else	select * from CfgCaja where RucE=@RucE and Cd_Caja=@Cd_Caja
print @msj


--MP : 03/02/2012 : <Creacion del procedimiento almacenado>
GO
