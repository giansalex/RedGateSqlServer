SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherRMCons_X_Fecha]
@RucE nvarchar(11),
@FecIni datetime,
@FecFin datetime,
@msj varchar(100) output
as
select 
	v.RucE,
	v.NroReg,
	v.Cd_Vou,
	v.Cd_TD,td.Descrip as NomDoc,v.NroDoc,
	v.Debe,
	v.Haber,
	v.Cd_Mda,md.Simbolo,
	v.Cd_Area, ar.Descrip as NomArea,
	v.Cd_MR,mo.Nombre as NomMO,
	v.Usu,
	convert(nvarchar,v.FecMov,103) as FecMov, convert(nvarchar,v.FecMov,8) as HorMov,
	v.Cd_Est,es.Nombre as NomEst
from VoucherRM v
	left join TipDoc td on td.Cd_TD=v.Cd_TD
	left join Moneda md on v.Cd_Mda=md.Cd_Mda
	left join Area ar on ar.RucE=v.RucE and ar.Cd_Area=v.Cd_Area
	left join Modulo mo on mo.Cd_MR=v.Cd_MR
	left join Estado es on es.Cd_Est=v.Cd_Est
where v.RucE=@RucE and v.FecMov>=@FecIni and v.FecMov<=@FecFin
print @msj
GO
