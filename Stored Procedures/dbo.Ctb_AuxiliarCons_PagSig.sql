SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AuxiliarCons_PagSig]
@RucE nvarchar(11),
@TipCons int,
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inicio 		  		--Variables que se usaran para la paginación
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@TamPag int, 	          		--Tamaño Pagina
@Ult_Aux nvarchar(7),
@NroRegs int output,      	--Nro de Registros solo es consultado la primera vez
@NroPags int output,      	--Nro de Paginas solo es consultado la primera vez
@Max nvarchar(7) output,	--Codigo del Auxiliar máximo que es consultado dentro del top
@Min nvarchar(7) output, 	--Codigo del Auxiliar mínimo que es consultado dentro del top
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Final 				-- Variables que se usaran para la paginación
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
@msj varchar(100) output
as
begin
	if(@TipCons=0)
	    begin
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
			las tablas que se intersectarán en la consulta
			-----------------------------------------------------------------------------------------------*/
			declare @Tablas varchar(1000)
			set @Tablas = ' Auxiliar a
			left join TipDocIdn b on a.Cd_TDI=b.Cd_TDI
			left join TipAux c on a.Cd_TA=c.Cd_TA'
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Condicion que almacena
			la condición de la sentencia Where de la consulta
			que se realizará
			-----------------------------------------------------------------------------------------------*/
			declare @Condicion varchar(1000)
			set @Condicion = 'a.RucE= '''+@RucE+'''and a.Cd_Aux>'''+isnull(@Ult_Aux,'')+''''
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Consulta que almacena
			la consulta y se implementan las variables 
			@Tablas & @Condicion
			-----------------------------------------------------------------------------------------------*/
			declare @Consulta nvarchar(4000)
			set @Consulta = '	select top '+Convert(nvarchar,@TamPag)+'
			 a.RucE,a.Cd_Aux,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
			a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,
			a.PWeb,a.Cd_TA,c.Nombre as NomTipAux,a.Estado
			from '+@Tablas+'
			where '+ @Condicion+' order by a.RucE, a.Cd_Aux/*order by a.RucE, a.Cd_Aux,ApPat,ApMat,RSocial*/'
			Exec (@Consulta)
			--print @Consulta

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Final 				Consulta de Auxiliares General
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		if (@Ult_Aux='' or @Ult_Aux is null)
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
				-- @RucE,@Ejer, @CountOut=@Count OUTPUT (ó tb si se necesita enviar algo en la misma variable)
				--print 'Imprimimos count desde afuera: '*/
				declare @sql nvarchar(1000)
				set @sql= 'select @Regs = count(Cd_Aux) from '+@Tablas+ '  where ' + @Condicion
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
				
				set @sql = 'select @RMax = max(Cd_Aux) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Aux from '+@Tablas+' where '+@Condicion+' order by RucE,Cd_Aux/*ApPat, ApMat,RSocial*/) as Auxiliar'
				exec sp_executesql @sql, N'@RMax nvarchar(7) output', @Max output

				set @sql = 'select top 1 @RMin =Cd_Aux from '+@Tablas+' where '+@Condicion+' order by RucE,Cd_Aux/*ApPat, ApMat,RSocial*/'
				exec sp_executesql @sql, N'@RMin nvarchar(7) output', @Min output
				/********************************************************************************************************************************************************/
				--				Fin : Faltaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				/********************************************************************************************************************************************************/
 
	    end
	else if (@TipCons=1) 
	    begin
		select case(isnull(len(a.RSocial),0))
	                     when 0 then a.NDoc+'  |  '+a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.NDoc+'  |  '+a.RSocial end as CodNom,
		       a.Cd_Aux as Cd_Aux
		       from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Estado=1
	    end
	else if (@TipCons=2)
	    begin
		select a.RucE,a.Cd_Aux as Cd_Cte,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Estado
                       from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Estado=1
	    end
	else if (@TipCons=3)
	   begin
	   	select a.Cd_Aux,
		       a.NDoc,
		       case(isnull(len(a.RSocial),0))
	                     when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.RSocial end as Nombre
		       from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI
	   end
end
print @msj
---
/*
------------------------
Ejemplo de Prueba
------------------------
exec dbo.Ctb_AuxiliarCons_PagSig '11111111111',0,100,'',1456,15,'CLT0082','AUX0001',null
autor : J -> Modificado 03-05-2010 -> PAGINACION
*/
/*
------------------------
Ejemplo de Prueba con data masiva
------------------------
exec dbo.Ctb_AuxiliarCons_PagSig '20520727192',0,90000,'',1456,15,'CLT0082','AUX0001',null  -- demora 0.00:01s
autor : J -> Modificado 21-05-2010 -> PAGINACION
*/
GO
