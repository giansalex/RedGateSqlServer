SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaRMCons_X_Fecha]
@RucE nvarchar(11),
@FecIni datetime,
@FecFin datetime,
@msj varchar(100) output
as
select
	vr.RucE,
	vr.NroReg,
	vr.Cd_Vta,
	vr.Cd_TD,td.Descrip as NomDoc,vr.NroDoc,
	vr.Total,
	vr.Cd_Mda,md.Simbolo,
	vr.Cd_Area, ar.Descrip as NomArea,
	vr.Cd_MR,mo.Nombre as NomMO,
	vr.Usu,
	convert(nvarchar,vr.FecMov,103) as FecMov, convert(nvarchar,vr.FecMov,8) as HorMov,
	vr.Cd_Est,es.Nombre as NomEst
from	VentaRM vr
	left join TipDoc td on td.Cd_TD=vr.Cd_TD
	left join Moneda md on vr.Cd_Mda=md.Cd_Mda
	left join Area ar on ar.RucE=vr.RucE and ar.Cd_Area=vr.Cd_Area
	left join Modulo mo on mo.Cd_MR=vr.Cd_MR
	left join Estado es on es.Cd_Est=vr.Cd_Est
	where vr.RucE=@RucE and vr.FecMov>=@FecIni and vr.FecMov<=@FecFin
print @msj
GO
