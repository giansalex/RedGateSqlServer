SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_VoucherCons_explo_PagAnt]
@RucE nvarchar(11),
@Eje nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Colum varchar(100),
@Dato varchar(100),
--------------------------------------
@TamPag int, --TamaÃ±o Pagina
@Ult_CdTsr int,
@Max int output,
@Min int output,
--------------------------------------
@msj varchar(100) output
as

	declare @Inter varchar(1000)

	--Interseccion
	set @Inter = 'Voucher vou
		left join Cliente2 c2 on c2.RucE=vou.RucE and c2.Cd_Clt=vou.Cd_Clt
		left join TipDoc td on vou.Cd_TD=td.Cd_TD	
		left join Area ar on vou.RucE=ar.RucE and vou.Cd_Area=ar.Cd_Area
		left join Modulo md on  vou.Cd_MR=md.Cd_MR
		left join TipGasto tg on  vou.Cd_TG=tg.Cd_TG
		left join Moneda moor on  vou.Cd_MdOr=moor.Cd_Mda
		left join Moneda morg on  vou.Cd_MdRg=morg.Cd_Mda
		left join PlanCtas pcta on vou.RucE=pcta.RucE and vou.NroCta=pcta.NroCta and pcta.Ejer=vou.Ejer
		inner join Banco ban on vou.RucE=ban.RucE and vou.NroCta=ban.NroCta and vou.Ejer=ban.Ejer'
	--Condicion
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	--Condicion	
	set @Cond = 'vou.RucE='''+@RucE+''' and vou.Ejer='''+@Eje+''' and vou.Prdo between '''+ @PrdoIni+''' and ''' +@PrdoFin +''' and vou.Cd_Fte=''CB'' and vou.Cd_Vou > '''+ Convert(nvarchar, isnull(@Ult_CdTsr,'')) +''''

	if(@Colum = 'RucE') set @Cond = @Cond+ ' and vou.RucE like '''+@Dato+''''
	else if(@Colum = 'Cd_Vou') set @Cond = @Cond+ ' and vou.Cd_Vou like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond =@Cond+ ' and vou.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Cd_Fte') set @Cond = @Cond+' and vou.Cd_Fte like '''+@Dato+''''
	else if(@Colum = 'NroCta') set @Cond = @Cond+' and vou.NroCta like '''+@Dato+''''
	else if(@Colum = 'NomCta') set @Cond = @Cond+' and pcta.NomCta like '''+@Dato+''''
	else if(@Colum = 'MtoD') set @Cond = @Cond+' and vou.MtoD like '''+@Dato+''''
	else if(@Colum = 'MtoH') set @Cond = @Cond+' and  vou.MtoH like '''+@Dato+''''
	else if(@Colum = 'MtoD_ME') set @Cond = @Cond+' and vou.MtoD_ME like '''+@Dato+''''
	else if(@Colum = 'MtoH_ME') set @Cond = @Cond+' and vou.MtoH_ME like '''+@Dato+''''
	else if(@Colum = 'Cd_MdRg') set @Cond = @Cond+' and vou.Cd_MdRg like '''+@Dato+''''
	else if(@Colum = 'SimMdRg') set @Cond = @Cond+' and morg.Simbolo like '''+@Dato+''''
	else if(@Colum = 'CamMda') set @Cond =@Cond+ ' and vou.CamMda like '''+@Dato+''''
	else if(@Colum = 'IC_TipAfec') set @Cond = @Cond+' and vou.IC_TipAfec like'''+@Dato+''''
	else if(@Colum = 'Ejer') set @Cond = @Cond+' and vou.Ejer like '''+@Dato+''''
	else if(@Colum = 'Prdo') set @Cond = @Cond+' and vou.Prdo like '''+@Dato+''''
	else if(@Colum = 'FecMov') set @Cond = @Cond+' and convert(varchar(10),vou.FecMov,103) like '''+@Dato+''''
	else if(@Colum = 'Glosa') set @Cond=@Cond +' and vou.Glosa like '''+@Dato+''''
	else if(@Colum = 'FecCbr') set @Cond=@Cond +' and convert(varchar(10),vou.FecCbr,103) like '''+@Dato+''''
	else if(@Colum = 'Cd_TDI') set @Cond=@Cond +' and c2.Cd_TDI like '''+@Dato+''''
	else if(@Colum = 'NDoc') set @Cond=@Cond +' and c2.NDoc like '''+@Dato+''''
	else if(@Colum = 'Cd_Aux') set @Cond=@Cond +' and vou.Cd_Clt like '''+@Dato+''''
	else if(@Colum = 'NomComCte') set @Cond=@Cond +' and case(isnull(len(c2.RSocial),0)) when 0 then c2.ApPat+'' ''+c2.ApMat+'' ''+c2.Nom else c2.RSocial end like '''+@Dato+''''
	else if(@Colum = 'Cd_TD') set @Cond=@Cond +' and vou.Cd_TD like '''+@Dato+''''
	else if(@Colum = 'DescripTD') set @Cond=@Cond +' and td.Descrip like '''+@Dato+''''
	else if(@Colum = 'NCortoTD') set @Cond=@Cond +' and td.NCorto like '''+@Dato+''''
	else if(@Colum = 'NroSre') set @Cond=@Cond +' and vou.NroSre like '''+@Dato+''''
	else if(@Colum = 'NroDoc') set @Cond=@Cond +' and vou.NroDoc like '''+@Dato+''''
	else if(@Colum = 'NroChke') set @Cond=@Cond +' and vou.NroChke like '''+@Dato+''''
	else if(@Colum = 'Grdo') set @Cond=@Cond +' and vou.Grdo like '''+@Dato+''''
	else if(@Colum = 'FecED') set @Cond=@Cond +' and convert(varchar(10),vou.FecED,103) like '''+@Dato+''''
	else if(@Colum = 'FecVD') set @Cond=@Cond +' and convert(varchar(10),vou.FecVD,103) like '''+@Dato+''''
	else if(@Colum = 'Cd_CC') set @Cond=@Cond +' and vou.Cd_CC like '''+@Dato+''''
	else if(@Colum = 'Cd_SC') set @Cond=@Cond +' and vou.Cd_SC, like '''+@Dato+''''
	else if(@Colum = 'Cd_SS') set @Cond=@Cond +' and vou.Cd_SS like '''+@Dato+''''
	else if(@Colum = 'Cd_Area') set @Cond=@Cond +' and vou.Cd_Area like '''+@Dato+''''
	else if(@Colum = 'NCortoArea') set @Cond=@Cond +' and ar.NCorto like '''+@Dato+''''
	else if(@Colum = 'Cd_MR') set @Cond=@Cond +' and vou.Cd_MR like '''+@Dato+''''
	else if(@Colum = 'NomMR') set @Cond=@Cond +' and md.Nombre like '''+@Dato+''''
	else if(@Colum = 'FecReg') set @Cond=@Cond +' and convert(varchar(10), vou.FecReg,103) like '''+@Dato+''''
	else if(@Colum = 'FecMdf') set @Cond=@Cond +' and convert(varchar(10), vou.FecMdf,103) like '''+@Dato+''''
	else if(@Colum = 'UsuCrea') set @Cond=@Cond +' and vou.UsuCrea like '''+@Dato+''''
	else if(@Colum = 'UsuModf') set @Cond=@Cond +' and vou.UsuModf like '''+@Dato+''''
	else if(@Colum = 'HoraReg') set @Cond=@Cond +' and convert(varchar,vou.FecReg,108) like '''+@Dato+''''
	else if(@Colum = 'UsuModf') set @Cond=@Cond +' and a.UsuModf like '''+@Dato+''''

	declare @Consulta nvarchar(4000)
	set @Consulta = '	select *from(select top '+ convert(nvarchar,@TamPag) +'
			vou.RucE,vou.Cd_Vou, vou.RegCtb,vou.Cd_Fte,vou.NroCta,pcta.NomCta, vou.MtoD,vou.MtoH, 
			vou.MtoD_ME,vou.MtoH_ME,vou.Cd_MdRg,morg.Simbolo as SimMdRg, vou.CamMda, 
			vou.IC_TipAfec,vou.IB_EsProv, vou.Ejer,vou.Prdo,convert(varchar(10),vou.FecMov,103) as FecMov, 
			vou.Glosa,convert(varchar(10),vou.FecCbr,103) as FecCbr,c2.Cd_TDI,c2.NDoc,vou.Cd_Clt as Cd_Aux, 
			case(isnull(len(c2.RSocial),0))	when 0 then c2.ApPat+'' ''+c2.ApMat+'' ''+c2.Nom else c2.RSocial end as NomComCte,
			vou.Cd_TD, td.Descrip as DescripTD, td.NCorto as NCortoTD,vou.NroSre, vou.NroDoc, vou.NroChke, vou.Grdo, 
			vou.IB_Conc, convert(varchar(10),vou.FecED,103) as FecED,convert(varchar(10),vou.FecVD,103) as FecVD, 
			vou.Cd_CC, vou.Cd_SC, vou.Cd_SS, vou.Cd_Area,ar.NCorto as NCortoArea, vou.Cd_MR, md.Nombre as NomMR, 	
			convert(varchar(10), vou.FecReg,103) as FecReg, convert(varchar(10), vou.FecMdf,103) as FecMdf,
			vou.UsuCrea, vou.UsuModf, convert(varchar,vou.FecReg,108) as HoraReg, vou.IB_Anulado
			from '+@inter+' 
			where '+@Cond+ ' order by vou.Cd_Vou desc)  as Voucher order by Cd_Vou' 
	
	if NOT  exists (select top 1 * from Voucher where RucE = @RucE and Ejer=@Eje)
			set @msj='No existe registros de Tesoreria'
	else
	  begin
		Exec (@Consulta)

		  set @sql = 'select top 1 @RMax = Cd_Vou from ' + @Inter + ' where ' +@Cond+' order by Cd_Vou desc'
		  exec sp_executesql @sql, N'@RMax int output', @Max output
		  if(@Max is null) set @Max = 0

		  set @sql = 'select @RMin = min(Cd_Vou) from(select top '+ Convert(nvarchar,@TamPag)+' Cd_Vou  from ' + @Inter + ' where ' + @Cond +' order by Cd_Vou desc) as  Voucher'
		  exec sp_executesql @sql, N'@RMin int output',@Min output
		  if(@Min is null) set @Min = 0

	  end
-- Leyenda --
-- JJ : 2010-09-29 	: <Creacion del procedimiento almacenado>
--MM : 10/12/10		: ModificaciÃ³n del sp (comprobacion de @Max y @Min)

GO
