SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,juan,saaavedra>
-- Create date: <Create 12/12/2012>
-- Description:	<Total Ventas Por Articulo>
-- =============================================
CREATE PROCEDURE [dbo].[rpt_TotalVentaPorArticulo]
	@RucE nvarchar(100),
	@cod_cli nvarchar(100),--codigo de cliente
	@cod_cl nvarchar(100),--codigo de clase
	@cod_cls nvarchar(100),--codigo de sub clase
	@cod_clss nvarchar(100),--codigo de sub sub clase
	@fecDesde datetime,--codigo de clase
	@fecHasta datetime
	--@ejer nvarchar
	
AS
declare @cod_cliente nvarchar(100)
declare @nombre_linea nvarchar(50)
BEGIN

set @cod_Cliente =(select Cd_Clt from cliente2 where cliente2.NDoc=@cod_cli and RucE=@RucE)

set @nombre_linea=(select Nombre from clase where Cd_CL=@cod_cl)

select e.NDoc,e.RSocial,'DEL '+Convert(nvarchar,@fecDesde,103)+ ' AL '+Convert(nvarchar,@fecHasta,103) as FecCons,@nombre_linea as Nombre_linea from cliente2 e where e.RucE=@RucE and e.Cd_Clt=@cod_Cliente

---detalle
SELECT     Venta.NroSre,
		   Venta.NroDoc,
		   VentaDet.Cd_Prod,
		   VentaDet.Descrip,
		   VentaDet.Cant,
		   VentaDet.PU, 
		   VentaDet.Valor, 
		   VentaDet.IGV, 
		   VentaDet.Total, 
		   VentaDet.Cd_Vta
		--   clase.NCorto as Clase,
		 ----  claseSub.NCorto as ClaseSub,
		--   claseSubSub.NCorto as ClaseSubSub
FROM         Venta LEFT  JOIN
                      VentaDet ON Venta.RucE = VentaDet.RucE AND Venta.Cd_Vta = VentaDet.Cd_Vta LEFT OUTER JOIN
                      Producto2 ON VentaDet.RucE = Producto2.RucE AND VentaDet.Cd_Prod = Producto2.Cd_Prod  
                     -- inner join clase on Producto2.RucE= clase.RucE and Producto2.Cd_CL=clase.Cd_CL  
                     inner join claseSub on claseSub.RucE=Venta.RucE and claseSub.Cd_CL=Producto2.Cd_CL and ClaseSub.Cd_Cls = producto2.Cd_Cls
                      inner join claseSubSub on claseSubSub.RucE=Venta.RucE and claseSubSub.Cd_CL=Producto2.Cd_CL and claseSubSub.Cd_ClS = ClaseSub.Cd_ClS and ClaseSubSub.Cd_Clss = producto2.Cd_Clss
WHERE        (Venta.RucE = @RucE) AND (Venta.Cd_Clt = @cod_Cliente) AND (Venta.FecMov BETWEEN @fecDesde AND @fecHasta) AND
					  (Producto2.Cd_CL = @cod_cl) OR
                      (Producto2.Cd_CLS = @cod_cls) OR
                      (Producto2.Cd_CLSS = @cod_clss)
ORDER BY Venta.NroDoc
END
GO
