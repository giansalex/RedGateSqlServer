SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_Preventores]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as 

select  
	--INFO. DE FACTURA
	--**************************
	v.RucE,v.Cd_Vta,s.NroSerie,v.NroDoc,Case(v.Cd_Mda) when '01' then 'S/.' else 'US$.' end Moneda,
	--INFO. DEL CLIENTE
	--*************************
	datename(day,v.FecMov)+' de '+datename(month,v.FecMov)+' del '+datename(year,v.FecMov) as FecMov,
	v.Cd_Cte,a.NDoc as RucCli,isnull(a.RSocial,a.ApPat+' '+a.ApMat+' '+a.Nom) as NomCli,a.Direc,v.Obs,
	--INF. TOTALES
	--*************************
	Sum(d.IMP) as SubTotal, 0.00 as Dscto,v.IGV,v.EXO,v.Total,Max(p.Nombre) as Nombre
from Venta v
left join Serie s on v.RucE=s.RucE and v.Cd_Sr=s.Cd_Sr
left join Auxiliar a on v.RucE=a.RucE and v.Cd_Cte=a.Cd_Aux
left join VentaDet d on v.RucE=d.RucE and v.Cd_Vta=d.Cd_Vta
left join Producto p on d.RucE=p.RucE and d.Cd_Pro=p.Cd_Pro
where v.RucE=@RucE and v.Eje=@Eje and v.Cd_Vta=@Cd_Vta
Group by v.RucE,v.Cd_Vta,s.NroSerie,v.NroDoc,v.Cd_Mda,v.FecMov,v.Cd_Cte,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,a.Direc,v.Obs,v.IGV,v.EXO,v.Total

	

Select 
	--INF. DETALLE DE LA FACTURA
	--*************************
	d.Cd_Pro,p.Nombre,Case(v.Cd_Mda) when '01' then 'S/. '+Convert(varchar,d.IMP) else 'US$. '+Convert(varchar,d.IMP) end IMP
From Venta v
left join VentaDet d on v.RucE=d.RucE and v.Cd_Vta=d.Cd_Vta
left join Producto p on d.RucE=p.RucE and d.Cd_Pro=p.Cd_Pro
where v.RucE=@RucE and v.Eje=@Eje and v.Cd_Vta=@Cd_Vta


Declare @v1 nvarchar(100),@v2 nvarchar(100),@v3 nvarchar(100)
Declare @v4 nvarchar(100),@v5 nvarchar(100),@v6 nvarchar(100)

if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') Set @v1=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') else    Set @v1= '  '
if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') Set @v2=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') else    Set @v2= '  '
if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') Set @v3=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') else    Set @v3= '  '
if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') Set @v4=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') else    Set @v4= '  '
if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') Set @v5=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') else    Set @v5= '  '
if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') Set @v6=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') else    Set @v6= '  '

Select @v1 as V1, @v2 as V2, @v3 as V3, @v4 as V4, @v5 as V5, @v6 as V6
/*
select  top 1
	--INFO. DE FACTURA
	--**************************
	v.RucE,
	v.Cd_Vta,
	s.NroSerie,
	v.NroDoc,
	Case(v.Cd_Mda) when '01' then 'S/.' else 'US$.' end Moneda,
	
	--INFO. DEL CLIENTE
	--*************************
	Convert(varchar,v.FecMov,106) FecMov,
	v.Cd_Cte,a.NDoc as RucCli,isnull(a.RSocial,a.ApPat+' '+a.ApMat+' '+a.Nom) as NomCli,
	a.Direc,

	--INF. DETALLE DE LA FACTURA
	--*************************
	d.Cd_Pro,p.Nombre,v.Obs,d.IMP,

	--INF. TOTALES
	--*************************
	v.BIM as SubTotal, 0.00 as Dscto,v.IGV,v.EXO,v.Total
from Venta v
left join Serie s on v.RucE=s.RucE and v.Cd_Sr=s.Cd_Sr
left join Auxiliar a on v.RucE=a.RucE and v.Cd_Cte=a.Cd_Aux
left join VentaDet d on v.RucE=d.RucE and v.Cd_Vta=d.Cd_Vta
left join Producto p on d.RucE=p.RucE and d.Cd_Pro=p.Cd_Pro
--left join CampoV cv on v.RucE=cv.RucE and v.Cd_Vta=cv.Cd_Vta
where v.RucE=@RucE and v.Eje=@Eje and v.Cd_Vta=@Cd_Vta

Declare @v1 nvarchar(100),@v2 nvarchar(100),@v3 nvarchar(100)
Declare @v4 nvarchar(100),@v5 nvarchar(100),@v6 nvarchar(100)

if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') Set @v1=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') else    Set @v1= '  '
if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') Set @v2=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') else    Set @v2= '  '
if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') Set @v3=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') else    Set @v3= '  '
if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') Set @v4=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') else    Set @v4= '  '
if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') Set @v5=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') else    Set @v5= '  '
if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') Set @v6=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') else    Set @v6= '  '

Select Convert(char(10),@v1)+'    '+Convert(char(12),@v2)+'    '+Convert(char(17),@v3)+'   '+Convert(char(15),@v4)+'   '+Convert(char(7),@v5)+'   '+convert(char(12),@v6) as Valor
Select @v1 as V1, @v2 as V2, @v3 as V3, @v4 as V4, @v5 as V5, @v6 as V6
*/
------CODIGO DE MODIFICACION--------
--CM=MG01
GO
