SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_Fabricacion_ConsXRegctb]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb char(15),
@NroCta nvarchar(10),
@msj varchar(100) output
as

select fb.RucE,fb.Cd_Clt,
		case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat +  '' + cl.ApMat + ',' + cl.Nom else cl.RSocial end as NomCli,
		fb.Cd_Fab, fb.NroFab, fb.Cd_Flujo, fl.Nombre as NomFlujo,  convert(nvarchar,fb.FecEmi,103) as FecEmi, 
		fb.Cd_Prod, prod.Nombre1 as NomProd, prod.Descrip as DescripProd, fb.ID_UMP,fb.Cant, um.DescripAlt as DescripUMP
		,isnull(sum(Fe.HorasTrab),0) as TotalHrs
		from FabFabricacion fb
		left join Producto2 prod on fb.Cd_Prod = prod.Cd_Prod and prod.RucE = fb.RucE
		left join Prod_UM um on um.RucE =  fb.RucE and um.ID_UMP = fb.ID_UMP and um.Cd_Prod = fb.Cd_Prod	
		inner join FabFlujo as fl on fl.RucE=fb.RucE and fl.Cd_Flujo = fb.Cd_Flujo
		inner join Cliente2 as cl on cl.RucE=fb.RucE and cl.Cd_Clt = fb.Cd_Clt  
		inner join FabComprobante fc on fb.RucE=fc.RucE and fb.Cd_Fab=fc.Cd_Fab 
		left join FabEtapa as Fe on fb.RucE=Fe.RucE and fb.Cd_Fab=Fe.Cd_Fab
		where fc.RucE= @RucE and fc.Ejer=@Ejer and fc.RegCtb=@RegCtb and fc.NroCta=@NroCta
		group by fb.RucE,fb.Cd_Clt,cl.RSocial,cl.ApPat,cl.ApMat,cl.Nom,fb.Cd_Fab,fb.NroFab, fb.Cd_Flujo, fl.Nombre,
				 fb.FecEmi,fb.Cd_Prod, prod.Nombre1, prod.Descrip,fb.ID_UMP,fb.Cant, um.DescripAlt
			
print @msj
--Leyenda
--CE : 22/02/2013 <Creacion del SP>

--exec Fab_Fabricacion_ConsXRegctb '11111111111','2013','CPGE_RC02-00001','94.2.1.10',null
GO
