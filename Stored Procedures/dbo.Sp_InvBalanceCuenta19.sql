SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_InvBalanceCuenta19]
@fechInicio datetime, 
@fechFinal Datetime,
@RucEmp nvarchar(11),
--@NroCta nvarchar(10), 
@Ejer nvarchar(4),
@Cd_Mda char(2),
@Nivel int,
@msj varchar(100) output
AS
BEGIN
if not exists ( select top 1 *from voucher where RucE=@RucEmp and Ejer=@Ejer and NroCta like '19%')
		set @msj='No se encontraron Registros de Inventario de Balances para la Cuenta 19'
	
	else
--Cabecera Reporte
	select @RucEmp as RucE,@Ejer as Ejer,RSocial, case(@Cd_Mda) when '01' then 'EN SOLES' when '02' then 'EN DOLARES' end as Moneda, 'Desde '+Convert(nvarchar,@fechInicio,103) +' Hasta '+ Convert(nvarchar,@fechFinal,103) as 'Prdo'
	from Empresa Where Ruc=@RucEmp
	
			
SELECT  
		NroCta,
		NomCta,
		Nivel
  from dbo.PlanCtas 
  where RucE=@RucEmp and  Ejer=@Ejer and NroCta in (  
--		SELECT dbo.NivelCuenta(v.NroCta,1)from dbo.Voucher v where v.RucE=@RucEmp and  v.Ejer=@Ejer AND v.Prdo='00' and v.NroCta LIKE '45%' GROUP BY dbo.NivelCuenta(v.NroCta,1) union all
--		SELECT dbo.NivelCuenta(v.NroCta,2)from dbo.Voucher v where v.RucE=@RucEmp and  v.Ejer=@Ejer AND v.Prdo='00' and v.NroCta LIKE '45%' GROUP BY dbo.NivelCuenta(v.NroCta,2) union all
		SELECT v.NroCta from dbo.Voucher v where v.RucE=@RucEmp and  v.Ejer=@Ejer AND v.Prdo='00' and v.NroCta LIKE '19%' GROUP BY v.NroCta union all
		SELECT dbo.NivelCuenta(v.NroCta,3)from dbo.Voucher v where v.RucE=@RucEmp and  v.Ejer=@Ejer AND v.Prdo='00' and v.NroCta LIKE '19%' GROUP BY dbo.NivelCuenta(v.NroCta,3) union all
		SELECT v.NroCta					  from dbo.Voucher v where v.RucE=@RucEmp and  v.Ejer=@Ejer AND v.Prdo='00' and v.NroCta LIKE '19%' GROUP BY v.NroCta
		) AND Nivel IN (1,2,3,4)
		
		
		

	SELECT  
             isnull(c.Cd_TDI, '') as Cd_TDI
		 
			,isnull(c.NDoc,'') as NDoc
			,isnull( c.Rsocial,isnull(c.ApPat, '') + isnull(c.ApMat,'') + isnull(c.Nom, '') ) as cliente
			,t.NCorto + '/' + ' ' + v.NroSre +'-' + v.NroDoc as NumDoc
			,Convert(nvarchar,v.FecMov,103) as FecMov,
			SUM(v.MtoH) as saldoSoles,
			SUM(v.MtoH_ME) as SaldoDolares,
			case(@Cd_Mda) when '01' then (SUM(v.MtoH)) when '02' then ((SUM(v.MtoH_ME))) end as Saldo
			,v.NroCta as NroCta
			
		
           
FROM                  Voucher v left JOIN
                      PlanCtas p ON  v.RucE = p.RucE  and v.Ejer=p.Ejer AND v.NroCta=p.NroCta inner JOIN
                      Cliente2 c ON v.RucE = c.RucE and v.Cd_Clt = c.Cd_Clt inner JOIN
                      TipDoc t ON v.Cd_TD = t.Cd_TD                     
                      where v.RucE=@RucEmp and v.Ejer=@Ejer    and  v.NroCta LIKE '19%' 
                     and v.FecMov between Convert(nvarchar,@fechInicio,103) and Convert(nvarchar,@fechFinal,103)
            
                      GROUP BY  c.Cd_Clt
					
					,c.Cd_TDI, c.NDoc
					,t.NCorto, v.NroSre, v.NroDoc, v.FecVD
					,p.Nivel
					,v.Cd_Fte
					,c.RSocial, c.ApPat, c.ApMat, c.Nom,v.RucE,v.Ejer,FecMov,v.NroCta
					order BY v.NroCta
END
--select*from dbo.Voucher where Ejer='2012' and NroCta like '19%'
--exec Sp_InvBalanceCuenta19 '01/01/2012', '31/12/2013', '20101949461','2012','02',3,''
GO
