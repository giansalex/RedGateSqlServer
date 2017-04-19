SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CCostosCons_explo_PagSig1]
@RucE nvarchar(11),
@TamPag int,
@Ult_CC nvarchar(16),
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
			declare @Condicion varchar(1000)
			set @Condicion = 'RucE= '''+@RucE+'''and Cd_CC>'''+isnull(@Ult_CC,'')+''''
			declare @Consulta nvarchar(4000)
			set @Consulta = '	select top '+Convert(nvarchar,@TamPag)+'
			RucE,Cd_CC,Descrip,NCorto,CA01,CA02,CA03,CA04,CA05 from '+@Tablas+'
			where '+ @Condicion+' order by RucE,Cd_CC'
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
----------------------PRUEBA------------------------
--select * from CCostos where RucE='11111111111'
--Declare @NroRegs int,@NroPags int,@Max nvarchar(16),@Min nvarchar(16)
--exec dbo.Gsp_CCostosCons_explo_PagSig '11111111111',5,'',@NroRegs out,@NroPags out,@Max out,@Min out,null
GO
