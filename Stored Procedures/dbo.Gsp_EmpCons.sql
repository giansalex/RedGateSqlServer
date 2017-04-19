SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_EmpCons]
@Cd_Prf nvarchar(3),
@msj varchar(100) output
as
/*if not exists (select top 1 * from Empresa)
	set @msj = 'No se encontro Empresa'
else */
/*
select a.Ruc,a.RSocial,a.FecIni,a.Ubigeo,a.Direccion,a.Telef,a.Logo,b.Nombre as 'MdaP',c.Nombre as 'MdaS' 
from Empresa a, Moneda b, Moneda c, AccesoE
where a.Cd_MdaP=b.Cd_Mda and a.Cd_MdaS=c.Cd_Mda and  Cd_Prf=@Cd_Prf and RucE=Ruc
print @msj
*/

select a.Ruc,a.RSocial,a.FecIni,a.Ubigeo,a.Direccion,a.Telef,a.Logo,b.Nombre as 'MdaP',c.Nombre as 'MdaS' 
from Empresa a
inner join Moneda b on a.Cd_MdaP=b.Cd_Mda
inner join Moneda c on a.Cd_MdaS=c.Cd_Mda
inner join AccesoE ae on a.Ruc = ae.RucE
where ae.Cd_Prf=@Cd_Prf and ae.RucE=Ruc
print @msj
GO
