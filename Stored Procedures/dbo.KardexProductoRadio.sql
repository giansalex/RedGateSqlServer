SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Juan Saavedra>
-- Create date: <17/12/2012>
-- Description:	<Description,,>
--exec KardexProductoRadio '20522276236','PD00099' ,'01/05/2012','12/12/2012'
-- =============================================
CREATE PROCEDURE [dbo].[KardexProductoRadio] 
		@RucE nvarchar(100),
		@cod_produc nvarchar(100),
		@fecDesde datetime,
		@fechasta datetime
AS
declare @stockInicinal nvarchar(100) 
BEGIN


set @stockInicinal=(select sum(cant) from inventario inv  where inv.RucE=@RucE and inv.Cd_Prod=@cod_produc and inv.FecMov <@fecDesde)

select e.CodCo1_,e.Nombre1,'DEL '+Convert(nvarchar,@fecDesde,103)+ ' AL '+Convert(nvarchar,@fecHasta,103) as FecCons,@stockInicinal as Stock from Producto2 e where e.RucE=@RucE and e.Cd_Prod=@cod_produc


select inv.RegCtb,inv.Cd_Prod --,inv.FecEmi, 
	   ,g.NroSre,g.NroGR
       --case (inv.IC_ES)  when 'E' then 'NE' else 'GR' end  as Documento ,
       ,case (inv.IC_ES)  when 'E' then 'ING' else 'SAL.' end  as Trans ,
	   case (inv.IC_Es)  when 'SAL' then Prv.RSocial else cli.RSocial end  as 'Cliente/proveedor/Area',
	   (sum(case when inv.IC_ES = 'E' then abs(inv.Cant) else 0.00 end)) as Ingresos,
       sum(case when inv.IC_ES = 'S' then abs(inv.Cant) else 0.00 end) as Salidas
      --@stockInicinal+(sum(case when g.IC_ES = 'E' then abs(inv.Cant) else 0.00 end))-sum(case when g.IC_ES = 'S' then abs(inv.Cant) else 0.00 end) as stock
       
  from Inventario inv
      left JOIN GuiaRemision g ON inv.RucE = g.RucE AND inv.Cd_GR = g.Cd_GR 
	  left JOIN Producto2 p ON inv.RucE = p.RucE  and inv.Cd_Prod=p.Cd_Prod
	  left join cliente2 cli on inv.RucE=cli.RucE and inv.Cd_Clt=cli.Cd_Clt
	  left join proveedor2 Prv on inv.RucE=Prv.RucE and inv.Cd_Prv=Prv.Cd_Prv
where inv.rucE=@RucE
and 
inv.Cd_Prod=@cod_produc and
--case when isnull(@ejer,'')<> ''then inv.ejer else ''  end=isnull(@ejer,'') and
inv.FecMov between @fecDesde and @fechasta
group by inv.FecMov, g.NroSre,g.NroGR,inv.IC_ES,Prv.RSocial,cli.RSocial,inv.Cd_Prod,inv.RegCtb



END
GO
