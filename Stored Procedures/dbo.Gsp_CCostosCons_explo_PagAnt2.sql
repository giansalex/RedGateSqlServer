SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CCostosCons_explo_PagAnt2]
@RucE nvarchar(11),
@TamPag int,
@Ult_CC nvarchar(8),
@Max nvarchar(16) output,
@Min nvarchar(16) output,
@msj varchar(100) output
as
		
--	exec Gsp_CCostosCons_explo_PagAnt2 '20160000001',10,SEÑ01,null,null,null

	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> consulta proveedores pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	declare @Inter varchar(1000)
	set @Inter = ' CCostos'

	declare @Inter2 varchar(1000)
	set @Inter2 = 'CCSub'

	declare @sql nvarchar(1000)
	declare @Cond varchar(1000)
	set @Cond = ''+@Inter+'.RucE= '''+@RucE+''' and '+@Inter+'.Cd_CC<'''+isnull(@Ult_CC,'')+''''	
	
	declare @Consulta nvarchar(4000)
	set @Consulta = 
	'select *
	from (
		select top '+Convert(nvarchar,@TamPag)+ ' 
			'+@Inter+'.RucE,'+@Inter+'.Cd_CC,'+@Inter+'.Descrip,'+@Inter+'.NCorto,count('+@Inter2+'.Cd_SC) as ''Sub C.C'' ,
			'+@Inter+'.CA01,'+@Inter+'.CA02,'+@Inter+'.CA03,'+@Inter+'.CA04,'+@Inter+'.CA05 
			   from  '+@Inter+'
			   left join '+@Inter2+'  on '+@Inter2+'.RucE='+@Inter+'.RucE and '+@Inter2+'.Cd_CC = '+@Inter+'.Cd_CC 	
			    
		where '+@Cond+'
		group by '+@Inter+'.RucE,'+@Inter+'.Cd_CC ,'+@Inter+'.Descrip,'+@Inter+'.NCorto,'+@Inter+'.CA01,'+@Inter+'.CA02,'+@Inter+'.CA03,'+@Inter+'.CA04,'+@Inter+'.CA05			
		order by '+@Inter+'.Cd_CC desc
		
	) 	
	as CCostos order by  Cd_CC'

	
	
		
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> consulta auxiliares pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> obtenemos el registro mÃ¡ximo & mÃ­nimo de ccostos //ordenado por : ApPat,ApMat,RSocial
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	set @sql = 'select top 1 @RMax ='+@Inter+'.Cd_CC from '+@Inter+' where  '+@Cond+' order by '+@Inter+'.Cd_CC desc'--ver orden por ApPat,ApMat,RSocial
	exec sp_executesql @sql, N'@RMax nvarchar(16) output', @Max output

	set @sql = 'select @RMin = min(Cd_CC) from(select top '+Convert(nvarchar,@TamPag)+''+@Inter+'.Cd_CC from '+@Inter+' where  
	'+@Cond+' order by '+@Inter+'.Cd_CC desc) as CCostos'
	exec sp_executesql @sql, N'@RMin nvarchar(16) output', @Min output
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> obtenemos el registro mÃ¡ximo & mÃ­nimo de ccostos //ordenado por : ApPat,ApMat,RSocial
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Exec (@Consulta) -- Ejecutamos la consulta 
			
	print @Max
	print @Min
	print @sql
	
print @msj

----------------------LEYENDA----------------------
--J : Mar 12-10-2010 <creacion>
--MP : 20/03/2012 : <Creacion con Campos Adicionales> 
--GGONZ: 29/12/2016 : <Creacion con campos Adicionales " Sub. CC" >
----------------------PRUEBA------------------------
--select * from CCostos where RucE='11111111111'
--Declare @Max nvarchar(16),@Min nvarchar(16)
--exec dbo.Gsp_CCostosCons_explo_PagAnt '11111111111',1,'0003',@Max out,@Min out,null


GO
