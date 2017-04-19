SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CCostosCons_explo_PagSig2]
@RucE nvarchar(11),
@TamPag int,
@Ult_CC nvarchar(8),
@NroRegs int output,      	
@NroPags int output,      	
@Max nvarchar(16) output,	
@Min nvarchar(16) output, 	
@msj varchar(100) output
as
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Inicio 				Consulta de CCostos General
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
			declare @Tablas varchar(1000)
			set @Tablas = ' CCostos'

			declare @Tablas2 varchar(1000)
			set @Tablas2 = ' CCSub'

			declare @Condicion varchar(1000)
			set @Condicion = ''+@Tablas+'.RucE= '''+@RucE+'''and '+@Tablas+'.Cd_CC>'''+isnull(@Ult_CC,'')+''''
			declare @Consulta nvarchar(4000)
	
			set @Consulta = '	select top '+Convert(nvarchar,@TamPag)+'
			'+@Tablas+'.RucE,'+@Tablas+'.Cd_CC,'+@Tablas+'.Descrip,'+@Tablas+'.NCorto,count('+@Tablas2+'.Cd_SC) as ''Sub C.C'' ,
			'+@Tablas+'.CA01,'+@Tablas+'.CA02,'+@Tablas+'.CA03,'+@Tablas+'.CA04,'+@Tablas+'.CA05 

			from '+@Tablas+'
			left join '+@Tablas2+'  on '+@Tablas2+'.RucE='+@Tablas+'.RucE and '+@Tablas2+'.Cd_CC = '+@Tablas+'.Cd_CC 	
			where '+ @Condicion+' 	
			group by '+@Tablas+'.RucE,'+@Tablas+'.Cd_CC,'+@Tablas+'.Descrip,'+@Tablas+'.NCorto,'+@Tablas+'.CA01,'+@Tablas+'.CA02,'+@Tablas+'.CA03,'+@Tablas+'.CA04,'+@Tablas+'.CA05			
			order by '+@Tablas+'.RucE,'+@Tablas+'.Cd_CC'

			print (@Consulta)
			Exec (@Consulta)
	
		
	

	

			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Final 				Consulta de CCostos General
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		if (@Ult_CC='' or @Ult_CC is null)
			begin
				/********************************************************************************************************************************************************/
				--				Inicio de la implementacion del procedimiento : sp_executesql
				/********************************************************************************************************************************************************/
				declare @sql nvarchar(1000)
				set @sql= 'select @Regs = count(Cd_CC) from '+@Tablas+ '  where ' + @Condicion
				exec sp_executesql @sql, N'@Regs int output', @NroRegs output
				select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
				
				/********************************************************************************************************************************************************/
				--				Fin de la implementacion del procedimiento : sp_executesql
				/********************************************************************************************************************************************************/

			end				
				/********************************************************************************************************************************************************/
				--				Inicio : Faltaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				/********************************************************************************************************************************************************/
				set @sql = 'select @RMax = max(Cd_CC) from(select top '+Convert(nvarchar,@TamPag)+' Cd_CC from '+@Tablas+' 
				where '+@Condicion+' order by RucE,Cd_CC/*ApPat, ApMat,RSocial*/) as CCostos'
				exec sp_executesql @sql, N'@RMax nvarchar(16) output', @Max output

				set @sql = 'select top 1 @RMin =Cd_CC from '+@Tablas+' where '+@Condicion+' order by RucE,Cd_CC/*ApPat, ApMat,RSocial*/'
				exec sp_executesql @sql, N'@RMin nvarchar(16) output', @Min output
		
print @msj

----------------------LEYENDA----------------------
--J : Mar 12-10-2010 <creacion>
--MP: 20/03/2012 : <Creacion con Campos Adicionales>
-- GGONZ : 29/12/2016 : <Creacion con campos Adicionales >
----------------------PRUEBA------------------------
--select * from CCostos where RucE='11111111111'
--Declare @NroRegs int,@NroPags int,@Max nvarchar(16),@Min nvarchar(16)
--exec dbo.Gsp_CCostosCons_explo_PagSig '11111111111',5,'',@NroRegs out,@NroPags out,@Max out,@Min out,null



GO
