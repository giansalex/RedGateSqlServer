SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasCons3_PagAnt]
@RucE nvarchar(11),
@Ejer varchar(4),
@TipCons int,
@TamPag int,
@Ult_NroCta nvarchar(10),
@Max nvarchar(10) output,
@Min nvarchar(10) output,
@msj varchar(100) output
as

begin
	if(@TipCons=0)
	begin	
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
	' select *from (select top '+Convert(nvarchar,@TamPag)+
	' RucE,NroCta,NomCta,Nivel,
	  IB_Aux,IB_CC,IB_DifC,IB_GCB,IB_Psp,IB_CtasXCbr,IB_CtasXPag,
	  IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,
	  Cd_Blc,Cd_EGPF,Cd_EGPN,
	  IB_CtaD,IC_ASM,IC_ACV,Estado,Cd_Mda,IC_IEN,IC_IEF from '+@Inter+' 
	  where '+@Cond+'order by NroCta desc) as NroCta order by NroCta'
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> consulta asientos pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> obtenemos el registro mÃ¡ximo & mÃ­nimo de asientos //ordenado por : nrocta
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	set @sql = 'select top 1 @RMax =NroCta from '+@Inter+' where  '+@Cond+' order by NroCta/*ApPat,ApMat,RSocial*/ desc'--ver orden por ApPat,ApMat,RSocial
	exec sp_executesql @sql, N'@RMax nvarchar(10) output', @Max output

	set @sql = 'select @RMin = min(NroCta) from(select top '+Convert(nvarchar,@TamPag)+'NroCta from '+@Inter+' where  '+@Cond+' order by NroCta/*ApPat,ApMat,RSocial*/ desc) as NroCta'
	exec sp_executesql @sql, N'@RMin nvarchar(10) output', @Min output
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> obtenemos el registro mÃ¡ximo & mÃ­nimo de asientos //ordenado por : nrocta
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Exec (@Consulta) -- Ejecutamos la consulta 			
	--print @Max
	--print @Min
	--print @sql		
	
	end
	
	else if(@TipCons=1)
	begin
		select str(NroCta,6,0)+ ' | ' + NomCta as CodNom,NroCta,NomCta  from PlanCtas where RucE=@RucE and Ejer=@Ejer
	end
	
	else if(@TipCons=3)
	begin
		select NroCta,NroCta,NomCta from PlanCtas where RucE=@RucE and Estado=1 and Ejer=@Ejer
	end


end
print @msj
print @Max
print @Min

/*
     0: General: select * from Tabla
     1: ComboBox: select CodNom, Cd_Entidad from Tabla where Estado=1
     2: Activos: select * from Tabla where Estado=1
     3: Ayuda: select Cd_Ent,NroDoc,Nombre from Tabla
*/
----------------------PRUEBA------------------------
--exec dbo.Ctb_PlanCtasCons3_PagAnt '11111111111','2009','',200,'14.1.0.06',200,200,null

------CODIGO DE MODIFICACION--------
--CM=RE01

--PV: Jue 29/01/09
--PV: Jue 02/02/09
--J : Jue 17/12/09 -> Se agrego el campo Cd_Mda
--J : Jue 29/04/10 -> PAGINACION
-- FL: VIE 17/09/2010 <se agrego ejercicio>

GO
