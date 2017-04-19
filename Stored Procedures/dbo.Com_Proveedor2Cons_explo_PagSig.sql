SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2Cons_explo_PagSig]
@RucE nvarchar(11),
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inicio 		  		--Variables que se usaran para la paginaciÃ³n
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@TamPag int, 	          		--TamaÃ±o Pagina
@Ult_Prov nvarchar(7),
@NroRegs int output,      	--Nro de Registros solo es consultado la primera vez
@NroPags int output,      	--Nro de Paginas solo es consultado la primera vez
@Max nvarchar(7) output,	--Codigo del Auxiliar mÃ¡ximo que es consultado dentro del top
@Min nvarchar(7) output, 	--Codigo del Auxiliar mÃ­nimo que es consultado dentro del top
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Final 				-- Variables que se usaran para la paginaciÃ³n
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@msj varchar(100) output
as

		/*
		  select top 100
		   a.RucE,a.Cd_Aux,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		   a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Cd_TA,c.Nombre as NomTipAux,a.Estado
	                from Auxiliar a
		   left join TipDocIdn b on a.Cd_TDI=b.Cd_TDI
	                left join TipAux c on a.Cd_TA=c.Cd_TA
		  where a.RucE=@RucE
		  and a.Cd_Aux > @Ult_Aux
		  order by a.RucE, a.Cd_Aux
		*/
		--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Inicio 				Consulta de Auxiliares General
		--------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Tablas que almacena
			las tablas que se intersectarÃ¡n en la consulta
			-----------------------------------------------------------------------------------------------*/
			declare @Tablas varchar(1000)
			set @Tablas = ' Proveedor2 a
			left join TipDocIdn b on a.Cd_TDI=b.Cd_TDI
			left join Pais c on a.Cd_Pais=c.Cd_Pais'
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Condicion que almacena
			la condiciÃ³n de la sentencia Where de la consulta
			que se realizarÃ¡
			-----------------------------------------------------------------------------------------------*/
			declare @Condicion varchar(1000)
			set @Condicion = 'a.RucE= '''+@RucE+'''and a.Cd_Prv>'''+isnull(@Ult_Prov,'')+''''
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Consulta que almacena
			la consulta y se implementan las variables 
			@Tablas & @Condicion
			-----------------------------------------------------------------------------------------------*/
			declare @Consulta nvarchar(4000)
			set @Consulta = '	select top '+Convert(nvarchar,@TamPag)+'
			 a.RucE,a.Cd_Prv,a.Cd_TDI,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,a.Cd_Pais,c.Nombre,a.CodPost,a.Ubigeo,
			a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.Obs,a.CtaCtb,a.CA01,a.CA02,a.CA03,a.CA04,a.CA05,a.CA06,a.CA07,a.CA08,a.CA09,a.CA10,a.Estado from '+@Tablas+'
			where '+ @Condicion+' order by a.RucE, a.Cd_Prv/*order by a.RucE, a.Cd_Aux,ApPat,ApMat,RSocial*/'
			Exec (@Consulta)
			--print @Consulta

			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Final 				Consulta de Auxiliares General
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		if (@Ult_Prov='' or @Ult_Prov is null)
			begin
				/*select @NroRegs  = count(Cd_Aux) from Auxiliar where RucE=@RucE
				select @NroPags = @NroRegs/100 + 1
				print  @NroRegs	
				print  @NroPags*/
				/********************************************************************************************************************************************************/
				--				Inicio de la implementacion del procedimiento : sp_executesql
				/********************************************************************************************************************************************************/
			
				/*declare @sql nvarchar(500)--,@RucE nvarchar(11),@NroRegs int
				--set @RucE='11111111111'
				set @sql = N'select @Regs=count(a.Cd_Aux) from'+ @Tablas +'where '+@Condicion+'
				--print ''Imprimimos count desde adentro: ''
				print @Regs'
				exec sp_executesql @sql,N'@RucE nvarchar(11), @Regs int output',@RucE,@NroRegs OUTPUT
				--print @NroRegs
				select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end -- @NroRegs/100 + 1 
				--print  @NroRegs	
				--print  @NroPags
				-- @RucE,@Ejer, @CountOut=@Count OUTPUT (Ã³ tb si se necesita enviar algo en la misma variable)
				--print 'Imprimimos count desde afuera: '*/
				declare @sql nvarchar(1000)
				set @sql= 'select @Regs = count(Cd_Prv) from '+@Tablas+ '  where ' + @Condicion
				exec sp_executesql @sql, N'@Regs int output', @NroRegs output
				select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
				
				/*				
				set @sql= 'select @Regs = count(*) from '+@Inter+ '  where ' + @Cond
				exec sp_executesql @sql, N'@Regs int output', @NroRegs output
				--select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1			
				*/
				/********************************************************************************************************************************************************/
				--				Fin de la implementacion del procedimiento : sp_executesql
				/********************************************************************************************************************************************************/

			end				
				/********************************************************************************************************************************************************/
				--				Inicio : Faltaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				/********************************************************************************************************************************************************/
				--Declare @Max nvarchar(10)
				--select @Max = max(Cd_Aux) from (select top 1 Cd_Aux  from Auxiliar where RucE=@RucE and Cd_Aux > @Ult_Aux order by RucE, Cd_Aux) as CdAuxX
				--select @Max = max(Cd_Aux) from (select top 1 Cd_Aux  from Auxiliar where RucE='11111111111' and Cd_Aux > '' order by RucE, Cd_Aux) as CdAuxX
				--print @Max
				--set @Min = (select top 1 Cd_Aux  from Auxiliar where RucE=@RucE and Cd_Aux > @Ult_Aux order by RucE, Cd_Aux )
				
				set @sql = 'select @RMax = max(Cd_Prv) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Prv from '+@Tablas+' where '+@Condicion+' order by RucE,Cd_Prv/*ApPat, ApMat,RSocial*/) as Proveedor'
				exec sp_executesql @sql, N'@RMax nvarchar(7) output', @Max output

				set @sql = 'select top 1 @RMin =Cd_Prv from '+@Tablas+' where '+@Condicion+' order by RucE,Cd_Prv/*ApPat, ApMat,RSocial*/'
				exec sp_executesql @sql, N'@RMin nvarchar(7) output', @Min output
				/********************************************************************************************************************************************************/
				--				Fin : Faltaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				/********************************************************************************************************************************************************/
print @msj
----------------------LEYENDA----------------------
--J : Mar 12-10-2010 <creacion>
----------------------PRUEBA------------------------
--select * from Proveedor2 Where RucE='11111111111'
--Declare @NroRegs int,@NroPags int,@Max nvarchar(10),@Min nvarchar(10)
--exec dbo.Com_Proveedor2Cons_explo_PagSig '11111111111',10,'',@NroRegs out,@NroPags out,@Max out,@Min out,null


GO
