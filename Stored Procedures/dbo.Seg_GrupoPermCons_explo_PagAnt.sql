SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Seg_GrupoPermCons_explo_PagAnt 'flucar','11111111111',100,139,'','',''
CREATE procedure [dbo].[Seg_GrupoPermCons_explo_PagAnt]
@NomUsu nvarchar(20),
@RucE nvarchar(11),
@TamPag int,
@Ult_NroFor char(7),
@Max char(7) output,
@Min char(7) output,
@msj varchar(100) output
as

		declare @nivel varchar(100)
			select @nivel = Nivel from Usuario
			where NomUsu = @NomUsu
			print @NomUsu
			Print @nivel
			
	declare @sql nvarchar(1000)
	declare @Cond varchar(1000)
	set @Cond = ' Cd_Prf in (select distinct usu.Cd_Prf from Usuario usu
			inner join Perfil prf on usu.Cd_Prf = prf.Cd_Prf
			where usu.Nivel like '''+@nivel+''' + ''%'')
			and f.Cd_GP<'''+convert(nvarchar,isnull(@Ult_NroFor,''))+''''	
	
	declare @Consulta nvarchar(4000)
	set @Consulta = 
	'select * from (select distinct top '+Convert(nvarchar,@TamPag)+ 
			' f.Cd_GP,f.Descrip,f.Estado,CantGP=(select count(*) from Usuario u
			left join PermisosE a on a.Cd_Prf=u.Cd_Prf
			where a.RucE='''+@RucE+''' and a.Cd_GP=f.Cd_GP) from GrupoPermisos f
			inner join PermisosE a on a.Cd_GP=f.Cd_GP
			 where '+ @Cond+' 
			 order by f.Cd_GP desc) as Cd_GP order by Cd_GP'
	
	
	/*'select * from (select distinct top '+Convert(nvarchar,@TamPag)+
	' f.Cd_GA,f.Descrip,f.Estado, CantGA= (select count(*) from Usuario u
	left join AccesoE a on a.Cd_Prf=u.Cd_Prf
	where a.RucE='''+@RucE+''' and a.Cd_GA=f.Cd_GA)
	 from GrupoAcceso f
			  left join AccesoE a on a.Cd_GA=f.Cd_GA
			 where '+ @Cond+' 
			 order by f.Cd_GA desc) as Cd_GA order by Cd_GA'*/
	
	set @sql = 'select top 1 @RMax =f.Cd_GP from GrupoPermisos f inner join PermisosE a on a.Cd_GP=f.Cd_GP where  '+@Cond+' order by f.Cd_GP desc'--ver orden por ApPat,ApMat,RSocial
	exec sp_executesql @sql, N'@RMax char(7) output', @Max output

	set @sql = 'select @RMin = min(Cd_GP) from(select distinct top '+Convert(nvarchar,@TamPag)+' f.Cd_GP from GrupoPermisos f inner join PermisosE a on a.Cd_GP=f.Cd_GP where  '+@Cond+' order by f.Cd_GP desc) as Cd_GP'
	exec sp_executesql @sql, N'@RMin char(7) output', @Min output
	print @sql
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> obtenemos el registro mÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ximo & mÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â­nimo de asientos //ordenado por : nrocta
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Exec (@Consulta) -- Ejecutamos la consulta
	print @Consulta
	--print @Max
	--print @Min
	--print @sql		
	
print @msj
print @Max
print @Min

/*
     0: General: select * from Tabla
     1: ComboBox: select CodNom, Cd_Entidad from Tabla where Estado=1
     2: Activos: select * from Tabla where Estado=1
     3: Ayuda: select Cd_Ent,NroDoc,Nombre from Tabla
*/

----------------------LEYENDA----------------------
--FL : Lun 30-05-2011 <creacion del procedimiento almacenado>


GO
