SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Rpt_InvBlc_Cta12]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
@FecIni datetime,
@FecFin datetime,
@Nivel int,
@msj varchar(100) output
as
	if not exists ( select top 1 *from voucher where RucE=@RucE and Ejer=@Ejer and NroCta like '12%')
		set @msj='No se encontraron Registros de Inventario de Balances para la Cuenta 12'
	else
	begin
	--Cuerpo Reporte
		select 	Max(cl.Cd_TDI) as Cd_TDI, Max(cl.NDoc) as NDoc,Max(vou.Cd_Clt) as Cd_Clt, case(isnull(max(cl.RSocial),'')) when '' then Max(cl.ApPat) + ' ' + Max(cl.ApMat) + ', '+ Max(cl.Nom) else Max(cl.RSocial) end as Cliente,
			Convert(nvarchar,Vou.FecMov,103) as FecMov, case(@Cd_Mda) when '01' then (Sum(vou.MtoD) - Sum(vou.MtoH)) when '02' then (sum(vou.MtoD_ME) - sum(vou.MtoH_ME)) end as Saldo, Max(vou.NroCta) as NroCta,left(vou.NroCta,@Nivel) NroCta
		from 	Voucher vou inner join Cliente2 cl on vou.RucE=cl.RucE  and Vou.Cd_Clt=cl.Cd_Clt 
		where 	vou.RucE=@RucE and vou.Ejer=@Ejer and Vou.NroCta like '12%' and vou.FecMov between Convert(nvarchar,@FecIni,103) and Convert(nvarchar,@FecFin,103)
		group by vou.Cd_Clt,Convert(nvarchar,Vou.FecMov,103),left(NroCta,@Nivel)
		order by Vou.Cd_Clt, FecMov

	--Cabecera Reporte
	select @RucE as RucE,@Ejer as Ejer,RSocial, case(@Cd_Mda) when '01' then 'EN SOLES' when '02' then 'EN DOLARES' end as Moneda, 'Desde '+Convert(nvarchar,@FecIni,103) +' Hasta '+ Convert(nvarchar,@FecFin,103) as 'Prdo'
	from Empresa Where Ruc=@RucE
	end

-- Leyenda --
--JJ 14/02/2011: <Creacion del Procedimiento almacenado>
--DI 16/05/2011: <Se cambio codigo order by Vou.Cd_Clt, vou.FecMov por order by Vou.Cd_Clt, FecMov>


GO
