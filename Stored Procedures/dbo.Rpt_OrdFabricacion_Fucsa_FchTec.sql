SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_OrdFabricacion_Fucsa_FchTec]
--Declare 
@RucE nvarchar(11),
@Cd_Fab nchar(10)
as
--Set @RucE = '20538728757'
----Set @RucEmp = '20538728757'
--Set @Cd_Fab = 'FAB0000001'
--exec [Rpt_OrdFabricacion_Fucsa_FchTec] '20538728757','FAB0000001'
		

			
			select 
			ISNULL(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) as Cliente,
			p1.CodCo1_ as CodCom,
			p1.Nombre1 as NomProdAFab,
			um1.NCorto as UMProdAFab,
			ffl.Cd_Flujo,
		    ffl.Nombre as NomFlujo,
			p1.CA01 as ProdFabCA01, p1.CA02 as ProdFabCA02, p1.CA03 as ProdFabCA03, p1.CA04 as ProdFabCA04, p1.CA05 as ProdFabCA05,  p1.CA06 as ProdFabCA06, p1.CA07 as ProdFabCA07, p1.CA08 as ProdFabCA08,  p1.CA09 as ProdFabCA09, p1.CA10 as ProdFabCA10,				
			ff.* 
			from FabFabricacion ff 
			inner join FabFlujo ffl on ffl.RucE = ff.RucE and ffl.Cd_Flujo = ff.cd_flujo
			left join Producto2 p1 on p1.RucE = ff.RucE and p1.Cd_Prod = ff.Cd_Prod 
			left join Cliente2 c on c.RucE = ff.RucE and c.Cd_Clt = ff.Cd_Clt
			left join TipDocIdn tdi on tdi.Cd_TDI = c.Cd_TDI
			left join Prod_UM pu1 on pu1.RucE = ff.RucE and pu1.ID_UMP = ff.Id_ump and pu1.Cd_Prod = ff.Cd_Prod
			left join UnidadMedida um1 on um1.Cd_UM = pu1.Cd_UM 
			where ff.RucE = @RucE and ff.Cd_Fab = @Cd_Fab
			
			
			--Almas
			Select
			ff.Cd_Fab,
			fp.ID_Prc as CodProc,
			fp.Nombre as NomProc,
			p2.Cd_Prod as CodProdIns,
		    p2.Nombre1 as NombreProdIns,
		    p2.Descrip as DescripProdIns,
		    p2.NCorto as NCortoProdIns,
		    fi.cant as CantIns,
			fi.Merma as MermaIns,
			p2.CA01 as ProdInsCA01,
			p2.CA02 as ProdInsCA02,
			p2.CA03 as ProdInsCA03,
			p2.CA04 as ProdInsCA04,
			p2.CA05 as ProdInsCA05,
			p2.CA06 as ProdInsCA06,
			p2.CA07 as ProdInsCA07,
			p2.CA08 as ProdInsCA08,
			p2.CA09 as ProdInsCA09,
			p2.CA10 as ProdInsCA10,
			pu2.DescripAlt as UMProdIns				
			
							
			from FabFabricacion ff			
			inner join FabProceso fp on fp.RucE = ff.RucE and fp.Cd_Flujo = ff.Cd_Flujo 
			inner join FabInsumo fi on fi.RucE = ff.RucE and fi.Cd_Flujo = ff.Cd_Flujo and fi.ID_Prc = fp.ID_Prc
			inner join producto2 p2 on p2.ruce = ff.ruce and p2.cd_prod = fi.cd_prod
			left join Prod_UM pu2 on pu2.RucE = ff.RucE and pu2.ID_UMP = ff.ID_UMP and pu2.Cd_Prod = fi.Cd_Prod
	    	left join UnidadMedida um2 on um2.Cd_UM = pu2.Cd_UM
			where ff.RucE = @RucE and ff.Cd_Fab = @Cd_Fab and  p2.Nombre1 like 'alm%'
			order by cd_fab,CodProc, NomProc
			--------------------
			
			Select
			ff.Cd_Fab,
			fp.ID_Prc as CodProc,
			fp.Nombre as NomProc,
			p2.Cd_Prod as CodProdIns,
		    p2.Nombre1 as NombreProdIns,
		    p2.Descrip as DescripProdIns,
		    p2.NCorto as NCortoProdIns,
		    fi.cant as CantIns,
			fi.Merma as MermaIns,
			p2.CA01 as ProdInsCA01,
			p2.CA02 as ProdInsCA02,
			p2.CA03 as ProdInsCA03,
			p2.CA04 as ProdInsCA04,
			p2.CA05 as ProdInsCA05,
			p2.CA06 as ProdInsCA06,
			p2.CA07 as ProdInsCA07,
			p2.CA08 as ProdInsCA08,
			p2.CA09 as ProdInsCA09,
			p2.CA10 as ProdInsCA10,
			pu2.DescripAlt as UMProdIns				
			
							
			from FabFabricacion ff			
			inner join FabProceso fp on fp.RucE = ff.RucE and fp.Cd_Flujo = ff.Cd_Flujo 
			inner join FabInsumo fi on fi.RucE = ff.RucE and fi.Cd_Flujo = ff.Cd_Flujo and fi.ID_Prc = fp.ID_Prc
			inner join producto2 p2 on p2.ruce = ff.ruce and p2.cd_prod = fi.cd_prod
			left join Prod_UM pu2 on pu2.RucE = ff.RucE and pu2.ID_UMP = ff.ID_UMP and pu2.Cd_Prod = fi.Cd_Prod
	    	left join UnidadMedida um2 on um2.Cd_UM = pu2.Cd_UM
			where ff.RucE = @RucE and ff.Cd_Fab = @Cd_Fab and  p2.Nombre1 like 'mang%'
			order by cd_fab,CodProc, NomProc
			----------------------------
			
			Select
			ff.Cd_Fab,
			fp.ID_Prc as CodProc,
			fp.Nombre as NomProc,
			p2.Cd_Prod as CodProdIns,
		    p2.Nombre1 as NombreProdIns,
		    p2.Descrip as DescripProdIns,
		    p2.NCorto as NCortoProdIns,
		    fi.cant as CantIns,
			fi.Merma as MermaIns,
			p2.CA01 as ProdInsCA01,
			p2.CA02 as ProdInsCA02,
			p2.CA03 as ProdInsCA03,
			p2.CA04 as ProdInsCA04,
			p2.CA05 as ProdInsCA05,
			p2.CA06 as ProdInsCA06,
			p2.CA07 as ProdInsCA07,
			p2.CA08 as ProdInsCA08,
			p2.CA09 as ProdInsCA09,
			p2.CA10 as ProdInsCA10,
			pu2.DescripAlt as UMProdIns				
			
							
			from FabFabricacion ff			
			inner join FabProceso fp on fp.RucE = ff.RucE and fp.Cd_Flujo = ff.Cd_Flujo 
			inner join FabInsumo fi on fi.RucE = ff.RucE and fi.Cd_Flujo = ff.Cd_Flujo and fi.ID_Prc = fp.ID_Prc
			inner join producto2 p2 on p2.ruce = ff.ruce and p2.cd_prod = fi.cd_prod
			left join Prod_UM pu2 on pu2.RucE = ff.RucE and pu2.ID_UMP = ff.ID_UMP and pu2.Cd_Prod = fi.Cd_Prod
	    	left join UnidadMedida um2 on um2.Cd_UM = pu2.Cd_UM
			where ff.RucE = @RucE and ff.Cd_Fab = @Cd_Fab and  p2.Nombre1 like 'ceramic%'
			order by cd_fab,CodProc, NomProc
			
			----------------------------------
			Select
			ff.Cd_Fab,
			fp.ID_Prc as CodProc,
			fp.Nombre as NomProc,
			p2.Cd_Prod as CodProdIns,
		    p2.Nombre1 as NombreProdIns,
		    p2.Descrip as DescripProdIns,
		    p2.NCorto as NCortoProdIns,
		    fi.cant as CantIns,
			fi.Merma as MermaIns,
			p2.CA01 as ProdInsCA01,
			p2.CA02 as ProdInsCA02,
			p2.CA03 as ProdInsCA03,
			p2.CA04 as ProdInsCA04,
			p2.CA05 as ProdInsCA05,
			p2.CA06 as ProdInsCA06,
			p2.CA07 as ProdInsCA07,
			p2.CA08 as ProdInsCA08,
			p2.CA09 as ProdInsCA09,
			p2.CA10 as ProdInsCA10,
			pu2.DescripAlt as UMProdIns				
			
							
			from FabFabricacion ff			
			inner join FabProceso fp on fp.RucE = ff.RucE and fp.Cd_Flujo = ff.Cd_Flujo 
			inner join FabInsumo fi on fi.RucE = ff.RucE and fi.Cd_Flujo = ff.Cd_Flujo and fi.ID_Prc = fp.ID_Prc
			inner join producto2 p2 on p2.ruce = ff.ruce and p2.cd_prod = fi.cd_prod
			left join Prod_UM pu2 on pu2.RucE = ff.RucE and pu2.ID_UMP = ff.ID_UMP and pu2.Cd_Prod = fi.Cd_Prod
	    	left join UnidadMedida um2 on um2.Cd_UM = pu2.Cd_UM
			where ff.RucE = @RucE and ff.Cd_Fab = @Cd_Fab and  p2.Nombre1 like 'filtr%'
			order by cd_fab,CodProc, NomProc
				
				
--creado <JA: 04/03/2013>
GO
