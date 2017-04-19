SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Rpt_InvBlc_Cta50]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
@FecIni datetime,
@FecFin datetime,
@Nivel int,
@msj varchar(100) output

as
	--if not exists ( select top 1 *from voucher where RucE=@RucE and Ejer=@Ejer and left(NroCta,@nivel) like '50%')
	--	begin set @msj='No se encontraron Registros de Inventario de Balances para la Cuenta 50'

	

	
	--else
	
	begin
		-- Detalle
		--select a.NroCta as Codigo
		--,max(c.NomCta) as Denominacion
		--,((Case(@Cd_Mda)when '01' then Case When SUM(a.MtoD)-SUM(a.MtoH) >= 0 Then SUM(a.MtoD)-SUM(a.MtoH) Else 0.00 End else
		--case when SUM(a.MtoD_ME) - SUM(a.MtoH_ME) >= 0 Then SUM(a.MtoD_ME)-SUM(a.MtoH_ME) else 0.00 end end)-(Case(@Cd_Mda)when '01' then Case when SUM(a.MtoD)-SUM(a.MtoH) < 0 then (SUM(a.MtoD)-SUM(a.MtoH))*-1 else 0.00 end else
		--case when SUM(a.MtoD_ME) - SUM(a.MtoH_ME) < 0 then (SUM(a.MtoD_ME)-SUM(a.MtoH_ME))*-1 else 0.00 end end)) as 'Saldo Final'
		--from  voucher a 			
		--	  inner join (select RucE,Ejer,NroCta,NomCta from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta like '40%') as c
		--	  on c.RucE=a.RucE and c.Ejer=a.Ejer and c.NroCta=a.NroCta
		--where 	a.RucE=@RucE and a.Ejer=@Ejer and a.NroCta like '40%' and a.FecMov between Convert(nvarchar,'01/01/2016',103) and Convert(nvarchar,'31/12/2016',103)
		--group by a.NroCta


		-- Cabecera
		select @RucE as RucE,@Ejer as Ejer,RSocial, case(@Cd_Mda) when '01' then 'EN SOLES' when '02' then 'EN DOLARES' end as Moneda, 'Desde '+Convert(nvarchar,@FecIni,103) +' Hasta '+ Convert(nvarchar,@FecFin,103) as 'Prdo'
		from Empresa Where Ruc=@RucE

	end

-- Leyenda
--JJ 18/02/2011	<Creacion de Procedimiento Almacenado>

--exec user321.Rpt_InvBlc_Cta10 '11111111111', '2012', '02', '01/01/2012', '31/12/2013', ''
GO
