SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasCons_explo_PagAnt]
@RucE nvarchar(11),
@Ejer varchar(4),
@TamPag int,
@Ult_NroCta nvarchar(10),
@Max nvarchar(10) output,
@Min nvarchar(10) output,
@msj varchar(100) output
as

		/*
		select top 100
			RucE,NroCta,NomCta,Nivel,
			IB_Aux,	IB_CC,IB_DifC,IB_GCB,IB_Psp,IB_CtasXCbr,IB_CtasXPag,
			IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,
			Cd_Blc,Cd_EGPF,Cd_EGPN,
			IB_CtaD,IC_ASM,IC_ACV,Estado,Cd_Mda,IC_IEN,IC_IEF
		from PlanCtas 
		where 	
			RucE=@RucE and NroCta < @Ult_NroCta
		order by 
			RucE desc, NroCta desc

		select @Min = 
			min(NroCta)from (select top 100 NroCta  from PlanCtas 
			where RucE=@RucE and NroCta < @Ult_NroCta 
			order by RucE desc, NroCta desc) as NroCtaX
		--De Segundo Metodo 
		set @Max = (select top 1 NroCta  from PlanCtas where RucE=@RucE and NroCta < @Ult_NroCta order by RucE desc, NroCta desc)
		*/

	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> consulta de asientos pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	declare @Inter varchar(1000)
	set @Inter = 'PlanCtas'
	declare @sql nvarchar(1000)
	declare @Cond varchar(1000)
	set @Cond = 'RucE= '''+@RucE+'''and Ejer= '''+@Ejer+''' and NroCta<'''+isnull(@Ult_NroCta,'')+''''	
	
	declare @Consulta nvarchar(4000)
	set @Consulta = 
	'select *from (select top '+Convert(nvarchar,@TamPag)+
	' RucE,Ejer,NroCta,NomCta,NroCtaH1,NomCtaH1,NroCtaH2,NomCtaH2,Nivel,IB_Aux,isnull(IB_NDoc,0) As IB_NDoc,
	  		IB_CC,IB_DifC,IB_GCB,IB_Psp,IB_CtasXCbr,IB_CtasXPag,
	  		IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,
	  		Cd_Blc,IC_IEF,Cd_EGPF,IC_IEN,Cd_EGPN,
	  		IB_CtaD,case(IC_ASM) when ''S'' then 1 else 0 end as IC_ASM, IC_ACV,Estado,isnull(IB_Prod,0) as IB_Prod,Cd_Mda,isnull(IB_Imp,0) as IB_Imp,isnull(IB_Dtr,0) as IB_Dtr, 
	  		isnull(IB_IGV,0) as IB_IGV,isnull(IB_MCC,0) as IB_MCC,isnull(IB_MCE,0) as IB_MCE, isnull(IB_Perc,0) as IB_Perc, isnull(IB_Ret,0) as IB_Ret from '+@Inter+' 
	  where '+@Cond+'order by NroCta desc) as NroCta order by NroCta'
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> consulta asientos pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> obtenemos el registro mÃƒÂ¡ximo & mÃƒÂ­nimo de asientos //ordenado por : nrocta
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	set @sql = 'select top 1 @RMax =NroCta from '+@Inter+' where  '+@Cond+' order by NroCta/*ApPat,ApMat,RSocial*/ desc'--ver orden por ApPat,ApMat,RSocial
	exec sp_executesql @sql, N'@RMax nvarchar(10) output', @Max output

	set @sql = 'select @RMin = min(NroCta) from(select top '+Convert(nvarchar,@TamPag)+'NroCta from '+@Inter+' where  '+@Cond+' order by NroCta/*ApPat,ApMat,RSocial*/ desc) as NroCta'
	exec sp_executesql @sql, N'@RMin nvarchar(10) output', @Min output
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> obtenemos el registro mÃƒÂ¡ximo & mÃƒÂ­nimo de asientos //ordenado por : nrocta
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Exec (@Consulta) -- Ejecutamos la consulta 			
	--print @Max
	--print @Min
	--print @sql		
	
print @msj
print @Max
print @Min

/*
     0: General: select * from Tabla
     1: ComboBox: select CodNom, Cd_Entidad from Tabla where Estado=1
     2: Activos: select * from Tabla where Estado=1
     3: Ayuda: select Cd_Ent,NroDoc,Nombre from Tabla
*/

----------------------LEYENDA----------------------
--J : Mar 12-10-2010 <creacion>
----------------------PRUEBA------------------------
--select * from PlanCtas Where RucE='11111111111' and Ejer='2010'
--Declare @Max nvarchar(10),@Min nvarchar(10)
--exec dbo.Ctb_PlanCtasCons_explo_PagAnt '11111111111','2010',50,'9999999999',@Max out,@Min out,null
--CE: 28/01/2013 <Se agrego IB_MCE - IB_MCC >
--bg : 01/03/2013 <Se modifico sp todos los ultimos ib desde IB_Prod>
--CE: 12/03/2013 <Se agrego IB_Perc - IB_ret>
GO
