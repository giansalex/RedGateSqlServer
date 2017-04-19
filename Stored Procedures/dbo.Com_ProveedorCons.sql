SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ProveedorCons]
@RucE nvarchar(11),
@msj varchar(100) output
as
/*if not exists (select top 1 * from Cliente where RucE=@RucE)
	set @msj = 'No se encontro Cliente'
else  */
select a.RucE,a.Cd_Aux,b.NCorto as 'Cd_TDI',a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
       a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,c.Cta,a.Estado
from Auxiliar a, TipDocIdn b, Proveedor c where a.RucE=@RucE and a.Cd_Aux=c.Cd_Aux and a.RucE=c.RucE and a.Cd_TDI=b.Cd_TDI
print @msj


GO
