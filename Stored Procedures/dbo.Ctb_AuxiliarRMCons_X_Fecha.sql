SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AuxiliarRMCons_X_Fecha]
@RucE nvarchar(11),
@FecIni datetime,
@FecFin datetime,
@msj varchar(100) output
as

select 	ar.RucE, ar.NroReg, ar.Cd_Aux, ar.Cd_TDI, 
       	tdi.NCorto as NCortoTDI, ar.NroDoc, ar.Cd_TA, ta.Nombre as NomTA, 
     	ar.Cd_MR, mo.Nombre as NomMR, ar.Usu,
	convert(nvarchar,ar.FecMov,103) as FecMov, convert(nvarchar,ar.FecMov,24) as HorMov,
	ar.Cd_Est, est.Nombre as NombreEst

from 	AuxiliarRM ar
	left join TipDocIdn tdi on tdi.Cd_TDI=ar.Cd_TDI
	left join Estado est on est.Cd_Est=ar.Cd_Est
	left join TipAux ta on ta.Cd_TA=ar.Cd_TA
	left join Modulo mo on mo.Cd_MR=ar.Cd_MR

--where ar.RucE='11111111111' and ar.FecMov>='01/01/2000' and ar.FecMov<='30/12/2009'
where ar.RucE=@RucE and ar.FecMov>=@FecIni and ar.FecMov<=@FecFin
print @msj
GO
