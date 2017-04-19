SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,juan saavedra>
-- Create date: <Create Date 05,03,2013>
-- Description:	<Description ,cuenta 41,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_InvBalanceCuenta41]
@FecIni datetime, 
@FecFin Datetime,
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Mda char(2),
@Nivel int,
@msj varchar(100) output
AS
BEGIN

--Cabecera Reporte
	select @RucE as RucE,@Ejer as Ejer,RSocial, case(@Cd_Mda) when '01' then 'EN SOLES' when '02' then 'EN DOLARES' end as Moneda, 'Desde '+Convert(nvarchar,@FecIni,103) +' Hasta '+ Convert(nvarchar,@FecFin,103) as 'Prdo'
	from Empresa Where Ruc=@RucE

	SELECT 
	   Max(tp2.Cd_TD) as Cd_TD,
       left(vou.NroCta,@Nivel) NroCta,
       Max(pl2.NomCta) AS denominacion,
       pr.Cd_Prv,
	   case(isnull(max(pr.RSocial),'')) when '' then Max(pr.ApPat) + ' ' + Max(pr.ApMat) + ', '+ Max(pr.Nom) else Max(pr.RSocial) end as trabajador,
	   pr.Cd_TDI,
	   pr.NDoc,
	   Convert(nvarchar,vou.FecMov,103) as FecMov,
	   case(@Cd_Mda) when '01' then (SUM(vou.MtoH)-(-1*SUM(vou.MtoD))) when '02' then ((SUM(vou.MtoH_ME)-(-1*SUM(vou.MtoD_ME)))) end as Saldo
	   
	   FROM dbo.Voucher vou
	    INNER join dbo.Proveedor2 pr on vou.RucE=pr.RucE and vou.Cd_Prv=pr.Cd_Prv
	    left JOIN dbo.TipDoc tp2 ON vou.Cd_TD=tp2.Cd_TD
	    LEFT JOIN dbo.PlanCtas pl2 ON vou.RucE=pl2.RucE and vou.Ejer=pl2.Ejer AND vou.NroCta=pl2.NroCta  
	       where vou.RucE=@RucE and vou.Ejer=@Ejer and  vou.NroCta like '41%'
	       and vou.FecMov between Convert(nvarchar,@FecIni,103) and Convert(nvarchar,@FecFin,103)
			  GROUP BY  vou.Cd_TD,
			  pl2.NomCta,
			  pr.NDoc,
			  vou.MtoD,
			  vou.NroCta,Convert(nvarchar,Vou.FecMov,103),
			  vou.FecMov,pr.Cd_Prv,pr.Cd_TDI,pr.NDoc,
			  left(vou.NroCta,@Nivel)
END
GO
