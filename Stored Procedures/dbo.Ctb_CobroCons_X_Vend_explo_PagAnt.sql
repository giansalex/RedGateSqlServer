SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Ctb_CobroCons_X_Vend_explo_PagAnt]

@RucE nvarchar(11),
@Ejer varchar(4),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --Tamaño Pagina
@Ult_CdVta char(10),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(10) output,
@Min char(10) output,
----------------------
@msj varchar(100) output
as
	declare @Inter varchar(4000)
	set @Inter = 	'(select vou.RucE, vou.Cd_Vou, vou.Ejer, vou.Prdo, vou.NroDoc, vou.NroCta, vou.RegCtb, vou.FecMov, vou.Cd_TD, vou.MtoD, vou.MtoH
 			from voucher as vou where vou.RucE =@RucEE and vou.Cd_Fte = ''CB'' and vou.FecMov between @FecDD and @FecHH) as vo,
			(select RucE, NroCta, IB_CtasXCbr from PlanCtas where RucE = @RucEE and IB_CtasXCbr = 1 and Ejer=@EEjer) as plc, 
			(select RucE, Cd_Vta, Cd_Vdr, NroDoc,Cd_TD from Venta where RucE = @RucEE) as ve,
			(select RucE, Cd_Aux, case(isnull(len(RSocial),0)) when 0 then ApPat +'' ''+ ApMat +'',''+ Nom else RSocial end as Nomb from Auxiliar) as ax'
	declare @Cond varchar(4000)
	declare @sql nvarchar(4000)
	set @Cond = '(plc.RucE = vo.RucE and vo.NroCta = plc.NroCta)
			and (ve.RucE = vo.RucE and vo.NroDoc = ve.NroDoc and vo.Cd_TD = ve.Cd_TD )
			and (ax.RucE = ve.RucE and ve.Cd_Vdr = ax.Cd_Aux) and ve.Cd_Vta<'''+isnull(@Ult_CdVta,'')+''''
	if(@Colum = 'Cd_Vou') set @Cond = @Cond+ ' and vo.Cd_Vou like '''+@Dato+''''
	else if(@Colum = 'Ejer') set @Cond = @Cond+ ' and vo.Ejer like '''+@Dato+''''
	else if(@Colum = 'Prdo') set @Cond =@Cond+ ' and vo.Prdo like '''+@Dato+''''
	else if(@Colum = 'NroDoc') set @Cond = @Cond+' and vo.NroDoc like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+' and vo.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Cd_Vta') set @Cond = @Cond+' and ve.Cd_Vta like '''+@Dato+''''
	else if(@Colum = 'FecMov') set @Cond = @Cond+' and Convert(nvarchar,vo.FecMov,103) like '''+@Dato+''''
	else if(@Colum = 'Cd_Vdr') set @Cond = @Cond+' and ve.Cd_Vdr like '''+@Dato+''''
	else if(@Colum = 'Nomb') set @Cond = @Cond+' and ax.Nomb  like '''+@Dato+''''
	else if(@Colum = 'NroCta') set @Cond = @Cond+' and vo.NroCta like '''+@Dato+''''
	else if(@Colum = 'MtoD') set @Cond =@Cond+ ' and vo.MtoD like '''+@Dato+''''
	else if(@Colum = 'MtoH') set @Cond = @Cond+' and vo.MtoH like'''+@Dato+''''

	declare @Consulta varchar(8000)
	set @Consulta = 'declare @RucEE nvarchar(11)
			 declare @FecDD datetime
			 declare @FecHH datetime
			declare @EEjer varchar(4)
			 set @EEjer = '''+ @Ejer +'''
			 set @RucEE = '''+ @RucE +'''
			 set @FecDD = '''+ Convert(nvarchar,@FecD,103) +'''
			 set @FecHH = '''+ Convert(nvarchar,@FecH,103) +'''
			select * from (select top '+Convert(nvarchar,@TamPag)+' vo.Cd_Vou, 
			vo.Ejer, 
			vo.Prdo, 
			vo.NroDoc, 
			vo.RegCtb, 
			ve.Cd_Vta, 
			Convert(nvarchar,vo.FecMov,103) as FecMov, 
			ve.Cd_Vdr, 
			ax.Nomb,
			vo.NroCta, 
			vo.MtoD, 
			vo.MtoH
			from '+@Inter+' 
			where '+ @Cond+' 
			order by ve.Cd_Vta desc) as Venta order by Cd_Vta'

	exec (@Consulta)
	

	print @Consulta
	--print @Cond
	--print @Inter
	

	set @sql = 'declare @RucEE nvarchar(11)
			 declare @FecDD datetime
			 declare @FecHH datetime
			 declare @EEjer varchar(4)
			 set @EEjer = '''+ @Ejer +'''
			 set @RucEE = '''+ @RucE +'''
			 set @FecDD = '''+ Convert(nvarchar,@FecD,103) +'''
			 set @FecHH = '''+ Convert(nvarchar,@FecH,103) +'''
		    select top 1 @RMax =Cd_Vta from '+@Inter+' where  '+@Cond+' order by Cd_Vta desc'
	exec sp_executesql @sql, N'@RMax char(10) output', @Max output
	--print @sql
	set @sql = 'declare @RucEE nvarchar(11)
			 declare @FecDD datetime
			 declare @FecHH datetime
			 declare @EEjer varchar(4)
			 set @EEjer = '''+ @Ejer +'''
			 set @RucEE = '''+ @RucE +'''
			 set @FecDD = '''+ Convert(nvarchar,@FecD,103) +'''
			 set @FecHH = '''+ Convert(nvarchar,@FecH,103) +'''
		    select @RMin = min(Cd_Vta) from(select top '+Convert(nvarchar,@TamPag)+' ve.Cd_Vta from '+@Inter+' where  '+@Cond+' order by ve.Cd_Vta desc) as Venta'
	exec sp_executesql @sql, N'@RMin char(10) output', @Min output
	--print @sql
----------------------PRUEBA------------------------
--

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
--FL: 17/09/2010 <se agrego ejercicio>
GO
