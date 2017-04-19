SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Vta_Cliente2ConsUn_X_ND] 
@RucE nvarchar(11),
@Cd_TDI nvarchar(2),
@NDoc nvarchar(15),
@msj varchar(100) output
as



/* MARCO ESTO ESTA MAL
if not exists (select * from Cliente2 where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@NDoc)
	set @msj = 'Cliente no existe'
else	select a.*,b.Cta from Cliente2 a, Cliente b where a.RucE=@RucE and a.Cd_TDI=@Cd_TDI and a.NDoc=@NDoc and a.RucE=b.RucE and a.Cd_Aux=b.Cd_Aux
print @msj
*/

if not exists (select * from Cliente2 where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@NDoc)
	set @msj = 'Cliente no existe'
else	select a.* from Cliente2 a where a.RucE=@RucE and a.Cd_TDI=@Cd_TDI and a.NDoc=@NDoc
print @msj


--Prueba 
--exec pvo.Vta_Cliente2ConsUn_X_ND '11111111111', '01', '12312313', null

--Busca un cliente en la tabla Cliente 2 en base a su tipo y numero de documento
--MP: JUE 16/09/2010 - Creado 
--PV:  JUE 28/10/2010 - Mdf:  sp estaba mal
GO
