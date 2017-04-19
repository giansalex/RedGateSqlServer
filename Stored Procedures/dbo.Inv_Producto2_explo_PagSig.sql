SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2_explo_PagSig]
@RucE nvarchar(11),
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inicio 		  		--Variables que se usaran para la paginaciÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³n
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@TamPag int, 	          	--TamaÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â±o Pagina
@Ult_Prod nvarchar(7),		
@NroRegs int output,      	--Nro de Registros solo es consultado la primera vez
@NroPags int output,      	--Nro de Paginas solo es consultado la primera vez
@Max nvarchar(7) output,	--Codigo del Producto mÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ximo que es consultado dentro del top
@Min nvarchar(7) output, 	--Codigo del Producto mÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â­nimo que es consultado dentro del top
@TipProd int=3,			---Indicador que nos dice que tipo de producto es
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Final 			-- Variables que se usaran para la paginaciÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³n
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@msj varchar(100) output
as

		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inicio 				Consulta de Producto2 General
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Tablas que almacena
			las tablas que se intersectarÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡n en la consulta
			-----------------------------------------------------------------------------------------------*/
			declare @Tablas varchar(1000)
			set @Tablas = ' Producto2 a '
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Condicion que almacena
			la condiciÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³n de la sentencia Where de la consulta
			que se realizarÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡
			-----------------------------------------------------------------------------------------------*/
			declare @Condicion varchar(1000) 
			if(@TipProd=0)--para PT
				set @Condicion = ' a.IB_PT=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod>'''+isnull(@Ult_Prod,'')+''''
			else if(@TipProd=1)--para MP
				set @Condicion = ' a.IB_MP=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod>'''+isnull(@Ult_Prod,'')+''''
			else if(@TipProd=2)--para EE
				set @Condicion = ' a.IB_EE=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod>'''+isnull(@Ult_Prod,'')+''''
			else if(@TipProd=3)--para TODO
				set @Condicion = ' a.RucE= '''+@RucE+'''and a.Cd_Prod>'''+isnull(@Ult_Prod,'')+''''
			else if(@TipProd=4)--para ParaVta
				set @Condicion = ' a.IB_PV=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod>'''+isnull(@Ult_Prod,'')+''''
			else if(@TipProd=5)--para ParaCom
				set @Condicion = ' a.IB_PC=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod>'''+isnull(@Ult_Prod,'')+''''
			else if(@TipProd=6)--para ActFijo
				set @Condicion = ' a.IB_AF=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod>'''+isnull(@Ult_Prod,'')+''''
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Consulta que almacena
			la consulta y se implementan las variables 
			@Tablas & @Condicion
			-----------------------------------------------------------------------------------------------*/
			declare @Consulta nvarchar(4000)
			set @Consulta = ' select top '+Convert(nvarchar,@TamPag)+' a.RucE,a.Cd_Prod,a.Nombre1,a.Nombre2,a.Descrip,a.NCorto,a.Cta1,a.Cta2,a.CodCo1_,a.CodCo2_,a.CodCo3_,
			a.CodBarras,a.FecCaducidad,case(isnull(len(convert(varbinary(255),a.img)),0)) when 0 then convert(bit, 0) else convert(bit,1) end as IB_Img,
			a.Img,a.StockMin,a.StockMax,a.StockAlerta,a.StockActual,a.StockCot,a.StockSol,a.Cd_TE,a.Cd_Mca,a.Cd_CL,a.Cd_CLS,a.Cd_CLSS, 
			a.Cd_CGP,a.UsuCrea,a.UsuMdf,a.FecReg,a.FecMdf,a.Estado,a.CA01,a.CA02,a.CA03,a.CA04,a.CA05,a.CA06,a.CA07,a.CA08,a.CA09,a.CA10,a.IB_Srs from '+@Tablas+'
			where '+ @Condicion+' order by a.RucE,a.Cd_Prod/*order by a.Cd_Aux,ApPat,ApMat,RSocial*/'
			Exec (@Consulta)
			print @Consulta
			print @Tablas
			print @Condicion

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Final 				Consulta de Producto2 General
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		if (@Ult_Prod='' or @Ult_Prod is null)
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
				-- @RucE,@Ejer, @CountOut=@Count OUTPUT (ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³ tb si se necesita enviar algo en la misma variable)
				--print 'Imprimimos count desde afuera: '*/
				declare @sql nvarchar(1000)
				set @sql= 'select @Regs = count(Cd_Prod) from '+@Tablas+ '  where ' + @Condicion
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
				
				set @sql = 'select @RMax = max(Cd_Prod) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Prod from '+@Tablas+' where '+@Condicion+' order by RucE,Cd_Prod/*ApPat, ApMat,RSocial*/) as Producto'
				exec sp_executesql @sql, N'@RMax nvarchar(7) output', @Max output

				set @sql = 'select top 1 @RMin =Cd_Prod from '+@Tablas+' where '+@Condicion+' order by RucE,Cd_Prod/*ApPat, ApMat,RSocial*/'
				exec sp_executesql @sql, N'@RMin nvarchar(7) output', @Min output
				/********************************************************************************************************************************************************/
				--				Fin : Faltaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				/********************************************************************************************************************************************************/

print @msj
---
/*
------------------------
Ejemplo de Prueba
------------------------

Declare @NroRegs int,@NroPags int,@Max nvarchar(7),@Min nvarchar(7)
exec dbo.Inv_Producto2_explo_PagSig '11111111111',90,'',@NroRegs out,@NroPags out,@Max out,@Min out,null  -- demora 0.00:01s
autor : J -> creado 11-10-2010 -> PAGINACION

MP : 22-02-2011 : <Modificacion del procedimiento almacenado>

*/










GO
