SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ReporteProductoxPeriodo]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Eje nvarchar(4),
@Cd_Mda char(2),
@msj varchar(100) output
as
/*
set @RucE = '20513272848'
set @Cd_Prod = 'PD00005'
set @Eje = '2011'
*/
Select 
	p.Cd_Prod, p.CodCo1_ as CodCom, p.Nombre1 As NomProd,v.Prdo,--v.Cd_Mda,
	--Sum(d.Imp) As Valor_Venta,
	--Sum(d.Costo) As Valor_Costo,
	--Sum(d.Imp) - Sum(d.Costo) As Margen,
	--Case When Sum(d.Costo)=0 Then 0.00 Else Convert(decimal(12,2),(((Sum(d.Imp)-Sum(d.Costo))*100)/Sum(d.Costo))/100) End As Porc
	Sum(
					Case(@Cd_Mda)
						When '01' Then
								Case When v.Cd_Mda='01' Then (d.Imp) Else Convert(decimal(13,2),(d.Imp*v.CamMda)) End
						When '02' Then
								Case When v.Cd_Mda='02' Then (d.Imp) Else Convert(decimal(13,2),(d.Imp/v.CamMda)) End
					End) As Valor_Venta, 
					
					Sum(Convert(decimal(13,2),dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,@Cd_Mda)*d.Cant)) As Valor_Costo,	
					
					Sum(
					Case(@Cd_Mda)
						When '01' Then
								Case When v.Cd_Mda='01' Then (d.Imp) Else Convert(decimal(13,2),(d.Imp*v.CamMda)) End
						When '02' Then
								Case When v.Cd_Mda='02' Then (d.Imp) Else Convert(decimal(13,2),(d.Imp/v.CamMda)) End
					End) - Sum(Convert(decimal(13,2),dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,@Cd_Mda)*d.Cant)) As Margen,
					
					--Case When Sum(d.Costo)=0 Then 0.00 Else Convert(decimal(12,2),(((Sum(d.Imp)-Sum(d.Costo))*100)/Sum(d.Costo))/100) End As [Porc_%]
					Case When Sum(dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,@Cd_Mda))=0 
						Then 0.00 
						Else Convert(decimal(13,5),(((
						Sum(Convert(decimal(13,2),
						Case(@Cd_Mda)
							When '01' Then
									Case When v.Cd_Mda='01' Then (d.Imp) Else Convert(decimal(13,5),(d.Imp*v.CamMda)) End
							When '02' Then
									Case When v.Cd_Mda='02' Then (d.Imp) Else Convert(decimal(13,5),(d.Imp/v.CamMda)) End
						End)) - Sum(Convert(decimal(13,2),dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,@Cd_Mda)*d.Cant))
						
						)*100)/
						
						Sum(Convert(decimal(13,5),dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,@Cd_Mda)*d.Cant))
						
						)/100) 
					End As [Porc]
	
From
	Venta v
	Inner join VentaDet d On d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta
	Inner Join Producto2 p On p.RucE=d.RucE and p.Cd_Prod=d.Cd_Prod
	left join Moneda m On m.Cd_Mda = v.Cd_Mda
Where
	v.RucE = @RucE and v.Eje = @Eje	and p.Cd_Prod = @Cd_Prod
Group by
	p.Cd_Prod,p.Nombre1,p.CodCo1_,v.Prdo--,v.Cd_Mda
	
-- LEYENDA
-- CAM 21/09/2011 Creacion
-- exec Vta_ReporteProductoxPeriodo '20513272848','PD00005','2011','01',''
GO
