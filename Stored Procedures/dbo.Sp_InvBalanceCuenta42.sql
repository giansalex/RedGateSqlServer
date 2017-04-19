SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,juan saavedra>
-- Create date: <Create Date 05,03,2013>
-- Description:	<Description,Cuenta 12,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_InvBalanceCuenta42]
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

select	
   
	  Max(tp2.Cd_TD) as Cd_TD,	 
      Max(p2.NDoc) as NDoc,          
      case(isnull(max(p2.RSocial),'')) when '' then Max(p2.ApPat) + ' ' + Max(p2.ApMat) + ', '+ Max(p2.Nom) else Max(p2.RSocial) end as Cliente,
      Convert(nvarchar,v.FecMov,103) as FecMov
	  ,case(@Cd_Mda) when '01' then (SUM(v.MtoD)) when '02' then ((SUM(v.MtoD_ME))) end as Saldo
	  ,v.NroCta
      
  FROM dbo.Voucher v 
  LEFT JOIN dbo.PlanCtas pl2 ON v.RucE=pl2.RucE and v.Ejer=pl2.Ejer AND v.NroCta=pl2.NroCta  
  inner JOIN dbo.Proveedor2 p2 ON v .RucE=p2.RucE and v.Cd_Prv=p2.Cd_Prv
  left JOIN dbo.TipDoc tp2 ON v.Cd_TD=tp2.Cd_TD
 
 where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta  like '42%' AND
 v.FecMov between Convert(nvarchar,@FecIni,103) and Convert(nvarchar,@FecFin,103)
 GROUP BY  v.Cd_TD,
       tp2.Descrip,
       p2.NDoc,
       v.MtoD,   v.NroCta,v.FecMov,left(v.NroCta,@Nivel)
       
 ORDER BY v.Cd_TD,v.NroCta
END
GO
