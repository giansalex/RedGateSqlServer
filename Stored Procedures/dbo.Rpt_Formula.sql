SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--declare 
CREATE procedure [dbo].[Rpt_Formula]
@RucE nvarchar(11),
@ID_Fmla int
 as
--set @RucE = '20536756541'
--set @ID_Fmla = 53

    

	select 
	      em.RSocial as RSocial,
		  pr.codCo1_ as Cd_Prod,
		  pr.Nombre1 as Nombre1,
		  pr.Nombre2 as Nombre2,
		  f.Obs as Obs,
		  isnull(f.CA01,'') as CA01,
		  isnull(f.CA02,'') as CA02,
		  isnull(f.CA03,'') as CA03,
		  isnull(f.CA04,'') as CA04,
		  isnull(f.CA05,'') as CA05,
		  isnull(f.CA06,'') as CA06,
		  isnull(f.CA07,'') as CA07,
		  isnull(f.CA08,'') as CA08,
		  isnull(f.CA09,'') as CA09,
		  isnull(f.CA10,'') as CA10,
		  isnull(f.CA11,'') as CA11,
		  isnull(f.CA12,'') as CA12,
		  isnull(f.CA13,'') as CA13,
		  isnull(f.CA14,'') as CA14,
		  isnull(f.CA15,'') as CA15,
		  (select  sum(fd.cant) as Cant
	       from FormulaDet fd
	       where fd.RucE = @RucE and fd.ID_Fmla = @ID_Fmla) as Cant,
	       f.Proced as Proced
		 
	from formula f
	left join Producto2 pr on f.RucE=pr.RucE and f.Cd_Prod=pr.Cd_Prod
	Inner join Empresa em on em.Ruc=pr.RucE

	where f.RucE =@RucE and f.ID_Fmla = @ID_Fmla
	
	
	------------------------------------
	select 
	     fd.Item as Item,
	     isnull(prod.CodCo1_,isnull(prod.Cd_Prod,'')) as Cd_prodDet,
	     prod.Nombre1 as Descripcion,
	     prod.Nombre2 as Descripcion2, 
	     fd.Cant as CantDet
	     
	from FormulaDet fd
	
	left join Producto2 prod on prod.RucE=fd.RucE and prod.Cd_Prod=fd.Cd_Prod  

	where fd.RucE = @RucE and fd.ID_Fmla = @ID_Fmla
	
--Creado por Analy
--18/09/2012
--exec Rpt_Formula '20536756541', 53
	
--
	
	
GO
