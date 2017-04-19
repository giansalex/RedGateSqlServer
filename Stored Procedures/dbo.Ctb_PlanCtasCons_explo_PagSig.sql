SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasCons_explo_PagSig]
@RucE nvarchar(11),
@Ejer varchar(4),
@TamPag int, 	--TamaÃ±o Pagina
@Ult_NroCta nvarchar(10),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max nvarchar(10) output,
@Min nvarchar(10) output,
@msj varchar(100) output
as
	
		/*if(@TipCons=0)
			begin	
				select top 100
					RucE,NroCta,NomCta,Nivel,
					IB_Aux,	IB_CC,IB_DifC,IB_GCB,IB_Psp,IB_CtasXCbr,IB_CtasXPag,
					IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,
					Cd_Blc,Cd_EGPF,Cd_EGPN,
					IB_CtaD,IC_ASM,IC_ACV,Estado,Cd_Mda,IC_IEN,IC_IEF
				from PlanCtas 
					where RucE=@RucE
					and NroCta > @Ult_NroCta
					order by RucE, NroCta

					if (@Ult_NroCta='' or @Ult_NroCta is null)
						begin
							select @NroRegs  = count(NroCta) from PlanCtas where RucE=@RucE
							select @NroPags = @NroRegs/100 + 1
							print  @NroRegs	
							print  @NroPags
						end

			select @Max = max(NroCta) from (select top 100 NroCta  from PlanCtas where RucE=@RucE and NroCta > @Ult_NroCta order by RucE, NroCta) as NroCtaX
	

			set @Min = (select top 1 NroCta  from PlanCtas where RucE=@RucE and NroCta > @Ult_NroCta order by RucE, NroCta )
			end*/
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Inicio 				Consulta de Plan de Cuentas General
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Tablas que almacena
			las tablas que se intersectarÃ¡n en la consulta
			-----------------------------------------------------------------------------------------------*/
			declare @Tablas varchar(1000)
			set @Tablas = ' PlanCtas'
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Condicion que almacena
			la condiciÃ³n de la sentencia Where de la consulta
			que se realizarÃ¡
			-----------------------------------------------------------------------------------------------*/
			declare @Condicion varchar(1000)
			set @Condicion = 'RucE= '''+@RucE+'''and Ejer= '''+@Ejer+''' and NroCta>'''+isnull(@Ult_NroCta,'')+''''
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Consulta que almacena
			la consulta y se implementan las variables 
			@Tablas & @Condicion
			-----------------------------------------------------------------------------------------------*/
			declare @Consulta nvarchar(4000)
			set @Consulta = '	select top '+Convert(nvarchar,@TamPag)+
			' RucE,Ejer,NroCta,NomCta,NroCtaH1,NomCtaH1,NroCtaH2,NomCtaH2,Nivel,IB_Aux,isnull(IB_NDoc,0) As IB_NDoc,
	  		IB_CC,IB_DifC,IB_GCB,IB_Psp,IB_CtasXCbr,IB_CtasXPag,
	  		IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,
	  		Cd_Blc,IC_IEF,Cd_EGPF,IC_IEN,Cd_EGPN,
	  		IB_CtaD,case(IC_ASM) when ''S'' then 1 else 0 end as IC_ASM, IC_ACV,Estado,isnull(IB_Prod,0) as IB_Prod,Cd_Mda,isnull(IB_Imp,0) as IB_Imp,isnull(IB_Dtr,0) as IB_Dtr, 
	  		isnull(IB_IGV,0) as IB_IGV,isnull(IB_MCC,0) as IB_MCC,isnull(IB_MCE,0) as IB_MCE, isnull(IB_Perc,0) as IB_Perc, isnull(IB_Ret,0) as IB_Ret 
	  		from  '+@Tablas+'
			where '+ @Condicion+' order by NroCta/*order by a.RucE, a.Cd_Aux,ApPat,ApMat,RSocial*/'
			
			Exec (@Consulta)
			print @Consulta	

			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Final 				Consulta de Plan de Cuentas General
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		if (@Ult_NroCta='' or @Ult_NroCta is null)
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
				set @sql= 'select @Regs = count(NroCta) from '+@Tablas+ '  where ' + @Condicion
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
				
				set @sql = 'select @RMax = max(NroCta) from(select top '+Convert(nvarchar,@TamPag)+' NroCta from '+@Tablas+' where '+@Condicion+' order by NroCta/*ApPat, ApMat,RSocial*/) as NroCta'
				exec sp_executesql @sql, N'@RMax nvarchar(10) output', @Max output

				set @sql = 'select top 1 @RMin =NroCta from '+@Tablas+' where '+@Condicion+' order by NroCta/*ApPat, ApMat,RSocial*/'
				exec sp_executesql @sql, N'@RMin nvarchar(10) output', @Min output
				/********************************************************************************************************************************************************/
				--				Fin : Faltaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				/********************************************************************************************************************************************************/	


print @msj
print @Max
print @Min

/*   0: General: select * from Tabla
     1: ComboBox: select CodNom, Cd_Entidad from Tabla where Estado=1
     2: Activos: select * from Tabla where Estado=1
     3: Ayuda: select Cd_Ent,NroDoc,Nombre from Tabla
*/


----------------------LEYENDA----------------------
--J : Mar 12-10-2010 <creacion>
----------------------PRUEBA------------------------
--select * from PlanCtas Where RucE='11111111111' and Ejer='2010'
--Declare @NroRegs int,@NroPags int,@Max nvarchar(10),@Min nvarchar(10)
--exec dbo.Ctb_PlanCtasCons_explo_PagSig '11111111111','2010',500,'',@NroRegs out,@NroPags out,@Max out,@Min out,null
--CE: 28/01/2013 <Se agrego IB_MCE - IB_MCC >
--bg : 01/03/2013 <Se modifico sp todos los ultimos ib desde IB_Prod>
--CE: 12/03/2013 <Se agrego IB_Perc - IB_ret>
GO
