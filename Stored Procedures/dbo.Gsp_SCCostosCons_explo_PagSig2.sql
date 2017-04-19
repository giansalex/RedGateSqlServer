SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SCCostosCons_explo_PagSig2]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inicio 		  		--Variables que se usaran para la paginación
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@TamPag int, 	          		--Tamaño Pagina
@Ult_SC nvarchar(8),
@NroRegs int output,      	--Nro de Registros solo es consultado la primera vez
@NroPags int output,      	--Nro de Paginas solo es consultado la primera vez
@Max nvarchar(16) output,	--Codigo del Auxiliar máximo que es consultado dentro del top
@Min nvarchar(16) output, 	--Codigo del Auxiliar mínimo que es consultado dentro del top
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Final 				-- Variables que se usaran para la paginación
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@msj varchar(100) output
as
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Inicio 				Consulta de SCostos General
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
			declare @Tablas varchar(1000)
			set @Tablas = ' CCSub'

			declare @Tablas2 varchar(1000)
			set @Tablas2 = ' CCSubSub'		

			declare @Condicion varchar(1000)
			--set @Condicion = 'RucE= '''+@RucE+'''and Cd_CC>'''+isnull(@Ult_CC,'')+''''
			set @Condicion = ''+@Tablas+'.RucE= '''+@RucE+ ''' and '+@Tablas+'.Cd_CC ='''+@Cd_CC+''' and '+@Tablas+'.Cd_SC>'''+isnull(@Ult_SC,'')+''''
			declare @Consulta nvarchar(4000)
			set @Consulta = '	select top '+Convert(nvarchar,@TamPag)+ '
			'+@Tablas+'.RucE,'+@Tablas+'.Cd_CC,'+@Tablas+'.Cd_SC,'+@Tablas+'.Descrip,
			'+@Tablas+'.NCorto,count('+@Tablas2+'.Cd_SS) as ''SSub C.C.'' ,
			'+@Tablas+'.CA01,'+@Tablas+'.CA02,'+@Tablas+'.CA03,'+@Tablas+'.CA04,'+@Tablas+'.CA05 
			from '+@Tablas+'
			left join '+@Tablas2+'  
				on '+@Tablas2+'.RucE='+@Tablas+'.RucE and '+@Tablas2+'.Cd_CC = '+@Tablas+'.Cd_CC  and '+@Tablas2+'.Cd_SC = '+@Tablas+'.Cd_SC 	 

			where '+ @Condicion+' 
			group by '+@Tablas+'.RucE,'+@Tablas+'.Cd_CC,'+@Tablas+'.Cd_SC,'+@Tablas+'.Descrip,'+@Tablas+'.NCorto,'+@Tablas+'.CA01,'+@Tablas+'.CA02,'+@Tablas+'.CA03,'+@Tablas+'.CA04,'+@Tablas+'.CA05	
			order by '+@Tablas+'.RucE,'+@Tablas+'.Cd_CC,'+@Tablas+'.Cd_SC'
			
			
			Exec (@Consulta)
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Final 				Consulta de SCostos General
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		if (@Ult_SC='' or @Ult_SC is null)
			begin
				/********************************************************************************************************************************************************/
				--				Inicio de la implementacion del procedimiento : sp_executesql
				/********************************************************************************************************************************************************/
				declare @sql nvarchar(1000)
				set @sql= 'select @Regs = count(Cd_SC) from '+@Tablas+ '  where ' + @Condicion
				exec sp_executesql @sql, N'@Regs int output', @NroRegs output
				select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
				
				/********************************************************************************************************************************************************/
				--				Fin de la implementacion del procedimiento : sp_executesql
				/********************************************************************************************************************************************************/

			end				
				/********************************************************************************************************************************************************/
				--				Inicio : Faltaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				/********************************************************************************************************************************************************/
				set @sql = 'select @RMax = max(Cd_SC) from(select top '+Convert(nvarchar,@TamPag)+' Cd_SC from '+@Tablas+' 
				where '+@Condicion+' order by RucE,Cd_CC,Cd_SC) as SCostos'
				exec sp_executesql @sql, N'@RMax nvarchar(16) output', @Max output

				set @sql = 'select top 1 @RMin =Cd_SC from '+@Tablas+' where '+@Condicion+' order by RucE,Cd_CC,Cd_SC'
				exec sp_executesql @sql, N'@RMin nvarchar(16) output', @Min output
		
print @msj
----------------------LEYENDA----------------------
--J : Mar 12-10-2010 <creacion>
--MP : 20/12/2012 : <Creacion del procedimiento almacenado con Campos Adicionales>
-- GGONZ: 29/12/2016 : <Creacion del procedimient almacenado con campos adicional "SSub C.C." >
----------------------PRUEBA------------------------
--select * from CCSub where RucE='11111111111' and Cd_CC='0003'
--Declare @NroRegs int,@NroPags int,@Max nvarchar(16),@Min nvarchar(16)
--exec dbo.Gsp_SCCostosCons_explo_PagSig '11111111111','0003',5,'',@NroRegs out,@NroPags out,@Max out,@Min out,null




GO
