SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CCostosCons_explo_PagAnt1]
@RucE nvarchar(11),
@TamPag int,
@Ult_CC nvarchar(16),
@Max nvarchar(16) output,
@Min nvarchar(16) output,
@msj varchar(100) output
as
		
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> consulta proveedores pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	declare @Inter varchar(1000)
	set @Inter = ' CCostos'
	declare @sql nvarchar(1000)
	declare @Cond varchar(1000)
	set @Cond = 'RucE= '''+@RucE+'''and Cd_CC<'''+isnull(@Ult_CC,'')+''''	
	
	declare @Consulta nvarchar(4000)
	set @Consulta = 
	'select *from (select top '+Convert(nvarchar,@TamPag)+' RucE,Cd_CC,Descrip,NCorto,CA01,CA02,CA03,CA04,CA05 from 
	'+@Inter+' where '+@Cond+'order by Cd_CC desc) as CCostos order by Cd_CC'
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> consulta auxiliares pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> obtenemos el registro mÃ¡ximo & mÃ­nimo de ccostos //ordenado por : ApPat,ApMat,RSocial
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	set @sql = 'select top 1 @RMax =Cd_CC from '+@Inter+' where  '+@Cond+' order by Cd_CC desc'--ver orden por ApPat,ApMat,RSocial
	exec sp_executesql @sql, N'@RMax nvarchar(16) output', @Max output

	set @sql = 'select @RMin = min(Cd_CC) from(select top '+Convert(nvarchar,@TamPag)+'Cd_CC from '+@Inter+' where  
	'+@Cond+' order by Cd_CC desc) as CCostos'
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
----------------------PRUEBA------------------------
--select * from CCostos where RucE='11111111111'
--Declare @Max nvarchar(16),@Min nvarchar(16)
--exec dbo.Gsp_CCostosCons_explo_PagAnt '11111111111',1,'0003',@Max out,@Min out,null


GO
