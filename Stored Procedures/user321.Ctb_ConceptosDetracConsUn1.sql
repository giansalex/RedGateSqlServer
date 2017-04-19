SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Ctb_ConceptosDetracConsUn1]
@RucE nvarchar(11),
@Cd_CDtr char(4),
@msj varchar(100) output
as

if not exists (select Top 1 *from ConceptosDetrac a 
where a.RucE=@RucE and a.Cd_CDtr=@Cd_CDtr)
		set @msj='Concepto de Detraccion no existe'
else
	begin
		select Top 1 a.RucE,a.Cd_CDtr,a.Descrip,a.Cd_Prod,a.Cd_Srv,
		case when isnull(a.Cd_Srv,'')='' then prod.Nombre1 else serv.Nombre end  as Bien 
		from ConceptosDetrac a
		left join Servicio2 serv on (serv.Cd_Srv=a.Cd_Srv and serv.RucE=a.RucE) 
		left join Producto2 prod on (prod.Cd_Prod=a.Cd_Prod and prod.RucE=a.RucE)
		where a.RucE=@RucE and a.Cd_CDtr=@Cd_CDtr
	end
	
-- Leyenda --
-- JJ 05/02/2011: <Creacion del procedimiento almacenado>
--select Top 1 *from Servicio2 where RucE='11111111111' and Cd_CDtr='0001'
--select Top 1 *from Servicio2 where Cd_Srv='SRC0001'

		--select Top 1 a.RucE,a.Cd_CDtr,a.Descrip,a.Cd_Prod,a.Cd_Srv
		--,case when isnull(a.Cd_Srv,'')='' then prod.Nombre1 else serv.Nombre end  as Bien 
		--from ConceptosDetrac a
		--left join Servicio2 serv on (serv.Cd_Srv=a.Cd_Srv and serv.RucE=a.RucE) 
		--left join Producto2 prod on (prod.Cd_Prod=a.Cd_Prod and prod.RucE=a.RucE)
		--where a.RucE='11111111111' and a.Cd_CDtr='0001'
GO
