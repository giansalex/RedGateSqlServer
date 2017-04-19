SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_AuxiliarConsUn_X_ND] -->Consulta por Nro de Documento
@RucE nvarchar(11),
@Cd_TDI nvarchar(2),
@NDoc nvarchar(15),
@msj varchar(100) output
as
if not exists (select * from Auxiliar where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@NDoc)
	set @msj = 'Auxiliar no existe'
else	select a.*,c.Cta as CtaCli, p.Cta as CtaPro from Auxiliar a
	left join Cliente c on a.RucE=c.RucE and a.Cd_Aux=c.Cd_Aux
	left join Proveedor p  on a.RucE=p.RucE and a.Cd_Aux=p.Cd_Aux
	where a.RucE=@RucE and a.Cd_TDI=@Cd_TDI and a.NDoc=@NDoc
print @msj
GO
