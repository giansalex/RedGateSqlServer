SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SSCCostosCons_explo_PagSig1]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inicio 		  		--Variables que se usaran para la paginación
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@TamPag int, 	          		--Tamaño Pagina
@Ult_SSC nvarchar(8),
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
			set @Tablas = ' CCSubSub'
			declare @Condicion varchar(1000)
			--set @Condicion = 'RucE= '''+@RucE+'''and Cd_CC>'''+isnull(@Ult_CC,'')+''''
			--set @Condicion = 'RucE= '''+@RucE+ ''' and Cd_CC ='''+@Cd_CC+''' and Cd_SC>'''+isnull(@Ult_SSC,'')+''''
			set @Condicion = 'RucE='''+@RucE+ ''' and Cd_CC='''+@Cd_CC+'''and Cd_SC='''+@Cd_SC+''' and Cd_SS>'''+isnull(@Ult_SSC,'')+''''
			declare @Consulta nvarchar(4000)
			set @Consulta = '	select top '+Convert(nvarchar,@TamPag)+'
			RucE,Cd_CC,Cd_SC,Cd_SS,Descrip,NCorto,CA01,CA02,CA03,CA04,CA05 from '+@Tablas+'
			where '+ @Condicion+' order by RucE,Cd_CC,Cd_SC,Cd_SS'
			Exec (@Consulta)
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Final 				Consulta de SCostos General
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		if (@Ult_SSC='' or @Ult_SSC is null)
			begin
				/********************************************************************************************************************************************************/
				--				Inicio de la implementacion del procedimiento : sp_executesql
				/********************************************************************************************************************************************************/
				declare @sql nvarchar(1000)
				set @sql= 'select @Regs = count(Cd_SS) from '+@Tablas+ '  where ' + @Condicion
				exec sp_executesql @sql, N'@Regs int output', @NroRegs output
				select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
				
				/********************************************************************************************************************************************************/
				--				Fin de la implementacion del procedimiento : sp_executesql
				/********************************************************************************************************************************************************/

			end				
				/********************************************************************************************************************************************************/
				--				Inicio : Faltaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				/********************************************************************************************************************************************************/
				set @sql = 'select @RMax = max(Cd_SS) from(select top '+Convert(nvarchar,@TamPag)+' Cd_SS from '+@Tablas+' 
				where '+@Condicion+' order by RucE,Cd_CC,Cd_SC,Cd_SS) as SCostos'
				exec sp_executesql @sql, N'@RMax nvarchar(16) output', @Max output

				set @sql = 'select top 1 @RMin =Cd_SS from '+@Tablas+' where '+@Condicion+' order by RucE,Cd_CC,Cd_SC,Cd_SS'
				exec sp_executesql @sql, N'@RMin nvarchar(16) output', @Min output
		
print @msj
----------------------LEYENDA----------------------
--J : Mar 12-10-2010 <creacion>
--MP : 21/03/2012 : <Creacion del procedimiento almacenado con Campos Adicionales>
----------------------PRUEBA------------------------
--select * from CCSubSub where RucE='11111111111' and Cd_CC='0003' and Cd_SC='0031'
--Declare @NroRegs int,@NroPags int,@Max nvarchar(16),@Min nvarchar(16)
--exec dbo.Gsp_SSCCostosCons_explo_PagSig '11111111111','0003','0031',5,'',@NroRegs out,@NroPags out,@Max out,@Min out,null
GO
