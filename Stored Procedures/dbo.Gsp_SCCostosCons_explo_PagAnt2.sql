SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SCCostosCons_explo_PagAnt2]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),--anteriormente  longitud de 16
@TamPag int,
@Ult_SC nvarchar(8), --anteriormente  longitud de 16
@Max nvarchar(16) output,
@Min nvarchar(16) output,
@msj varchar(100) output
as
		
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> consulta scostos pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	declare @Inter varchar(1000)
	set @Inter = ' CCSub'

	declare @Inter2 varchar(1000)
	set @Inter2 = ' CCSubSub'		

	declare @sql nvarchar(1000)
	declare @Cond varchar(1000)
	--set @Cond = 'RucE= '''+@RucE+'''and Cd_SC<'''+isnull(@Ult_SC,'')+''''	
	set @Cond = ''+@Inter+'.RucE= '''+@RucE+ ''' and '+@Inter+'.Cd_CC ='''+@Cd_CC+''' and '+@Inter+'.Cd_SC<'''+isnull(@Ult_SC,'')+''''

	declare @Consulta nvarchar(4000)
	set @Consulta = 
	'select *from (
	select top '+Convert(nvarchar,@TamPag)+ '
			'+@Inter+'.RucE,'+@Inter+'.Cd_CC,'+@Inter+'.Cd_SC,'+@Inter+'.Descrip,
			'+@Inter+'.NCorto,count('+@Inter2+'.Cd_SS) as ''SSub C.C.'' ,
			'+@Inter+'.CA01,'+@Inter+'.CA02,'+@Inter+'.CA03,'+@Inter+'.CA04,'+@Inter+'.CA05 
			from '+@Inter+'
			left join '+@Inter2+'  
				on '+@Inter2+'.RucE='+@Inter+'.RucE and '+@Inter2+'.Cd_CC = '+@Inter+'.Cd_CC  and '+@Inter2+'.Cd_SC = '+@Inter+'.Cd_SC 	 

			where '+ @Cond+' 
			group by '+@Inter+'.RucE,'+@Inter+'.Cd_CC,'+@Inter+'.Cd_SC,'+@Inter+'.Descrip,'+@Inter+'.NCorto,'+@Inter+'.CA01,'+@Inter+'.CA02,'+@Inter+'.CA03,'+@Inter+'.CA04,'+@Inter+'.CA05	
			order by '+@Inter+'.RucE,'+@Inter+'.Cd_CC,'+@Inter+'.Cd_SC desc

	) as SCostos order by RucE,Cd_CC,Cd_SC'
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> consulta scostos pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> obtenemos el registro mÃ¡ximo & mÃ­nimo de scostos //ordenado por : ApPat,ApMat,RSocial
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	set @sql = 'select top 1 @RMax =Cd_SC from '+@Inter+' where  '+@Cond+' order by RucE,Cd_CC,Cd_SC desc'--ver orden por ApPat,ApMat,RSocial
	exec sp_executesql @sql, N'@RMax nvarchar(16) output', @Max output

	set @sql = 'select @RMin = min(Cd_SC) from(select top '+Convert(nvarchar,@TamPag)+'Cd_SC from '+@Inter+' where  
	'+@Cond+' order by RucE,Cd_CC,Cd_SC desc) as SCostos'
	exec sp_executesql @sql, N'@RMin nvarchar(16) output', @Min output
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> obtenemos el registro mÃ¡ximo & mÃ­nimo de scostos //ordenado por : ApPat,ApMat,RSocial
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Exec (@Consulta) -- Ejecutamos la consulta 
			
	print @Max
	print @Min
	print @sql
	
print @msj

----------------------LEYENDA----------------------
--J : Mar 12-10-2010 <creacion>
--MP : 20/12/2012 : <Creacion del procedimiento almacenado con Campos Adicionales>
----------------------PRUEBA------------------------
--select * from CCSub where RucE='11111111111' and Cd_CC='0003'
--Declare @Max nvarchar(16),@Min nvarchar(16)
--exec dbo.Gsp_SCCostosCons_explo_PagAnt '11111111111','0001',2,'02020202',@Max out,@Min out,null


GO
