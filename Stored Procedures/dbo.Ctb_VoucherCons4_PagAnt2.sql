SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherCons4_PagAnt2]
@RucE nvarchar(11),
@Eje nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Colum varchar(100),
@Dato varchar(100),
------------------------------------------
@TamPag int, --Tamano Pagina
@Ult_CdVou int,
@Max int output,
@Min int output,
------------------------------------------
@msj varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL off --Para que se pueda concatenar NULLs --PV 

	declare @Inter varchar (1000)
	declare @sql nvarchar(1000)
	declare @cond nvarchar(1000)
	declare @Consulta  nvarchar(4000)
	declare @Consulta2  nvarchar(4000)
	set @Inter = 'Voucher vou
		left join Auxiliar au on vou.RucE=au.RucE and vou.Cd_Aux=au.Cd_Aux
		left join TipDoc td on vou.Cd_TD=td.Cd_TD	
		left join Area ar on vou.RucE=ar.RucE and vou.Cd_Area=ar.Cd_Area
		left join Modulo md on  vou.Cd_MR=md.Cd_MR
		left join TipGasto tg on  vou.Cd_TG=tg.Cd_TG
		left join Moneda moor on  vou.Cd_MdOr=moor.Cd_Mda
		left join Moneda morg on  vou.Cd_MdRg=morg.Cd_Mda
		left join PlanCtas pcta on vou.RucE=pcta.RucE and vou.NroCta=pcta.NroCta and pcta.Ejer=vou.Ejer'
	set @cond ='vou.RucE='''+@RucE+''' and vou.Ejer='''+@Eje+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and Cd_Vou < '+Convert(nvarchar, isnull(@Ult_CdVou,''))+' '
	if(@Colum = 'Cd_Vou') set @Cond = @Cond+ ' and vou.Cd_Vou like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+ ' and vou.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Cd_Fte') set @Cond = @Cond+ ' and vou.Cd_Fte like '''+@Dato+''''
	else if(@Colum = 'NroCta') set @Cond = @Cond+ ' and vou.NroCta like '''+@Dato+''''
	else if(@Colum = 'NomCta') set @Cond = @Cond+ ' and pcta.NomCta like '''+@Dato+''''
	else if(@Colum = 'MtoD') set @Cond = @Cond+ ' and Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoD end like '''+@Dato+''''
	else if(@Colum = 'MtoH') set @Cond = @Cond+ ' and Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoH end like '''+@Dato+''''
	else if(@Colum = 'MtoD_ME') set @Cond = @Cond+ ' and Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoD_ME end like '''+@Dato+''''
	else if(@Colum = 'MtoH_ME') set @Cond = @Cond+ ' and Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoH_ME end like '''+@Dato+''''
	else if(@Colum = 'Cd_MdRg') set @Cond = @Cond+ ' and vou.Cd_MdRg like '''+@Dato+''''
	else if(@Colum = 'Simbolo') set @Cond = @Cond+ ' and morg.Simbolo like '''+@Dato+''''
	else if(@Colum = 'CamMda') set @Cond = @Cond+ ' and vou.CamMda like '''+@Dato+''''
	else if(@Colum = 'IC_TipAfec') set @Cond = @Cond+ ' and vou.IC_TipAfec like '''+@Dato+''''
	else if(@Colum = 'IB_EsProv') set @Cond = @Cond+ ' and vou.IB_EsProv like '''+@Dato+''''
	else if(@Colum = 'Ejer') set @Cond = @Cond+ ' and vou.Ejer like '''+@Dato+''''
	else if(@Colum = 'Prdo') set @Cond = @Cond+ ' and vou.Prdo like '''+@Dato+''''
	else if(@Colum = 'FecMov') set @Cond = @Cond+ ' and convert(varchar(10),vou.FecMov,103) like '''+@Dato+''''
	else if(@Colum = 'Glosa') set @Cond = @Cond+ ' and vou.Glosa like '''+@Dato+''''
	else if(@Colum = 'FecCbr') set @Cond = @Cond+ ' and convert(varchar(10),vou.FecCbr,103) like '''+@Dato+''''
	else if(@Colum = 'Cd_TDI') set @Cond = @Cond+ ' and au.Cd_TDI like '''+@Dato+''''
	else if(@Colum = 'NDoc') set @Cond = @Cond+ ' and au.NDoc like '''+@Dato+''''
	else if(@Colum = 'Cd_Aux') set @Cond = @Cond+ ' and vou.Cd_Aux like '''+@Dato+''''
	else if(@Colum = 'NomComCte') set @Cond = @Cond+ ' and case(isnull(len(au.RSocial),0)) when 0 then au.ApPat+'' ''+au.ApMat+'' ''+au.Nom else au.RSocial end like '''+@Dato+''''
	else if(@Colum = 'Cd_TD') set @Cond = @Cond+ ' and vou.Cd_TD like '''+@Dato+''''
	else if(@Colum = 'DescripTD') set @Cond = @Cond+ ' and td.Descrip like '''+@Dato+''''
	else if(@Colum = 'NCortoTD') set @Cond = @Cond+ ' and td.NCorto like '''+@Dato+''''
	else if(@Colum = 'NroSre') set @Cond = @Cond+ ' and vou.NroSre like '''+@Dato+''''
	else if(@Colum = 'NroDoc') set @Cond = @Cond+ ' and vou.NroDoc like '''+@Dato+''''
	else if(@Colum = 'NroChke') set @Cond = @Cond+ ' and vou.NroChke like '''+@Dato+''''
	else if(@Colum = 'Grdo') set @Cond = @Cond+ ' and vou.Grdo like '''+@Dato+''''
	else if(@Colum = 'vou.IB_Conc') set @Cond = @Cond+ ' and vou.IB_Conc like '''+@Dato+''''
	else if(@Colum = 'FecED') set @Cond = @Cond+ ' and convert(varchar(10),vou.FecED,103) like '''+@Dato+''''
	else if(@Colum = 'FecVD') set @Cond = @Cond+ ' and convert(varchar(10),vou.FecVD,103) like '''+@Dato+''''
	else if(@Colum = 'Cd_CC') set @Cond = @Cond+ ' and vou.Cd_CC like '''+@Dato+''''
	else if(@Colum = 'Cd_SC') set @Cond = @Cond+ ' and vou.Cd_SC like '''+@Dato+''''
	else if(@Colum = 'Cd_SS') set @Cond = @Cond+ ' and vou.Cd_SS like '''+@Dato+''''
	else if(@Colum = 'Cd_Area') set @Cond = @Cond+ ' and vou.Cd_Area like '''+@Dato+''''
	else if(@Colum = 'NCortoArea') set @Cond = @Cond+ ' and ar.NCorto like '''+@Dato+''''
	else if(@Colum = 'Cd_MR') set @Cond = @Cond+ ' and vou.Cd_MR like '''+@Dato+''''
	else if(@Colum = 'NomMR') set @Cond = @Cond+ ' and md.Nombre like '''+@Dato+''''
	else if(@Colum = 'FecReg') set @Cond = @Cond+ ' and convert(varchar(10), vou.FecReg,103) like '''+@Dato+''''
	else if(@Colum = 'FecMdf') set @Cond = @Cond+ ' and convert(varchar(10), vou.FecMdf,103) like '''+@Dato+''''
	else if(@Colum = 'HoraReg') set @Cond = @Cond+ ' and convert(varchar,vou.FecReg,108) like '''+@Dato+''''
	else if(@Colum = 'IB_Anulado') set @Cond = @Cond+ ' and vou.IB_Anulado like '''+@Dato+''''
	else if(@Colum = 'DR_NSre') set @Cond = @Cond+ ' and vou.DR_NSre like '''+@Dato+''''
	else if(@Colum = 'DR_NDoc') set @Cond = @Cond+ ' and vou.DR_NDoc like '''+@Dato+''''
	else if(@Colum = 'DR_NroDet') set @Cond = @Cond+ ' and vou.DR_NroDet like '''+@Dato+''''
	else if(@Colum = 'DR_FecDet') set @Cond = @Cond+ ' and vou.DR_FecDet like '''+@Dato+''''
	else if(@Colum = 'CtrMdaDetalle') 
	begin
		if(@Dato like '%Ambos%') set @Dato = '%a%'
		else if(@Dato like '%Soles%') set @Dato = '%s%'
		else if(@Dato like '%Dolares%') set @Dato = '%$%'

		set @Cond = @Cond+ ' and vou.IC_CtrMd like '''+@Dato+''''
	end
	set @Consulta ='select * from (select top '+Convert(nvarchar, @TamPag)+'
	vou.RucE, --Ruc de la empresa
	vou.Cd_Vou, --Codigo del voucher
	vou.RegCtb, --Registro Contable
	vou.Cd_Fte, --Codigo Fuente
	vou.NroCta, --Numero Cuenta
	pcta.NomCta, -- Nombre de la cuenta
	Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoD end as MtoD, --Monto Debe
	Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoH end as MtoH, --Monto Haber
	Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoD_ME end as MtoD_ME, --Monto Debe Moneda Extranjera
	Case(vou.IB_Anulado) when 1 then 0.00 else vou.MtoH_ME end as MtoH_ME, --Monto Haber Moneda Extranjera
	vou.Cd_MdRg, --Codigo Moneda Registro
	morg.Simbolo as SimMdRg, --Simbolo de la moneda
	vou.CamMda, --Tipo de cambio 
	vou.IC_CtrMd, 
	case(IC_CtrMd) when ''a'' then ''Ambos'' else 
	(case(IC_CtrMd) when ''s'' then ''Soles'' else 
	(case(IC_CtrMd) when ''$'' then ''DÃ³lares'' else '''' end) end) end as ''CtrMdaDetalle'', 
	vou.IC_TipAfec, --Indicador Tipo Afecto
	case vou.IB_EsProv when 1 then convert(bit,1) else convert(bit,0) end as IB_EsProv, --Indicador si es provicion
	vou.Ejer, --Ejericio o aÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â±o de registro
	vou.Prdo, --Periodo de registro
	convert(varchar(10),vou.FecMov,103) as FecMov, --Fecha de movimiento del registro
	vou.Glosa, --Glosa
	convert(varchar(10),vou.FecCbr,103) as FecCbr, --Fecha de Cobro
	au.Cd_TDI,au.NDoc,vou.Cd_Aux,case(isnull(len(au.RSocial),0))
		when 0 then au.ApPat+'' ''+au.ApMat+'' ''+au.Nom
			else au.RSocial end as NomComCte, --Datos del cliente
	vou.Cd_TD, --Codigo tipo de documento
	td.Descrip as DescripTD, --Descripcion del tipo de documento
	td.NCorto as NCortoTD, --Descripcion corta del tipo de documento
	vou.NroSre, --Numero de serie
	vou.NroDoc, --Numero de documento
	vou.NroChke, --Numero de Cheque
	vou.Grdo, --Girado
	case vou.IB_Conc when 1 then convert(bit,1) else convert(bit,0) end as IB_Conc, -- Indicador booleano conciliado
	convert(varchar(10),vou.FecED,103) as FecED, --Fecha emision del documento
	convert(varchar(10),vou.FecVD,103) as FecVD, --Fecha vencimiento del documento
	--vou.MtoOr, --Monto Origen del Documento
	--vou.Cd_MdOr, --Codigo de  moneda de origen
	--moor.Simbolo as SimMdOr,  --Simbolo de moneda de origen
	--vou.Cd_TG, --Codigo de tipo de gasto
	--tg.nombre as NomTGasto, --Nombre de tipo de gasto
	vou.Cd_CC, --Centro de costo
	vou.Cd_SC, --Sub Centro de Costo
	vou.Cd_SS, --Sub Sub Centro de Costo
	vou.Cd_Area, --Codigo de Area
	ar.NCorto as NCortoArea, --Nombre corta del Area
	vou.Cd_MR, --Codigo de Modulo
	md.Nombre as NomMR, --Nombre del Modulo
	--vou.FecReg,
	convert(varchar(10), vou.FecReg,103) as FecReg, 
	convert(varchar(10), vou.FecMdf,103) as FecMdf, --Fecha de Modificacion
	vou.UsuCrea, --Usuario que creo el movimiento
	vou.UsuModf, --usuario que modifico el movimiento
	convert(varchar,vou.FecReg,108) as HoraReg, --Hora de Registro del movimiento
	case vou.IB_Anulado when 1 then convert(bit,1) else convert(bit,0) end as IB_Anulado, --Indicador si esta anulado
	vou.DR_NSre,
	vou.DR_NDoc,
	vou.DR_NroDet,
	vou.DR_FecDet

	--,Case When (Select Count(d.Id_Doc) From DocsVou d Where d.RucE=vou.RucE and d.RegCtb=vou.RegCtb)>0 Then convert(bit,1) Else convert(bit,0) End as DocAdd

	from '+@Inter+'
	where '+@cond+'	order by Cd_Vou desc)as Voucher order by RucE , Cd_Vou'
	--order by vou.RucE desc, Cd_Vou desc)as Voucher order by RucE , Cd_Vou'
	exec (@Consulta)
	print @Consulta	
	print LEN(@Consulta)	
	--print @Cond
	--print @Inter
	set @sql = 'select top 1 @RMax =Cd_Vou from '+@Inter+' 
		where  '+@Cond+'
		order by Cd_Vou desc'
		--order by vou.RucE desc, Cd_Vou desc'
	exec sp_executesql @sql, N'@RMax int output', @Max output
	set @sql = 'select @RMin = min(Cd_Vou) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Vou from '+@Inter+' 
		where  '+@Cond+' 
		order by Cd_Vou desc) as Voucher'
	exec sp_executesql @sql, N'@RMin int output', @Min output

----------------------------------------------------------------------------------------------------
--Datos de Prueba
/*
declare @min int, @max int, @ultimo int
set @ultimo = 1000
exec dbo.Ctb_VoucherCons3_PagAnt '11111111111','2008','00','12',100,@ultimo,@max out,@min out,null
print @max
print @min
*/
----------------------------------------------------------------------------------------------------
-- Leyenda --
--PV: VIE 23/04/2010 --> Creado: Tema PAGINACION
-- PP : 2010-05-27 15:17:42.047	: <Creacion del procedimiento almacenado>
-- sp dificil





GO
