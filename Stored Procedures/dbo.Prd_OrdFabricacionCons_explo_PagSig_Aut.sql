SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Prd_OrdFabricacionCons_explo_PagSig_Aut]

@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, 
@Ult_CdOF char(10),
@NroRegs int output,
@NroPags int output,
@Max char(10) output,
@Min char(10) output,
@usuario varchar(10),
----------------------
@msj varchar(100) output
as

declare @Inter varchar(4000)
set @Inter = 'OrdFabricacion ofb
		left join Producto2 prod on ofb.Cd_Prod = prod.Cd_Prod and prod.RucE = '''+@RucE+'''
		left join EstadoOF eof on ofb.Id_EstOF = eof.Id_EstOF
		left join Prod_UM um on um.RucE = '''+@RucE+''' and um.ID_UMP = ofb.ID_UMP and um.Cd_Prod = ofb.Cd_Prod
		left join Almacen alm on alm.RucE = '''+@RucE+''' and alm.Cd_Alm = ofb.Cd_Alm
		left join Area area on area.RucE = '''+@RucE+''' and area.Cd_Area = ofb.Cd_Area
		left join Moneda mon on mon.Cd_Mda = ofb.Cd_Mda 
		left join CfgAutorizacion ca on ca.Tipo = ofb.TipAut and Cd_DMA = ''OF'' and ca.RucE = '''+@RucE+'''
		join (
			select DOC as ''Cd_OFAut'' from(
			select ofb.Cd_OF as ''DOC'',
			case (niv) when 1 then (case (dbo.verificarAutNvl('''+@RucE+''', ofb.Cd_OF, 1, ib_autcomniv, 4)) when 1 then ''NO'' else ''SI'' end) 
			else (case (dbo.verificarAutNvl('''+@RucE+''', ofb.Cd_OF, niv, ib_autcomniv, 5)) when 1 then ''NO''
			else (case (dbo.verificarAutNvl('''+@RucE+''', ofb.Cd_OF, niv-1, ib_autcomniv, 5)) when 1 then ''SI'' else ''NO'' end) end) end
			as ''Autoriza''
			from OrdFabricacion ofb
			join CfgAutorizacion ca on ofb.RucE = ca.RucE and ca.Cd_DMA = ''OF'' and ca.Tipo = ofb.TipAut 
			join cfgnivelaut cna on cna.Id_Aut = ca.id_aut
			join cfgAutsXUsuario cau on cau.id_niv = cna.id_niv 
			left join autof aof on ofb.RucE = aof.RucE and aof.Cd_OF = ofb.Cd_OF and cau.nomusu = aof.nomusu 
			where ofb.RucE = '''+@RucE+''' and (IB_Aut is null or IB_Aut = 0) and TipAut !=0
			and cau.nomusu = '''+@usuario+''' and aof.nomusu is null

			) as tabla 
			where Autoriza = ''SI''
		)OrdFab on ofb.Cd_OF = OrdFab.Cd_OFAut and ofb.RucE = '''+@RucE+''''

declare @Cond varchar(4000)
declare @sql nvarchar(4000)

--set @Cond = 'ofb.RucE= '''+@RucE+''' and ofb.FecE between '''+Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and ofb.Cd_OF >'''+isnull(@Ult_CdOF,'')+''''

if(@FecD = '' or @FecD is null)
begin
	set @Cond = ' Cd_OF not in (select CdOF_BASE from ordfabricacion where CdOF_BASE is not null) and ofb.RucE= '''+@RucE+''' and ofb.Cd_OF >'''+isnull(@Ult_CdOF,'')+''''
end
else
begin
	set @Cond = ' Cd_OF not in (select CdOF_BASE from ordfabricacion where CdOF_BASE is not null) and ofb.RucE= '''+@RucE+''' and ofb.FecE <='''+Convert(nvarchar,@FecH,103)+''' and ofb.Cd_OF >'''+isnull(@Ult_CdOF,'')+''''
end


if(@Colum = 'Cd_OF') set @Cond = @Cond+ ' and ofb.Cd_OF like '''+@Dato+''''
else if(@Colum = 'NroOF') set @Cond = @Cond+ ' and ofb.NroOF like '''+@Dato+''''
else if(@Colum = 'FecE') set @Cond = @Cond+' and Convert(nvarchar,ofb.FecE,103) like '''+@Dato+''''
else if(@Colum = 'FecEntR') set @Cond = @Cond+' and Convert(nvarchar,ofb.FecEntR,103) like '''+@Dato+''''
else if(@Colum = 'Nombre1') set @Cond = @Cond+' and prod.Nombre1 like '''+@Dato+''''
else if(@Colum = 'Descrip') set @Cond = @Cond+' and prod.Descrip like '''+@Dato+''''
else if(@Colum = 'Cd_Area') set @Cond = @Cond+' and ofb.Cd_Area like '''+@Dato+''''
else if(@Colum = 'Cd_Prod') set @Cond = @Cond+' and ofb.Cd_Prod like '''+@Dato+''''
else if(@Colum = 'Cd_Alm') set @Cond = @Cond+' and ofb.Cd_Alm like '''+@Dato+''''
else if(@Colum = 'ID_UMP') set @Cond = @Cond+' and ofb.ID_UMP like '''+@Dato+''''
else if(@Colum = 'Asunto') set @Cond = @Cond+' and ofb.Asunto like '''+@Dato+''''
else if(@Colum = 'ObsOF') set @Cond = @Cond+' and ofb.Obs like '''+@Dato+''''
else if(@Colum = 'Lote') set @Cond = @Cond+' and ofb.Lote like '''+@Dato+''''
else if(@Colum = 'CosTot') set @Cond = @Cond+' and ofb.CosTot like '''+@Dato+''''
else if(@Colum = 'Cant') set @Cond = @Cond+' and ofb.Cant like '''+@Dato+''''
else if(@Colum = 'CU') set @Cond = @Cond+' and ofb.CU like '''+@Dato+''''
else if(@Colum = 'Cd_Mda') set @Cond = @Cond+' and ofb.Cd_Mda like '''+@Dato+''''
else if(@Colum = 'CamMda') set @Cond = @Cond+' and ofb.CamMda like '''+@Dato+''''
else if(@Colum = 'FecReg') set @Cond = @Cond+' and Convert(nvarchar,ofb.FecReg,103) like '''+@Dato+''''
else if(@Colum = 'FecMdf') set @Cond = @Cond+' and Convert(nvarchar,ofb.FecMdf,103) like '''+@Dato+''''
else if(@Colum = 'UsuCrea') set @Cond = @Cond+' and ofb.UsuCrea like '''+@Dato+''''
else if(@Colum = 'UsuModf') set @Cond = @Cond+' and ofb.UsuModf like '''+@Dato+''''
else if(@Colum = 'Cd_CC') set @Cond = @Cond+' and ofb.Cd_CC like '''+@Dato+''''
else if(@Colum = 'Cd_SC') set @Cond = @Cond+' and ofb.Cd_SC like '''+@Dato+''''
else if(@Colum = 'Cd_SS') set @Cond = @Cond+' and ofb.Cd_SS like '''+@Dato+''''
else if(@Colum = 'Id_EstOF') set @Cond = @Cond+' and eof.Id_EstOF like '''+@Dato+''''
else if(@Colum = 'Descrip') set @Cond = @Cond+' and eof.Descrip like '''+@Dato+''''
else if(@Colum = 'AutorizadoPor') set @Cond = @Cond+' and ofb.AutorizadoPor like '''+@Dato+''''
else if(@Colum = 'CA01') set @Cond = @Cond+' and ofb.CA01 like '''+@Dato+''''
else if(@Colum = 'CA02') set @Cond = @Cond+' and ofb.CA02 like '''+@Dato+''''
else if(@Colum = 'CA03') set @Cond = @Cond+' and ofb.CA03 like '''+@Dato+''''
else if(@Colum = 'CA04') set @Cond = @Cond+' and ofb.CA04 like '''+@Dato+''''
else if(@Colum = 'CA05') set @Cond = @Cond+' and ofb.CA05 like '''+@Dato+''''
else if(@Colum = 'CA06') set @Cond = @Cond+' and ofb.CA06 like '''+@Dato+''''
else if(@Colum = 'CA07') set @Cond = @Cond+' and ofb.CA07 like '''+@Dato+''''
else if(@Colum = 'CA08') set @Cond = @Cond+' and ofb.CA08 like '''+@Dato+''''
else if(@Colum = 'CA09') set @Cond = @Cond+' and ofb.CA09 like '''+@Dato+''''
else if(@Colum = 'CA10') set @Cond = @Cond+' and ofb.CA10 like '''+@Dato+''''
else if(@Colum = 'DescripEstOF') set @Cond = @Cond+' and eof.Descrip like '''+@Dato+''''
else if(@Colum = 'NomProd') set @Cond = @Cond+' and prod.Nombre1 like '''+@Dato+''''
else if(@Colum = 'DescripProd') set @Cond = @Cond+' and prod.Descrip like '''+@Dato+''''
else if(@Colum = 'DescripUMP') set @Cond = @Cond+' and um.DescripAlt like '''+@Dato+''''
else if(@Colum = 'AreaDescrip') set @Cond = @Cond+' and area.Descrip like '''+@Dato+''''
else if(@Colum = 'Almacen') set @Cond = @Cond+' and alm.Nombre like '''+@Dato+''''
else if(@Colum = 'Moneda') set @Cond = @Cond+' and mon.Nombre like '''+@Dato+''''
else if(@Colum = 'DescripTip') set @Cond = @Cond+' and ca.DescripTip like '''+@Dato+''''


declare @Consulta varchar(8000)
set @Consulta = 'select top '+Convert(nvarchar,@TamPag)+' ofb.RucE, ofb.Cd_OF, ofb.NroOF, convert(nvarchar,ofb.FecE,103) as FecE, 
		convert(nvarchar,ofb.FecEntR,103) as FecEntR, ofb.Asunto, ofb.Obs as ObsOF, ofb.Cd_Prod, prod.Nombre1 as NomProd, 
		prod.Descrip as DescripProd, ofb.ID_UMP, um.DescripAlt as DescripUMP, ofb.CU, ofb.Cant, ofb.CosTot, ofb.Cd_Area, 
		area.Descrip as AreaDescrip, ofb.Cd_Alm, alm.Nombre as Almacen, ofb.Lote, ofb.Cd_Mda, mon.Nombre as Moneda, ofb.CamMda, 
		convert(nvarchar,ofb.FecReg,103) as FecReg, ofb.UsuCrea, convert(nvarchar,ofb.FecMdf,103) as FecMdf, ofb.UsuModf, 
		ofb.Cd_CC, ofb.Cd_SC, ofb.Cd_SS, eof.Id_EstOF, eof.Descrip as DescripEstOF, isnull(ofb.TipAut,0) as TipAut, ca.DescripTip, 
		ofb.AutorizadoPor, ofb.CA01, ofb.CA02, ofb.CA03, ofb.CA04, ofb.CA05, ofb.CA06, ofb.CA07, ofb.CA08, ofb.CA09, ofb.CA10, case ofb.IB_Aut when 1 then 1 else 0 end as IB_Aut
		from '
		+@Inter+' 
		where '+ @Cond+' order by ofb.Cd_OF'

exec (@Consulta)
if(@Ult_CdOF is null) 
begin
	set @sql= 'select @Regs = count(*) from '+@Inter+ '  where ' + @Cond
	exec sp_executesql @sql, N'@Regs int output', @NroRegs output
	select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
end
set @sql = 'select @RMax = max(Cd_OF) from(select top '+Convert(nvarchar,@TamPag)+' Cd_OF from '+@Inter+' where '+@Cond+' order by Cd_OF) as OrdenFabricacion'
exec sp_executesql @sql, N'@RMax char(10) output', @Max output

set @sql = 'select top 1 @RMin =Cd_OF from '+@Inter+' where '+@Cond+' order by Cd_OF'
exec sp_executesql @sql, N'@RMin char(10) output', @Min output
print @sql

-- Leyenda --
-- MM : 27-02-2011 : <Creacion del SP>
-- exec Prd_OrdFabricacionCons_explo_PagSig_Aut  '11111111111', '01/08/2011', '01/04/2011', null, null, 100, '', null, null, null, null, 'mmedrano',null







GO
