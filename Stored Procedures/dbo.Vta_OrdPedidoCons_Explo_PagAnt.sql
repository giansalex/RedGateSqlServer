SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdPedidoCons_Explo_PagAnt]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
-----------------------
@TamPag int, --TamaÃ±o Pagina
@Ult_CdOP char(10),
@Max char(10) output,
@Min char(10) output,
-----------------------
@msj varchar(100) output
as
	--Interseccion de tablas
	declare @Inter varchar(4000)
	set @Inter='OrdPedido op inner join Vendedor2 ve on ve.Cd_Vdr=op.Cd_Vdr and ve.RucE=op.RucE
	inner join Cliente2 cl on cl.Cd_Clt=op.Cd_Clt and cl.RucE=op.RucE
	inner join Moneda mo on mo.Cd_Mda=op.Cd_Mda'

	--Condicion de la Consulta
	declare @Cond varchar(4000)
	declare @sql nvarchar(4000)
--	set @Cond = 'op.RucE= '''+@RucE+''' and op.FecE between '''+Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and op.Cd_OP <'''+isnull(@Ult_CdOP,'')+''''
	if(@FecD = '' or @FecD is null)
	begin
		set @Cond = 'op.RucE= '''+@RucE+''' and op.Cd_OP <'''+isnull(@Ult_CdOP,'')+''''
	end
	else
	begin
		set @Cond = 'op.RucE= '''+@RucE+''' and op.FecE between '''+Convert(nvarchar,@FecD,103)+''' and '''+
		Convert(nvarchar,@FecH,103)+''' and op.Cd_OP <'''+isnull(@Ult_CdOP,'')+''''
	end

	if(@Colum = 'Cd_OP') set @Cond = @Cond+ ' and op.Cd_OP like '''+@Dato+''''
	else if(@Colum = 'NroOP') set @Cond = @Cond+ ' and op.NroOP like '''+@Dato+''''
	else if(@Colum = 'Cd_Vdr') set @Cond =@Cond+ ' and op.Cd_Vdr like '''+@Dato+''''
	else if(@Colum = 'Vendedor') set @Cond = @Cond+' and (ve.ApPat + '' '' + ve.ApMat +'', ''+ve.Nom) like '''+@Dato+''''
	else if(@Colum = 'Cd_Clt') set @Cond = @Cond+' and op.Cd_Clt like '''+@Dato+''''
	else if(@Colum = 'Cliente') set @Cond = @Cond+' and case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat + '' '' + cl.ApMat + '', '' + cl.Nom else cl.RSocial end like '''+@Dato+''''
	else if(@Colum = 'FecE') set @Cond = @Cond+' and Convert(nvarchar,op.FecE,103) like '''+@Dato+''''
	else if(@Colum = 'Obs') set @Cond = @Cond+' and op.Obs like '''+@Dato+''''
	else if(@Colum = 'Cd_Mda') set @Cond = @Cond+' and op.Cd_Mda like '''+@Dato+''''
	else if(@Colum = 'Desc_Mda') set @Cond = @Cond+' and mo.Nombre like '''+@Dato+''''
	else if(@Colum = 'ValorNeto') set @Cond = @Cond+' and op.ValorNeto like '''+@Dato+''''
	else if(@Colum = 'DsctoFnzInf_P') set @Cond = @Cond+' and op.DsctoFnzInf_P like '''+@Dato+''''
	else if(@Colum = 'DsctoFnzInf_I') set @Cond =@Cond+ ' and op.DsctoFnzInf_I like '''+@Dato+''''
	else if(@Colum = 'DsctoFnzAf_P') set @Cond = @Cond+' and op.DsctoFnzAf_P like'''+@Dato+''''
	else if(@Colum = 'DsctoFnzAf_I') set @Cond = @Cond+' and op.DsctoFnzAf_I like'''+@Dato+''''
	else if(@Colum = 'BIM') set @Cond = @Cond+' and op.BIM like'''+@Dato+''''
	else if(@Colum = 'IGV') set @Cond = @Cond+ ' and op.IGV like '''+@Dato+''''
	else if(@Colum = 'Total') set @Cond = @Cond+ ' and op.Total like '''+@Dato+''''
	else if(@Colum = 'Cd_Cot') set @Cond = @Cond+ ' and op.Cd_Cot like '''+@Dato+''''
	else if(@Colum = 'CA01') set @Cond = @Cond+ ' and op.CA01 like '''+@Dato+''''
	else if(@Colum = 'CA02') set @Cond = @Cond+ ' and op.CA02 like '''+@Dato+''''
	else if(@Colum = 'CA03') set @Cond = @Cond+ ' and op.CA03 like '''+@Dato+''''
	else if(@Colum = 'CA04') set @Cond = @Cond+ ' and op.CA04 like '''+@Dato+''''
	else if(@Colum = 'CA05') set @Cond = @Cond+ ' and op.CA05 like '''+@Dato+''''
	else if(@Colum = 'CA06') set @Cond = @Cond+ ' and op.CA06 like '''+@Dato+''''
	else if(@Colum = 'CA07') set @Cond = @Cond+ ' and op.CA07 like '''+@Dato+''''
	else if(@Colum = 'CA08') set @Cond = @Cond+ ' and op.CA08 like '''+@Dato+''''
	else if(@Colum = 'CA09') set @Cond = @Cond+ ' and op.CA09 like '''+@Dato+''''
	else if(@Colum = 'CA10') set @Cond = @Cond+ ' and op.CA10 like '''+@Dato+''''

	declare @Consulta varchar(8000)
	set @Consulta=	'select *from(select top ' +Convert(nvarchar,@Tampag)+'	op.Cd_OP,op.NroOP,op.Cd_Vdr, (ve.ApPat + '' '' + ve.ApMat +'', ''+ve.Nom) as Vendedor,
			op.Cd_Clt,case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat + '' '' + cl.ApMat + '', '' + cl.Nom else cl.RSocial end as Cliente,
			Convert(nvarchar,op.FecE,103) as FecE,op.Obs,op.Cd_Mda,mo.Nombre as Desc_Mda,op.ValorNeto,
			op.DsctoFnzInf_P,op.DsctoFnzInf_I,op.DsctoFnzAf_P,op.DsctoFnzAf_I,op.BIM,op.IGV,op.Total,op.Cd_Cot,
			op.CA01, op.CA02, op.CA03, op.CA04, op.CA05, op.CA06, op.CA07, op.CA08, op.CA09, op.CA10
			from '
			+@Inter+' 
			where '+ @Cond + ' order by op.Cd_OP desc) as OrdPedido order by Cd_OP'
	exec (@Consulta)

	print @Consulta
	--print @Cond
	--print @Inter

	set @sql = 'select top 1 @RMax =Cd_OP from '+@Inter+' where  '+@Cond+' order by Cd_OP desc'
	exec sp_executesql @sql, N'@RMax char(10) output', @Max output
	print @sql
	set @sql = 'select @RMin = min(Cd_OP) from(select top '+Convert(nvarchar,@TamPag)+' Cd_OP from '+@Inter+' where  '+@Cond+' order by Cd_OP desc) as OrdPedido'
	exec sp_executesql @sql, N'@RMin char(10) output', @Min output
	print @sql
-- Leyenda --
-- JJ : 2010-08-05 : <Creacion del procedimiento almacenado>
-- JJ : 2010-08-09 : <Modificacion del procedimiento almacenado>
GO
