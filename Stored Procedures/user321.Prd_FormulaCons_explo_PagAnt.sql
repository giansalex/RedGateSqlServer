SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_FormulaCons_explo_PagAnt]
@RucE nvarchar(11),
@TamPag int,
@Ult_NroFor char(7),
@Max char(7) output,
@Min char(7) output,
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
	--declare @Inter varchar(1000)
	--set @Inter = 'Formula f'
	declare @sql nvarchar(1000)
	declare @Cond varchar(1000)
	set @Cond = 'f.RucE= '''+@RucE+''' and f.Cd_Prod<'''+convert(nvarchar,isnull(@Ult_NroFor,''))+''''	
	
	declare @Consulta nvarchar(4000)
	set @Consulta = 
	'select * from (select top '+Convert(nvarchar,@TamPag)+
	' f.RucE,f.Cd_Prod, f.Nombre1, f.Descrip from user321.ProdXFormula f
			 where '+ @Cond+' 
			 order by f.Cd_Prod desc) as Cd_Prod order by Cd_Prod'
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> consulta asientos pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> obtenemos el registro mÃƒÆ’Ã‚Â¡ximo & mÃƒÆ’Ã‚Â­nimo de asientos //ordenado por : nrocta
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	set @sql = 'select top 1 @RMax =f.Cd_Prod from user321.ProdXFormula f where  '+@Cond+' order by f.Cd_Prod desc'--ver orden por ApPat,ApMat,RSocial
	exec sp_executesql @sql, N'@RMax char(7) output', @Max output

	set @sql = 'select @RMin = min(Cd_Prod) from(select top '+Convert(nvarchar,@TamPag)+'f.Cd_Prod from user321.ProdXFormula f where  '+@Cond+' order by f.Cd_Prod) as Cd_Prod'
	exec sp_executesql @sql, N'@RMin char(7) output', @Min output
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> obtenemos el registro mÃƒÆ’Ã‚Â¡ximo & mÃƒÆ’Ã‚Â­nimo de asientos //ordenado por : nrocta
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
--FL : Mar 10-02-2011 <creacion del procedimiento almacenado>
GO
