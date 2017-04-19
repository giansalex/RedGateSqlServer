SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ConsultaMargenes]
@RucE nvarchar(11),
@FecIni smalldatetime,
@FecFin smalldatetime,
@Cd_Prod char(7),
@Cd_Mda char(2),
@msj varchar(100) output
as

/*
set @RucE = '20513272848'
set @FecIni = '01/08/2011 00:00:00'
set @FecFin = '31/08/2011 00:00:00'*/
--if exists(select * from Producto2 pr where pr.RucE = @RucE and pr.Cd_Prod = @Cd_Prod)

	if(@Cd_Prod is null)
	begin
				Select 
					isnull(l1.Nombre,'--Sin Especificar--') As NomClase,
					isnull(l2.Nombre,'--Sin Especificar--') As NomClaseSub,
					isnull(l3.Nombre,'--Sin Especificar--') As NomClaseSubSub,
					null Indice,
					p.Cd_Prod, p.CodCo1_ as CodCom, p.Nombre1 As NomProd,
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
					End As [Porc_%],
					null As C1
					--,isnull(l2.Nombre,'--Sin Especificar--') As C2,
					--isnull(l3.Nombre,'--Sin Especificar--') As C3
					
				From
					Venta v
					Inner join VentaDet d On d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta
					Inner Join Producto2 p On p.RucE=d.RucE and p.Cd_Prod=d.Cd_Prod
					
					Left Join ClaseSubSub l3 On l3.RucE=p.RucE and l3.Cd_CL=p.Cd_CL and l3.Cd_CLS=p.Cd_CLS and l3.Cd_CLSS=p.Cd_CLSS
					Left Join ClaseSub l2 On l2.RucE=p.RucE and l2.Cd_CL=p.Cd_CL and l2.Cd_CLS=p.Cd_CLS
					Left Join Clase l1 On l1.RucE=p.RucE and l1.Cd_CL=p.Cd_CL	
				Where
					v.RucE = @RucE and v.FecMov between @FecIni and @FecFin + '23:59:29' and v.IB_Anulado = 0
					--v.RucE = @RucE and v.Prdo in ('08')
				
				Group by
					isnull(l1.Nombre,'--Sin Especificar--'),
					isnull(l2.Nombre,'--Sin Especificar--'),
					isnull(l3.Nombre,'--Sin Especificar--'),
					p.Cd_Prod,p.Nombre1,p.CodCo1_
	end
	else
	begin
	if exists(select * from Producto2 pr where pr.RucE = @RucE and pr.Cd_Prod = @Cd_Prod)
	begin
				Select 
					isnull(l1.Nombre,'--Sin Especificar--') As NomClase,
					isnull(l2.Nombre,'--Sin Especificar--') As NomClaseSub,
					isnull(l3.Nombre,'--Sin Especificar--') As NomClaseSubSub,
					p.Cd_Prod,p.CodCo1_ as CodCom,p.Nombre1 As NomProd,
					null Indice,
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
					
					Case When Sum(dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,@Cd_Mda))=0 
						Then 0.00 
						Else Convert(decimal(13,4),(((
						Sum(Convert(decimal(13,2),
						Case(@Cd_Mda)
							When '01' Then
									Case When v.Cd_Mda='01' Then (d.Imp) Else Convert(decimal(13,4),(d.Imp*v.CamMda)) End
							When '02' Then
									Case When v.Cd_Mda='02' Then (d.Imp) Else Convert(decimal(13,4),(d.Imp/v.CamMda)) End
						End)) - Sum(Convert(decimal(13,4),dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,@Cd_Mda)*d.Cant))
						
						)*100)/
						
						Sum(Convert(decimal(13,4),dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,@Cd_Mda)*d.Cant))
						
						)/100) 
					End As [Porc_%],
					null As C1
					
					--,isnull(l2.Nombre,'--Sin Especificar--') As C2,
					--isnull(l3.Nombre,'--Sin Especificar--') As C3
					
				From
					Venta v
					Inner join VentaDet d On d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta
					Inner Join Producto2 p On p.RucE=d.RucE and p.Cd_Prod=d.Cd_Prod
					Left Join ClaseSubSub l3 On l3.RucE=p.RucE and l3.Cd_CL=p.Cd_CL and l3.Cd_CLS=p.Cd_CLS and l3.Cd_CLSS=p.Cd_CLSS
					Left Join ClaseSub l2 On l2.RucE=p.RucE and l2.Cd_CL=p.Cd_CL and l2.Cd_CLS=p.Cd_CLS
					Left Join Clase l1 On l1.RucE=p.RucE and l1.Cd_CL=p.Cd_CL	
				Where
					v.RucE = @RucE and v.FecMov between @FecIni and @FecFin + '23:59:29'  and v.IB_Anulado = 0
					--v.RucE = @RucE and v.Prdo in ('08')
					and p.Cd_Prod = @Cd_Prod
				Group by
					isnull(l1.Nombre,'--Sin Especificar--'),
					isnull(l2.Nombre,'--Sin Especificar--'),
					isnull(l3.Nombre,'--Sin Especificar--'),
					p.Cd_Prod,p.Nombre1,p.CodCo1_
	end
	end
--select top 5 * from venta where RegCtb = '11111111111'
-- LEYENDA
-- CAM 19/09/2011 Creacion
-- exec Vta_ConsultaMargenes '20513272848','01/08/2011 00:00:00','31/08/2011 00:00:00','PD00004','01',null
-- exec Vta_ConsultaMargenes '20513272848','01/08/2011 00:00:00','31/08/2011 00:00:00',null,'01',null


GO
