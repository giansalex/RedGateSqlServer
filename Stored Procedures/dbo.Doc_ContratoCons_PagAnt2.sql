SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_ContratoCons_PagAnt2]

@RucE nvarchar(11),
@FecDesde datetime,
@FecHasta datetime,

@Colum varchar(100),
@Dato varchar(100),

----------------------
@TamPag int, -- Tamano‚de Pagina
@Ult_Cod int,
@NroRegs int output, -- Nro de Registros solo es consultado la primera vez
@NroPags int output, -- Nro de Paginas solo es consultado la primera vez
@Max int output,
@Min int output,
----------------------
@NomUsu nvarchar(10),

@msj varchar(100) output

AS
	declare @Tablas varchar(3000)
	declare @Cond nvarchar(2000)
	declare @sql nvarchar(4000)
	declare @Consulta  varchar(8000)
	
	Set @Tablas =' Contrato o
		Left Join Cliente2 c On c.RucE=o.RucE and c.Cd_Clt=o.Cd_Clt
		Left Join Proveedor2 p On p.RucE=o.RucE and p.Cd_Prv=o.Cd_Prv
		Left Join Vendedor2 v On v.RucE=o.RucE and v.Cd_Vdr=o.Cd_Vdr
		Left Join Area a On a.RucE=o.RucE and a.Cd_Area=o.Cd_Area
		Left Join CCostos cc On cc.RucE=o.RucE and cc.Cd_CC=o.Cd_CC
		Left Join CCSub sc On sc.RucE=o.RucE and sc.Cd_CC=o.Cd_CC and sc.Cd_SC=o.Cd_SC
		Left Join CCSubSub ss On ss.RucE=o.RucE and ss.Cd_CC=o.Cd_CC and ss.Cd_SC=o.Cd_SC and ss.Cd_SS=o.Cd_SS
		'
		
	set @Cond = ' o.RucE='''+@RucE+''' and o.FecReg >=Convert(datetime,'''+Convert(varchar,@FecDesde,103)+''') and o.FecReg<=Convert(datetime,'''+Convert(varchar,@FecHasta,103)+'''+'' 23:59:59'') and o.Cd_Ctt > '+Convert(nvarchar, isnull(@Ult_Cod,''))+'and o.Cd_Area in (Select Cd_Area From AreaXUsuario Where RucE='''+@RucE+''' and NomUsu='''+@NomUsu+''' and Estado=1)'
		 if(@Colum = 'Cd_Ctt')  set @Cond = @Cond+ ' and o.Cd_Ctt like '''+@Dato+''''
	else if(@Colum = 'NDocClt') set @Cond = @Cond+ ' and c.NDoc like '''+@Dato+''''
	else if(@Colum = 'NomClt')  set @Cond = @Cond+ ' and isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) like '''+@Dato+''''
	else if(@Colum = 'FecIni')  set @Cond = @Cond+ ' and Convert(varchar,o.FecIni,103) like '''+@Dato+''''
	else if(@Colum = 'FecFin')  set @Cond = @Cond+ ' and Convert(varchar,o.FecFin,103) like '''+@Dato+''''
	else if(@Colum = 'Descrip') set @Cond = @Cond+ ' and o.Descrip like '''+@Dato+''''
	else if(@Colum = 'Obs')		set @Cond = @Cond+ ' and o.Obs like '''+@Dato+''''
	else if(@Colum = 'FecReg')  set @Cond = @Cond+ ' and Convert(varchar,o.FecReg,103) like '''+@Dato+''''
	else if(@Colum = 'FecMdf')  set @Cond = @Cond+ ' and Convert(varchar,o.FecMdf,103) like '''+@Dato+''''
	else if(@Colum = 'UsuCrea') set @Cond = @Cond+ ' and o.UsuCrea like '''+@Dato+''''
	else if(@Colum = 'UsuMdf')  set @Cond = @Cond+ ' and o.UsuMdf like '''+@Dato+''''
	else if(@Colum = 'Estado')  set @Cond = @Cond+ ' and o.Estado like '''+@Dato+''''
	
	else if(@Colum = 'NomArea')  set @Cond = @Cond+ ' and a.Descrip  like '''+@Dato+''''
	
	else if(@Colum = 'NomCC')  set @Cond = @Cond+ ' and cc.Descrip like '''+@Dato+''''
	else if(@Colum = 'NomSC')  set @Cond = @Cond+ ' and sc.Descrip like '''+@Dato+''''
	else if(@Colum = 'NomSS')  set @Cond = @Cond+ ' and ss.Descrip like '''+@Dato+''''

	else if(@Colum = 'CA01') set @Cond = @Cond + ' and o.CA01 like '''+@Dato+''''
	else if(@Colum = 'CA02') set @Cond = @Cond + ' and o.CA02 like '''+@Dato+''''
	else if(@Colum = 'CA03') set @Cond = @Cond + ' and o.CA03 like '''+@Dato+''''
	else if(@Colum = 'CA04') set @Cond = @Cond + ' and o.CA04 like '''+@Dato+''''
	else if(@Colum = 'CA05') set @Cond = @Cond + ' and o.CA05 like '''+@Dato+''''
	else if(@Colum = 'CA06') set @Cond = @Cond + ' and o.CA06 like '''+@Dato+''''
	else if(@Colum = 'CA07') set @Cond = @Cond + ' and o.CA07 like '''+@Dato+''''
	else if(@Colum = 'CA08') set @Cond = @Cond + ' and o.CA08 like '''+@Dato+''''
	else if(@Colum = 'CA09') set @Cond = @Cond + ' and o.CA09 like '''+@Dato+''''
	else if(@Colum = 'CA10') set @Cond = @Cond + ' and o.CA10 like '''+@Dato+''''
	else if(@Colum = 'CA11') set @Cond = @Cond + ' and o.CA11 like '''+@Dato+''''
	else if(@Colum = 'CA12') set @Cond = @Cond + ' and o.CA12 like '''+@Dato+''''
	else if(@Colum = 'CA13') set @Cond = @Cond + ' and o.CA13 like '''+@Dato+''''
	else if(@Colum = 'CA14') set @Cond = @Cond + ' and o.CA14 like '''+@Dato+''''
	else if(@Colum = 'CA15') set @Cond = @Cond + ' and o.CA15 like '''+@Dato+''''
	else if(@Colum = 'CA16') set @Cond = @Cond + ' and o.CA16 like '''+@Dato+''''
	else if(@Colum = 'CA17') set @Cond = @Cond + ' and o.CA17 like '''+@Dato+''''
	else if(@Colum = 'CA18') set @Cond = @Cond + ' and o.CA18 like '''+@Dato+''''
	else if(@Colum = 'CA19') set @Cond = @Cond + ' and o.CA19 like '''+@Dato+''''
	else if(@Colum = 'CA20') set @Cond = @Cond + ' and o.CA20 like '''+@Dato+''''
	
	Set @Consulta=
	'
	select * from(
	select top '+Convert(nvarchar,@TamPag)+' 
		o.RucE,
		''Eliminar'' As Elim,
		''Editar'' As Edit,
		o.Cd_Ctt,
		Case When isnull(o.Cd_Clt,'''')<>'''' Then o.Cd_Clt Else 
			Case When isnull(o.Cd_Prv,'''')<>'''' Then o.Cd_Prv Else
				Case When isnull(o.Cd_Vdr,'''')<>'''' Then o.Cd_Vdr Else '''' End End End As Cd_Aux,
		Case When isnull(o.Cd_Clt,'''')<>'''' Then c.NDoc Else 
			Case When isnull(o.Cd_Prv,'''')<>'''' Then p.NDoc Else
				Case When isnull(o.Cd_Vdr,'''')<>'''' Then v.NDoc Else '''' End End End As NDocAux,
		Case When isnull(o.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) Else 
			Case When isnull(o.Cd_Prv,'''')<>'''' Then isnull(p.RSocial,isnull(p.ApPat,'''')+'' ''+isnull(p.ApMat,'''')+'' ''+isnull(p.Nom,'''')) Else
				Case When isnull(o.Cd_Vdr,'''')<>'''' Then isnull(v.RSocial,isnull(v.ApPat,'''')+'' ''+isnull(v.ApMat,'')+'' ''+isnull(v.Nom,'''')) Else '''' End End End As NomAux,

		Convert(varchar,o.FecIni,103) As FecIni,
		Convert(varchar,o.FecFin,103) As FecFin,
		
		isnull(a.Descrip,'''') As NomArea,
		isnull(cc.Descrip,'''') As NomCC,
		isnull(sc.Descrip,'''') As NomSC,
		isnull(ss.Descrip,'''') As NomSS,
		o.Descrip,
		o.Obs,
		Convert(varchar,o.FecReg,103) As FecReg,
		Convert(varchar,o.FecMdf,103) As FecMdf,
		o.UsuCrea,
		o.UsuMdf,
		o.Estado,
		o.CA01,o.CA02,o.CA03,o.CA04,o.CA05,
		o.CA06,o.CA07,o.CA08,o.CA09,o.CA10,
		o.CA11,o.CA12,o.CA13,o.CA14,o.CA15,
		o.CA16,o.CA17,o.CA18,o.CA19,o.CA20
	'
	
	Print @Consulta
	Print 'from '+@Tablas
	Print 'where '+@Cond
	Print 'ORDER by 1,2 desc) as Contraro Order by 1,2'
	
	Exec (@Consulta + '
			from '+@Tablas+'
			where '+@Cond+'
			ORDER by 1,2 desc) as Contraro Order by 1,2'
		 )
	
	set @sql = 'select top 1 @RMax=Cd_Ctt from '+@Tablas+' 
		where  '+@Cond+'
		order by Cd_Ctt desc'
	exec sp_executesql @sql, N'@RMax int output', @Max output
	
	set @sql = 'select @RMin=min(Cd_Ctt) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Ctt from '+@Tablas+' 
		where  '+@Cond+' 
		Order by Cd_Ctt desc) as Voucher'
	exec sp_executesql @sql, N'@RMin int output', @Min output

-- Leyenda 
-- DI : 26/10/2011 <Creacion del procedimiento almacenado>

/*
Declare @NroRegs int,@NroPags int,@Max int,@Min int,@msj varchar(100)
Set @NroRegs = 0
Set @NroPags = 0
Set @Max = 0
Set @Min = 0
Set @msj = ''
exec [Doc_ContratoCons_PagAnt] '11111111111','25/09/2011','26/10/2011','','','1','3',@NroRegs output,@NroPags output,@Max output,@Min output,@msj output
Print @NroRegs
Print @NroPags
Print @Max
Print @Min
Print @msj
*/
GO
