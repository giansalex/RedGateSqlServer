SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_OrdFabricacion_Fucsa_FchTec2]
@RucE nvarchar(11),
@Cd_Fab nchar(10)
as


/******CABCERA****/
select 
	ISNULL(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) as Cliente,
	p1.CodCo1_ as CodCom,
	p1.Nombre1 as NomProdAFab,
	um1.NCorto as UMProdAFab,
	pu1.PesoKG as PesoProdAFab,
	ffl.Cd_Flujo,
	ffl.Nombre as NomFlujo,
	ffl.CA01 as CA01Flujo,--luego se agregara los demas campos.
	p1.CA01 as ProdFabCA01, p1.CA02 as ProdFabCA02, p1.CA03 as ProdFabCA03, p1.CA04 as ProdFabCA04, p1.CA05 as ProdFabCA05,  p1.CA06 as ProdFabCA06, p1.CA07 as ProdFabCA07, p1.CA08 as ProdFabCA08,  p1.CA09 as ProdFabCA09, p1.CA10 as ProdFabCA10,					
	ff.RucE, ff.Cd_Fab, ff.NroFab, ff.Cd_Flujo, ff.ID_UMP, ff.Cant as NPiezasAFab, ff.FecEmi, ff.FecReq, ff.Cd_Clt,
	ff.Cd_CC, cc.Descrip as nomCC, ff.Cd_SC, s.Descrip as nomSC, ff.Cd_SS, ss.Descrip as nomSS,
	ff.Asunto, ff.Obs, ff.Lote, ff.Cd_Mda,case when ff.Cd_Mda = '01' then 'Nuevos Soles' else 'Dolares' end as Moneda, ff.UsuCrea,
	
	ff.CA01,
	ff.CA02, 
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA03,'CA03') as CA03, 
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA04,'CA04') as CA04,
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA05,'CA05') as CA05, 
	ff.CA06, 
	ff.CA07, 
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA08,'CA08') as CA08, 
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA09,'CA09') as CA09,
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA10,'CA10') as CA10, 
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA11,'CA11') as CA11, 
	ff.CA12 as DimB, 
	ff.CA13 as RelC, 
	ff.CA14 as DimE,
	ff.CA15 as CA13, 
	ff.CA16 as CA14, 
	ff.CA17 as CA15, 
	ff.CA18 as CA16, 
	ff.CA19 as CA17, 
	ff.CA20 as CA18, 
	ff.CA21 as CA19, 
	ff.CA22 as CA20, 
	ff.CA23 as DimC,
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA24,'CA24') as CA21, 
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA25,'CA25') as CA22, 
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA26,'CA26') as CA23, 
	ff.CA27 as CA24, 
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA28,'CA28') as Reg, 
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA29,'CA29') as [End], 
	dbo.ListadoCA(@RucE,'13','FB03',ff.CA30,'CA30') as Ens
	from FabFabricacion ff 
	inner join FabFlujo ffl on ffl.RucE = ff.RucE and ffl.Cd_Flujo = ff.cd_flujo
	left join Producto2 p1 on p1.RucE = ff.RucE and p1.Cd_Prod = ff.Cd_Prod 
	left join Cliente2 c on c.RucE = ff.RucE and c.Cd_Clt = ff.Cd_Clt
	left join TipDocIdn tdi on tdi.Cd_TDI = c.Cd_TDI
	left join Prod_UM pu1 on pu1.RucE = ff.RucE and pu1.ID_UMP = ff.Id_ump and pu1.Cd_Prod = ff.Cd_Prod
	left join UnidadMedida um1 on um1.Cd_UM = pu1.Cd_UM 
	left join CCostos cc on cc.RucE = ff.RucE and cc.Cd_CC = ff.Cd_CC
	left join CCSub s on c.RucE = s.RucE and cc.Cd_CC = s.Cd_CC and s.Cd_SC = ff.Cd_SC
	left join CCSubSub ss on c.RucE = ss.RucE and cc.Cd_CC = ss.Cd_CC and s.Cd_SC = ss.Cd_SC and ss.Cd_SS = ff.Cd_SS 	
	where ff.RucE = @RucE and ff.Cd_Fab = @Cd_Fab
	
/****ENFRIADORES****/
----------------------------------------------------------------------------------------------
--select 
--	p.Nombre1 as NomProd, isnull(p.CodCo1_,'') as CodComercial
--	,fi.CantInsTotal as Cantidad, p.CA03 as Medida
--	from Fabetains fi
--	inner join producto2 p on p.RucE=fi.RucE and p.Cd_Prod = fi.Cd_Prod
--	inner join Prod_UM um on um.RucE=p.RucE and um.Cd_Prod=p.Cd_Prod
--	where fi.ruce =@RucE and p.Cd_Prod='PD00167' and fi.Cd_Fab=@Cd_Fab
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
/*****ALMA****/
select 
	fe.Cd_Fab,p.Nombre1 as NomProd, isnull(p.CodCo1_,'') as CodComercial,
	sum(fi.CantInsTotal) as Cantidad
	from fabetapa fe
	inner join Fabetains fi on fi.ruce=fe.ruce and fi.Cd_Fab=fi.Cd_Fab and fe.ID_Eta=fi.ID_eta
	inner join producto2 p on p.RucE=fi.RucE and p.Cd_Prod = fi.Cd_Prod
	inner join Prod_UM um on um.RucE=p.RucE and um.Cd_Prod=p.Cd_Prod
	where fi.ruce =@RucE and p.Nombre1 like 'Alma%' and fi.Cd_Fab=@Cd_Fab
	group by p.Nombre1, p.CodCo1_, p.CA03, p.CA01,fe.Cd_Fab

--------------------------------------------------------------------------------------------------
/*****MANGUITOS****/

	
select 
	fe.Cd_Fab,p.Nombre1 as NomProd, isnull(p.CodCo1_,'') as CodComercial,
	p.CA03 as Medida, sum(fi.CantInsTotal) as Cantidad,p.CA01 as Peso 
	from fabetapa fe
	inner join Fabetains fi on fi.ruce=fe.ruce and fi.Cd_Fab=fi.Cd_Fab and fe.ID_Eta=fi.ID_eta
	inner join producto2 p on p.RucE=fi.RucE and p.Cd_Prod = fi.Cd_Prod
	inner join Prod_UM um on um.RucE=p.RucE and um.Cd_Prod=p.Cd_Prod
	where fi.ruce =@RucE and p.Nombre1 like 'Mangu%' and fi.Cd_Fab=@Cd_Fab
	group by p.Nombre1, p.CodCo1_, p.CA03, p.CA01,fe.Cd_Fab
	
----------------------------------------------------------------------------------------------------
/*****FILTROS****/
select 
	fe.Cd_Fab,p.Nombre1 as NomProd, isnull(p.CodCo1_,'') as CodComercial,
	sum(fi.CantInsTotal) as Cantidad
	from fabetapa fe
	inner join Fabetains fi on fi.ruce=fe.ruce and fi.Cd_Fab=fi.Cd_Fab and fe.ID_Eta=fi.ID_eta
	inner join producto2 p on p.RucE=fi.RucE and p.Cd_Prod = fi.Cd_Prod
	inner join Prod_UM um on um.RucE=p.RucE and um.Cd_Prod=p.Cd_Prod
	where fi.ruce =@RucE and p.Nombre1 like 'Filtro%' and fi.Cd_Fab=@Cd_Fab
	group by p.Nombre1, p.CodCo1_, p.CA03, p.CA01,fe.Cd_Fab
----------------------------------------------------------------------------------------------------

/*****CERAMICOS****/
select 
	fe.Cd_Fab,p.Nombre1 as NomProd, isnull(p.CodCo1_,'') as CodComercial,
	sum(fi.CantInsTotal) as Cantidad
	from fabetapa fe
	inner join Fabetains fi on fi.ruce=fe.ruce and fi.Cd_Fab=fi.Cd_Fab and fe.ID_Eta=fi.ID_eta
	inner join producto2 p on p.RucE=fi.RucE and p.Cd_Prod = fi.Cd_Prod
	inner join Prod_UM um on um.RucE=p.RucE and um.Cd_Prod=p.Cd_Prod
	where fi.ruce =@RucE and p.Nombre1 like 'Ceramic%' and fi.Cd_Fab=@Cd_Fab
	group by p.Nombre1, p.CodCo1_, p.CA03, p.CA01,fe.Cd_Fab
	
--<CR/ADO: CE,JA> <18/03/2013>
--exec Rpt_OrdFabricacion_Fucsa_FchTec2 '20538728757','FAB0000003'
GO
