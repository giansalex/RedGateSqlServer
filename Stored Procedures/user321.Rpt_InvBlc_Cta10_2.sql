SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Rpt_InvBlc_Cta10_2]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
@FecIni datetime,
@FecFin datetime,
@msj varchar(100) output

as
	if not exists ( select top 1 *from voucher where RucE=@RucE and Ejer=@Ejer and NroCta like '10%')
		set @msj='No se encontraron Registros de Inventario de Balances para la Cuenta 10'
	
	else
	begin
		-- Detalle
		select  a.NroCta,b.CodSNT_ , Max(c.NomCta) NomCta, 
		--Max(d.CodSNT_) CodSNT_,
		--Max(b.NCtaB) NCtaB, Max(case (b.Cd_Mda)when null then (c.Cd_Mda) Else (b.Cd_Mda) end) as Cd_Mda,
		--Max(b.NCtaB) NCtaB, Max(case(isnull(c.Cd_Mda,'')) when '' Then (c.Cd_Mda) Else (b.Cd_Mda) end  ) as Cd_Mda,
			Max(b.NCtaB) NCtaB, Max( Case when (ISNULL(b.Cd_Mda,'')<>'') then (b.Cd_Mda) else (c.Cd_Mda) end) as Cd_Mda,
			Case(@Cd_Mda)when '01' then Case When SUM(a.MtoD)-SUM(a.MtoH) >= 0 Then SUM(a.MtoD)-SUM(a.MtoH) Else 0.00 End else
			case when SUM(a.MtoD_ME) - SUM(a.MtoH_ME) >= 0 Then SUM(a.MtoD_ME) - SUM(a.MtoH_ME) else 0.00 end end as Deudor,
			Case(@Cd_Mda)when '01' then Case when SUM(a.MtoD)-SUM(a.MtoH) < 0 then (SUM(a.MtoD)-SUM(a.MtoH))*-1 else 0.00 end else
			case when SUM(a.MtoD_ME) - SUM(a.MtoH_ME) < 0 then (SUM(a.MtoD_ME)-SUM(a.MtoH_ME))*-1 else 0.00 end end as Acreedor
		from  voucher a 
		    --inner join Banco b on b.RucE=a.RucE and b.Ejer=a.Ejer and b.NroCta=a.NroCta
			left join (select b.RucE,b.Ejer,b.NroCta,ef.CodSNT_ as 'CodSNT_',b.NCtaB,b.Cd_Mda  
					   from Banco b
							inner join EntidadFinanciera ef on ef.Cd_EF=b.Cd_EF
					   where RucE=@RucE and Ejer=@Ejer and NroCta like '10%')as b on b.RucE=a.RucE and b.Ejer=a.Ejer and b.NroCta=a.NroCta

			--inner join PlanCtas c on c.RucE=b.RucE and c.Ejer=b.Ejer and c.NroCta=b.NroCta
			inner join (select RucE,Ejer,NroCta,NomCta,Cd_Mda  from PlanCtas
						where RucE=@RucE and Ejer=@Ejer and NroCta like '10%')as c on c.RucE=a.RucE and c.Ejer=a.Ejer and c.NroCta=a.NroCta

			--inner join EntidadFinanciera d on d.Cd_EF=b.Cd_EF
		where 	a.RucE=@RucE and a.Ejer=@Ejer and a.NroCta like '10%' and a.FecMov between Convert(nvarchar,@FecIni,103) and Convert(nvarchar,@FecFin,103)
		group by a.NroCta,b.CodSNT_


		-- Cabecera
		select @RucE as RucE,@Ejer as Ejer,RSocial, case(@Cd_Mda) when '01' then 'EN SOLES' when '02' then 'EN DOLARES' end as Moneda, 'Desde '+Convert(nvarchar,@FecIni,103) +' Hasta '+ Convert(nvarchar,@FecFin,103) as 'Prdo'
		from Empresa Where Ruc=@RucE

	end

-- Leyenda
--JJ 18/02/2011	<Creacion de Procedimiento Almacenado>

--exec user321.Rpt_InvBlc_Cta10 '11111111111', '2012', '02', '01/01/2012', '31/12/2013', ''

GO
