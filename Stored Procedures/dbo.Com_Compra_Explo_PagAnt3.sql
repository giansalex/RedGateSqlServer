SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Compra_Explo_PagAnt3]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
-----------------------
@TamPag int, --TamaÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â±o Pagina
@Ult_CdCom char(10),
@Max char(10) output,
@Min char(10) output,
@tip int,
-----------------------
@msj varchar(100) output
as
set language Spanish
	--Interseccion de tablas
	declare @Inter varchar(5000)
	set @Inter = 'compra co left join proveedor2 prv on prv.Cd_Prv=co.Cd_Prv and prv.RucE=co.RucE
		       left join FormaPC fp on fp.Cd_FPC=co.Cd_FPC left join Area ar on ar.Cd_Area=co.Cd_Area and ar.RucE=co.RucE
		       left join MtvoIngSal mis on mis.Cd_MIS=co.Cd_MIS and mis.RucE=co.RucE
		       left join Moneda md on md.Cd_Mda=co.Cd_Mda'
	print @Inter
	--Condicion de la Consulta
	
	declare @Cond varchar(4000)
	declare @sql nvarchar(4000)
	
	if(@FecD = '' or @FecD is null)
		set @Cond = 'co.RucE= '''+@RucE+''' and co.Cd_Com <'''+isnull(@Ult_CdCom,'')+''''
	else
		set @Cond = 'co.RucE= '''+@RucE+''' and co.FecMov between '''+ Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and co.Cd_Com <'''+isnull(@Ult_CdCom,'')+''''
	
	if(@tip = 3)
		set @Cond = @Cond + ' and co.Cd_Com in (select distinct Cd_Com from CompraDet where RucE= '''+@RucE+''' and Cd_Prod is not null)'
	else if(@tip = 4)
		set @Cond = @Cond + ' and co.Cd_Com in (select distinct Cd_Com from CompraDet where RucE= '''+@RucE+''' and Cd_SRV is not null)'
	print @Cond
	if(@Colum = 'Cd_Com') set @Cond = @Cond + ' and co.Cd_Com like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond + ' and co.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Ejer') set @Cond =@Cond + ' and co.Ejer like '''+@Dato+''''
	else if(@Colum = 'Prdo') set @Cond =@Cond + ' and co.Prdo like '''+@Dato+''''
	else if(@Colum = 'Cd_Prv') set @Cond =@Cond + ' and co.Cd_Prv like '''+@Dato+''''
	else if(@Colum = 'Proveedor') set @Cond = @Cond+' and case(isnull(len(prv.RSocial),0)) when 0 then prv.ApPat + '' '' + prv.ApMat + '', '' + prv.Nom else prv.RSocial end like '''+@Dato+''''
	else if(@Colum = 'Cd_FPC') set @Cond = @Cond + ' and co.Cd_FPC like '''+@Dato+''''
	else if(@Colum = 'FormaPago') set @Cond = @Cond + ' and fp.Nombre like '''+@Dato+''''
	else if(@Colum = 'FecAPag') set @Cond = @Cond + ' and convert(nvarchar,co.FecAPag,103) like '''+@Dato+''''
	else if(@Colum = 'Cd_TD') set @Cond = @Cond + ' and co.Cd_TD like '''+@Dato+''''
	else if(@Colum = 'NroSre') set @Cond = @Cond + ' and co.NroSre like '''+@Dato+''''
	else if(@Colum = 'NroDoc') set @Cond = @Cond + ' and co.NroDoc like '''+@Dato+''''
	else if(@Colum = 'FecED') set @Cond = @Cond + ' and convert(nvarchar,co.FecED,103) like '''+@Dato+''''
	else if(@Colum = 'FecVD') set @Cond = @Cond + ' and convert(nvarchar,co.FecVD,103) like '''+@Dato+''''
	else if(@Colum = 'Cd_Area') set @Cond =@Cond + ' and co.Cd_Area like '''+@Dato+''''
	else if(@Colum = 'Area') set @Cond = @Cond + ' and ar.Descrip like'''+@Dato+''''
	else if(@Colum = 'Cd_CC') set @Cond = @Cond + ' and co.Cd_CC like'''+@Dato+''''
	else if(@Colum = 'Cd_SC') set @Cond = @Cond + ' and co.Cd_SC like'''+@Dato+''''
	else if(@Colum = 'Cd_SS') set @Cond = @Cond + ' and co.Cd_SS like '''+@Dato+''''
	else if(@Colum = 'BIM_S') set @Cond = @Cond + ' and co.BIM_S like '''+@Dato+''''
	else if(@Colum = 'IGV_S') set @Cond = @Cond + ' and co.IGV_S like '''+@Dato+''''
	else if(@Colum = 'BIM_E') set @Cond = @Cond + ' and co.BIM_E like '''+@Dato+''''
	else if(@Colum = 'IGV_E') set @Cond = @Cond + ' and co.IGV_E like '''+@Dato+''''
	else if(@Colum = 'BIM_C') set @Cond = @Cond + ' and co.BIM_C like '''+@Dato+''''
	else if(@Colum = 'IGV_C') set @Cond = @Cond + ' and co.IGV_C like '''+@Dato+''''
	else if(@Colum = 'Imp_N') set @Cond = @Cond + ' and co.Imp_N like '''+@Dato+''''
	else if(@Colum = 'Imp_O') set @Cond = @Cond + ' and co.Imp_O like '''+@Dato+''''
	else if(@Colum = 'Total') set @Cond = @Cond + ' and co.Total like '''+@Dato+''''
	else if(@Colum = 'Cd_Mda') set @Cond = @Cond + ' and  md.Nombre like '''+@Dato+''''
	else if(@Colum = 'CamMda') set @Cond = @Cond + ' and co.CamMda like '''+@Dato+''''
	else if(@Colum = 'Cd_MIS') set @Cond = @Cond + ' and co.Cd_MIS like '''+@Dato+''''
	else if(@Colum = 'MtvoIngSal') set @Cond = @Cond + ' and mis.Descrip like '''+@Dato+''''
	else if(@Colum = 'Cd_OC') set @Cond = @Cond + ' and co.Cd_OC like '''+@Dato+''''
	else if(@Colum = 'Cd_Alm') set @Cond = @Cond + ' and co.Cd_Alm like '''+@Dato+''''
	else if(@Colum = 'Almacen') set @Cond = @Cond + ' and al.Nombre like '''+@Dato+''''
	else if(@Colum = 'IB_Pgdo') set @Cond = @Cond + ' and co.IB_Pgdo like '''+@Dato+''''
	else if(@Colum = 'IB_Anulado') set @Cond = @Cond + ' and co.IB_Anulado like '''+@Dato+''''
	else if(@Colum = 'DR_NCND') set @Cond = @Cond + ' and co.DR_NCND like '''+@Dato+''''
	else if(@Colum = 'DR_NroDet') set @Cond = @Cond + ' and co.DR_NroDet like '''+@Dato+''''
	else if(@Colum = 'DR_FecDet') set @Cond = @Cond + ' and convert(nvarchar,co.DR_FecDet,103) like '''+@Dato+''''
	else if(@Colum = 'DR_CdCom') set @Cond = @Cond + ' and co.DR_CdCom like '''+@Dato+''''
	else if(@Colum = 'DR_FecED') set @Cond = @Cond + ' and convert(nvarchar,co.DR_FecED,103) like '''+@Dato+''''
	else if(@Colum = 'DR_CdTD') set @Cond = @Cond + ' and co.DR_CdTD like '''+@Dato+''''
	else if(@Colum = 'DR_NSre') set @Cond = @Cond + ' and co.DR_NSre like '''+@Dato+''''
	else if(@Colum = 'DR_NDoc') set @Cond = @Cond + ' and co.DR_NDoc like '''+@Dato+''''
	else if(@Colum = 'CA01') set @Cond = @Cond + ' and co.CA01 like '''+@Dato+''''
	else if(@Colum = 'CA02') set @Cond = @Cond + ' and co.CA02 like '''+@Dato+''''
	else if(@Colum = 'CA03') set @Cond = @Cond + ' and co.CA03 like '''+@Dato+''''
	else if(@Colum = 'CA04') set @Cond = @Cond + ' and co.CA04 like '''+@Dato+''''
	else if(@Colum = 'CA05') set @Cond = @Cond + ' and co.CA05 like '''+@Dato+''''
	else if(@Colum = 'CA06') set @Cond = @Cond + ' and co.CA06 like '''+@Dato+''''
	else if(@Colum = 'CA07') set @Cond = @Cond + ' and co.CA07 like '''+@Dato+''''
	else if(@Colum = 'CA08') set @Cond = @Cond + ' and co.CA08 like '''+@Dato+''''
	else if(@Colum = 'CA09') set @Cond = @Cond + ' and co.CA09 like '''+@Dato+''''
	else if(@Colum = 'CA10') set @Cond = @Cond + ' and co.CA10 like '''+@Dato+''''
	else if(@Colum = 'CA11') set @Cond = @Cond + ' and co.CA11 like '''+@Dato+''''
	else if(@Colum = 'CA12') set @Cond = @Cond + ' and co.CA12 like '''+@Dato+''''
	else if(@Colum = 'CA13') set @Cond = @Cond + ' and co.CA13 like '''+@Dato+''''
	else if(@Colum = 'CA14') set @Cond = @Cond + ' and co.CA14 like '''+@Dato+''''
	else if(@Colum = 'CA15') set @Cond = @Cond + ' and co.CA15 like '''+@Dato+''''
	else if(@Colum = 'CA16') set @Cond = @Cond + ' and co.CA16 like '''+@Dato+''''
	else if(@Colum = 'CA17') set @Cond = @Cond + ' and co.CA17 like '''+@Dato+''''
	else if(@Colum = 'CA18') set @Cond = @Cond + ' and co.CA18 like '''+@Dato+''''
	else if(@Colum = 'CA19') set @Cond = @Cond + ' and co.CA19 like '''+@Dato+''''
	else if(@Colum = 'CA20') set @Cond = @Cond + ' and co.CA20 like '''+@Dato+''''
	else if(@Colum = 'CA21') set @Cond = @Cond + ' and co.CA21 like '''+@Dato+''''
	else if(@Colum = 'CA22') set @Cond = @Cond + ' and co.CA22 like '''+@Dato+''''
	else if(@Colum = 'CA23') set @Cond = @Cond + ' and co.CA23 like '''+@Dato+''''
	else if(@Colum = 'CA24') set @Cond = @Cond + ' and co.CA24 like '''+@Dato+''''
	else if(@Colum = 'CA25') set @Cond = @Cond + ' and co.CA25 like '''+@Dato+''''
	
	declare @Consulta varchar(8000)
	set @Consulta=	'
		       select *from(select top ' +Convert(nvarchar,@Tampag)+'
		       convert(bit,0) As Sel,
		       co.Cd_Com, co.RegCtb, co.Ejer, co.Prdo, co.Cd_Prv,
		       case(isnull(len(prv.RSocial),0)) when 0 then prv.ApPat + '' '' + prv.ApMat + '', '' + prv.Nom else prv.RSocial end as Proveedor
		       , co.Cd_FPC, fp.Nombre as FormaPago, convert(nvarchar,co.FecAPag,103) as FecAPag, co.Cd_TD, co.NroSre, co.NroDoc, convert(nvarchar,co.FecED,103) as FecED, convert(nvarchar,co.FecVD,103) as FecVD,co.Cd_Area
		       , ar.Descrip as Area, co.Cd_CC, co.Cd_SC, co.Cd_SS, co.BIM_S, co.IGV_S, co.BIM_E, co.IGV_E,co.BIM_C, co.IGV_C,co.Imp_N,co.Imp_O, co.Total, co.CamMda
		       , mis.Descrip as MtvoIngSal,mis.Cd_Mis, co.Cd_OC, case co.IB_Pgdo when 1 then convert(bit,1) else convert(bit,0) end as IB_Pgdo, convert(bit,co.IB_Anulado) as IB_Anulado, co.DR_NCND, co.DR_NroDet
		       , convert(nvarchar,co.DR_FecDet,103) as DR_FecDet, co.DR_CdCom, convert(nvarchar,co.DR_FecED,103) as DR_FecED, co.DR_CdTD, co.DR_NSre, co.DR_NDoc, co.CA01, co.CA02, co.CA03, co.CA04, co.CA05
		       , co.CA06, co.CA07, co.CA08, co.CA09, co.CA10
		       , co.CA11, co.CA12, co.CA13, co.CA14, co.CA15
		       , co.CA16, co.CA17, co.CA18, co.CA19, co.CA20
		       , co.CA21, co.CA22, co.CA23, co.CA24, co.CA25
		       ,md.Nombre as Cd_Mda, Convert(nvarchar,co.FecReg,103) as FecReg,co.UsuCrea, Convert(nvarchar,co.FecMdf,103) FecMdf,co.UsuModf
		       , Case When (Select Count(d.Id_Doc) From DocsCom d Where d.RucE=co.RucE and d.Cd_Com=co.Cd_Com)>0 Then convert(bit,1) Else convert(bit,0) End DocAdd

		       from '
			+@Inter+' 
		       where '+ @Cond + ' order by co.Cd_Com desc) as Compra order by Cd_Com'
	exec (@Consulta)
	print @Consulta
	--print @Cond
	--print @Inter

	set @sql = '
		      select top 1 @RMax =Cd_Com from '+@Inter+' where  '+@Cond+' order by Cd_Com desc'
	exec sp_executesql @sql, N'@RMax char(10) output', @Max output
	print @sql
	set @sql = '
		      select @RMin = min(Cd_Com) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Com from '+@Inter+' where  '+@Cond+' order by Cd_Com desc) as Compra'
	exec sp_executesql @sql, N'@RMin char(10) output', @Min output
	print @sql
--exec Com_Compra_Explo_PagAnt '11111111111','01/08/2010','30/09/2010',null,null,5,'CM00000006',null,null,null

-- Leyenda --
-- JJ : 2010-08-14 : <Creacion del procedimiento almacenado>
-- MP : 2011-04/14 : <Modificacion del procedimiento almacenado>



--exec dbo.Com_Compra_Explo_PagAnt4 '11111111111','01/04/2011','01/07/2011',null,null,10,'CM00000259  ',null,null,null,''

GO
