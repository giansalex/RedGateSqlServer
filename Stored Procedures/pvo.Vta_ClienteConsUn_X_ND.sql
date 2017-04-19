SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [pvo].[Vta_ClienteConsUn_X_ND] -->Consulta por Nro de Documento
@RucE nvarchar(11),
@Cd_TDI nvarchar(2),
@NDoc nvarchar(15),
@msj varchar(100) output
as
if not exists (select * from Auxiliar where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@NDoc)
	set @msj = 'Cliente no existe'
else	select a.*,b.Cta from Auxiliar a, Cliente b where a.RucE=@RucE and a.Cd_TDI=@Cd_TDI and a.NDoc=@NDoc and a.RucE=b.RucE and a.Cd_Aux=b.Cd_Aux
print @msj
GO
