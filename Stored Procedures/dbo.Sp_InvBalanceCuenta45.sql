SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,juan antonio>
-- Create date: <Create 13/03/2013,,>
-- Description:	<Description,Sp_InvBalanceCuenta45,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_InvBalanceCuenta45]
@fechInicio datetime, 
@fechFinal Datetime,
@RucEmp nvarchar(11),
@Ejer nvarchar(4),
@Cd_Mda char(2),
@Nivel int,
@msj varchar(100) output
AS
BEGIN
	select @RucEmp as RucE,@Ejer as Ejer,RSocial, case(@Cd_Mda) when '01' then 'EN SOLES' when '02' then 'EN DOLARES' end as Moneda, 'Desde '+Convert(nvarchar,@fechInicio,103) +' Hasta '+ Convert(nvarchar,@fechFinal,103) as 'Prdo'
	from Empresa Where Ruc=@RucEmp
		
		
SELECT  
		NroCta,
		NomCta
		
  from dbo.PlanCtas 
  where RucE=@RucEmp and  Ejer=@Ejer and NroCta in (  
--		SELECT dbo.NivelCuenta(v.NroCta,1)from dbo.Voucher v where v.RucE=@RucEmp and  v.Ejer=@Ejer AND v.Prdo='00' and v.NroCta LIKE '45%' GROUP BY dbo.NivelCuenta(v.NroCta,1) union all
--		SELECT dbo.NivelCuenta(v.NroCta,2)from dbo.Voucher v where v.RucE=@RucEmp and  v.Ejer=@Ejer AND v.Prdo='00' and v.NroCta LIKE '45%' GROUP BY dbo.NivelCuenta(v.NroCta,2) union all
		SELECT v.NroCta from dbo.Voucher v where v.RucE=@RucEmp and  v.Ejer=@Ejer and v.NroCta LIKE '45%' GROUP BY v.NroCta union all
		SELECT dbo.NivelCuenta(v.NroCta,3)from dbo.Voucher v where v.RucE=@RucEmp and  v.Ejer=@Ejer  and v.NroCta LIKE '45%' GROUP BY dbo.NivelCuenta(v.NroCta,3) union all
		SELECT v.NroCta					  from dbo.Voucher v where v.RucE=@RucEmp and  v.Ejer=@Ejer  and v.NroCta LIKE '45%' GROUP BY v.NroCta
		) AND Nivel IN (1,2,3,4)		
		
--SELECT *FROM (
SELECT    
		isnull(tpd.Cd_TD,'') as TipoDocIdentidad,			
		isnull(pv.NDoc,'') as NumeroDoc,
		ISNULL(pv.RSocial,'') as Proveedor,
        v.NroCta,
        pl.NomCta as NombreCuenta,       
        tpd.Descrip as nombreDocumento,
        v.FecMov as FecEmision,
       v.SaldoDolares as SaldoDolares ,
       v.SaldoSoles as SaldoSoles,
       -- case(@Cd_Mda) when '01' then (v.SaldoDolares) when '02' then (v.SaldoSoles) end as Saldo,
        v.Total as SaldoInicial,
        pl.Nivel
 from (
		SELECT v.RegCtb,
			   q.Total,
		       ISNULL((SUM(v.MtoD_ME)-SUM(v.MtoH_ME)),0) as SaldoDolares,
		       ISNULL((SUM(v.MtoD)-SUM(v.MtoH)),0) as SaldoSoles,
		       v.NroCta,v.Cd_Prv,v.NroDoc,v.Ejer,v.FecMov,v.Prdo,v.RucE ,v.Cd_TD
			   from ( 
			     	select isnull(t.Total,0) as Total,t1.NroCta from 
						(
							SELECT ISNULL((SUM(v.MtoD_ME)-SUM(v.MtoH_ME)),0) as Total,v.NroCta  
							from dbo.Voucher v 
							where v.RucE=@RucEmp and  v.Ejer=@Ejer AND v.Prdo='00' and v.NroCta LIKE '45%' GROUP by v.NroCta
						) as t 
							right join (
								SELECT 0.0 as total, v.NroCta from dbo.Voucher v where v.RucE=@RucEmp and  v.Ejer=@Ejer and v.NroCta LIKE '45%' GROUP by v.NroCta
										) as t1 on t.NroCta = t1.NroCta 
	                ) as q left JOIN  dbo.Voucher v  on q.NroCta=v.NroCta
	            where v.RucE=@RucEmp and  v.Ejer=@Ejer and v.NroCta LIKE '45%'  
				GROUP by v.RegCtb,v.Ejer,v.NroCta,v.NroDoc,v.Cd_Prv,v.FecMov ,v.Prdo ,v.RucE ,v.Cd_TD,q.Total
	   ) 
as v 
left join dbo.Proveedor2 pv on v.RucE=pv.RucE and v.Cd_Prv=pv.Cd_Prv  
left JOIN dbo.TipDoc tpd  on v.Cd_TD=tpd.Cd_TD
left JOIN dbo.TipDocIdn td ON pv.Cd_TDI=td.Cd_TDI 
left JOIN dbo.PlanCtas pl ON v.RucE=pl.RucE and v.Ejer=pl.Ejer and v.NroCta=pl.NroCta
where v.RucE=@RucEmp and  v.Ejer=@Ejer and v.NroCta LIKE '45%'
 and v.FecMov between Convert(nvarchar,@fechInicio,103) and Convert(nvarchar,@fechFinal,103)
GROUP BY  tpd.Descrip,
		  tpd.Cd_TD,
		  pv.NDoc, v.NroCta ,
		  left(v.NroCta,@Nivel),
		  pv.RSocial,
		  v.FecMov,
		  v.SaldoDolares,
		  v.NroDoc,
		  v.SaldoSoles,
		  pl.NomCta,
		  pv.ApPat,
		  pv.ApMat,
		  pv.Nom,
		  pl.Nivel,
		  v.Total
		  order BY  pl.NomCta


	
--SELECT*from dbo.PlanCtas where NroCta like '45%' 
--select*from voucher where rucE='20392916904' and ejer='2012' 2.697
-- exec Sp_InvBalanceCuenta45 '01/01/2012', '31/12/2013', '20392916904','2012','02',3,''


END


GO
