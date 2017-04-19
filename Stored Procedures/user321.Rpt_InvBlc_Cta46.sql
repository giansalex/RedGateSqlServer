SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Rpt_InvBlc_Cta46]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
@FecIni datetime,
@FecFin datetime,
@Nivel int,
@msj varchar(100) output
as
	if not exists ( select top 1 *from voucher where RucE=@RucE and Ejer=@Ejer and NroCta like '46%')
		set @msj='No se encontraron Registros de Inventario de Balances para la Cuenta 46'
	else
	begin
	--Cuerpo Reporte
		select 	Max(pv.Cd_TDI) as Cd_TDI, Max(pv.NDoc) as NDoc,Max(vou.Cd_Prv) as Cd_Prv, case(isnull(max(pv.RSocial),'')) when '' then Max(pv.ApPat) + ' ' + Max(pv.ApMat) + ', '+ Max(pv.Nom) else Max(pv.RSocial) end as Proveedor,
			Convert(nvarchar,Vou.FecMov,103) as FecMov,Max(vou.Glosa) as Glosa,case(@Cd_Mda) when '01' then (Sum(vou.MtoD) - Sum(vou.MtoH))*-1 when '02' then (sum(vou.MtoD_ME) - sum(vou.MtoH_ME))*-1 end as Saldo,left(vou.NroCta,@Nivel) NroCta
		from 	Voucher vou inner join proveedor2 pv on vou.RucE=pv.RucE  and Vou.Cd_Prv=pv.Cd_Prv 
		where 	vou.RucE=@RucE and vou.Ejer=@Ejer and Vou.NroCta like '46%' and vou.FecMov between Convert(nvarchar,@FecIni,103) and Convert(nvarchar,@FecFin,103)
		group by vou.Cd_Prv,Convert(nvarchar,Vou.FecMov,103),left(NroCta,@Nivel)
		order by Vou.Cd_Prv, FecMov
	--Cabecera Reporte
	select @RucE as RucE,@Ejer as Ejer,RSocial,case(@Cd_Mda) when '01' then 'EN SOLES' when '02' then 'EN DOLARES' end as Moneda,'Desde '+Convert(nvarchar,@FecIni,103) +' Hasta '+ Convert(nvarchar,@FecFin,103) as 'Prdo'
	from Empresa Where Ruc=@RucE
	end
	
-- Leyenda --
--JJ 14/02/2011: <Creacion del Procedimiento almacenado>
--DI 16/05/2011: <Se cambio codigo order by Vou.Cd_Clt, vou.FecMov por order by Vou.Cd_Clt, FecMov>
--20428875282


GO
