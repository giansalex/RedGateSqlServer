SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [pvo].[Com_Proveedor2ConsUn_X_ND] 
@RucE nvarchar(11),
@Cd_TDI nvarchar(2),
@NDoc nvarchar(15),
@msj varchar(100) output
as


if not exists (select * from Proveedor2 where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@NDoc)
	set @msj = 'Proveedor no existe'
else	select a.* from Proveedor2 a where a.RucE=@RucE and a.Cd_TDI=@Cd_TDI and a.NDoc=@NDoc
print @msj


--Prueba 
--exec pvo.Com_Proveedor2ConsUn_X_ND '11111111111', '01', '12312313', null


--PV:  JUE 03/10/2010 - Creado
GO
