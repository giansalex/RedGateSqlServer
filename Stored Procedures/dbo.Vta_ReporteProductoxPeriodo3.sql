SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ReporteProductoxPeriodo3]
@RucE nvarchar(11),
@Cd_Prod nvarchar(4000),
@Eje nvarchar(4),
@Cd_Mda char(2),
@FecIni datetime,
@FecFin datetime,
@msj varchar(100) output
as
--declare 
--@RucE nvarchar(11),
--@Cd_Prod nvarchar(4000),
--@Eje nvarchar(4),
--@Cd_Mda char(2)

--set @RucE = '20513272848'
--set @Cd_Prod = '''PD00001'',''PD00001'''
--set @Eje = '2011'
--set @Cd_Mda = '01'

declare @Sql1 varchar(8000)
set @Sql1 = 
'
Select 
	p.Cd_Prod, p.CodCo1_ as CodCom, p.Nombre1 As NomProd,v.Prdo,--v.Cd_Mda,
	Sum(
					Case('''+@Cd_Mda+''')
						When ''01'' Then
								Case When v.Cd_Mda=''01'' Then (d.Imp) Else Convert(decimal(13,2),(d.Imp*v.CamMda)) End
						When ''02'' Then
								Case When v.Cd_Mda=''02'' Then (d.Imp) Else Convert(decimal(13,2),(d.Imp/v.CamMda)) End
					End) As Valor_Venta, 
					
					Sum(Convert(decimal(13,2),dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,'''+@Cd_Mda+''')*d.Cant)) As Valor_Costo,	
					
					Sum(
					Case('''+@Cd_Mda+''')
						When ''01'' Then
								Case When v.Cd_Mda=''01'' Then (d.Imp) Else Convert(decimal(13,2),(d.Imp*v.CamMda)) End
						When ''02'' Then
								Case When v.Cd_Mda=''02'' Then (d.Imp) Else Convert(decimal(13,2),(d.Imp/v.CamMda)) End
					End) - Sum(Convert(decimal(13,2),dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,'''+@Cd_Mda+''')*d.Cant)) As Margen,
					
					
					Case When Sum(dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,'''+@Cd_Mda+'''))=0 
						Then 0.00 
						Else Convert(decimal(13,5),(((
						Sum(Convert(decimal(13,2),
						Case('''+@Cd_Mda+''')
							When ''01'' Then
									Case When v.Cd_Mda=''01'' Then (d.Imp) Else Convert(decimal(13,5),(d.Imp*v.CamMda)) End
							When ''02'' Then
									Case When v.Cd_Mda=''02'' Then (d.Imp) Else Convert(decimal(13,5),(d.Imp/v.CamMda)) End
						End)) - Sum(Convert(decimal(13,2),dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,'''+@Cd_Mda+''')*d.Cant))
						
						)*100)/
						
						Sum(Convert(decimal(13,5),dbo.CostSal2(v.RucE,d.Cd_Prod,d.ID_UMP,v.FecMov,'''+@Cd_Mda+''')*d.Cant))
						
						))--/100) 
					End As [Porc]
					,isnull(l1.Nombre,''--Sin Especificar--'') As NomClase,
					isnull(l2.Nombre,''--Sin Especificar--'') As NomClaseSub,
					isnull(l3.Nombre,''--Sin Especificar--'') As NomClaseSubSub
	
From
	Venta v
	Inner join VentaDet d On d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta
	Inner Join Producto2 p On p.RucE=d.RucE and p.Cd_Prod=d.Cd_Prod
	left join Moneda m On m.Cd_Mda = v.Cd_Mda
	Left Join ClaseSubSub l3 On l3.RucE=p.RucE and l3.Cd_CL=p.Cd_CL and l3.Cd_CLS=p.Cd_CLS and l3.Cd_CLSS=p.Cd_CLSS
	Left Join ClaseSub l2 On l2.RucE=p.RucE and l2.Cd_CL=p.Cd_CL and l2.Cd_CLS=p.Cd_CLS
	Left Join Clase l1 On l1.RucE=p.RucE and l1.Cd_CL=p.Cd_CL	
Where

	v.RucE = '+@RucE+' and v.Eje = '+@Eje+'	and p.Cd_Prod in ('
	 --@Cd_Prod
	 
declare @Sql2 varchar (8000)
set @Sql2 = ')
and v.FecMov between '''+CONVERT(nvarchar,@FecIni,103)+''' and '''+CONVERT(nvarchar,@FecFin,103)+'''
Group by
	p.Cd_Prod,p.Nombre1,p.CodCo1_,v.Prdo--,v.Cd_Mda
	,isnull(l1.Nombre,''--Sin Especificar--''),
	isnull(l2.Nombre,''--Sin Especificar--''),
	isnull(l3.Nombre,''--Sin Especificar--'')
'

print @Sql1 + @cd_Prod + @Sql2
exec(@Sql1 + @cd_Prod + @Sql2)

--<Creado JA: 08/02/2012>
-- exec Vta_ReporteProductoxPeriodo3 '11111111111','''PD00001''','2011','01','01/05/2011','01/12/2011',null
GO
