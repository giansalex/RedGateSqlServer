SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Inv_CotizacionCons_explo_PagSig5]
	-- Add the parameters for the stored procedure here
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),

--------------------------------------
@TamPag int, 
@Ult_CdCot nvarchar(10),
@NroRegs int output,--Nro de Registros solo es consultado la primera vez
@NroPags int output,--Nro de Paginas solo es Consulado la primera vez
@Max char(10) output,
@Min char(10) output,



--exec Inv_CotizacionCons_explo_PagSig4 '11111111111','01/08/2012','31/08/2012','','',500,'',null,null,null,null,null
--------------------------------------

@msj varchar(100) output
	as
	set language Spanish 
	declare @Inter varchar(5000)
	
	
	set @Inter = 'Cotizacion c
		left join Moneda m on m.Cd_Mda=c.Cd_Mda
		left join FormaPC f on f.Cd_FPC=c.Cd_FPC
		left join Cliente2 e on e.RucE=c.RucE and e.Cd_Clt=c.Cd_Clt
		left join Vendedor2 v on v.RucE=c.RucE and v.Cd_Vdr=c.Cd_Vdr
		left join Area a on a.RucE=c.RucE and a.Cd_Area=c.Cd_Area
	    left join Cotizacion o on o.RucE=c.RucE and o.Cd_Cot=c.CdCot_Base
		left join EstadoCot s on s.Id_EstC=c.Id_EstC
		left join CfgAutorizacion cfg on cfg.Cd_DMA = ''CT'' and cfg.tipo = c.tipAut and cfg.RucE = '''+@RucE+''''
declare @Cond varchar(5000)
declare @sql nvarchar(4000)



--Codigo ejemplo de Explorador OP:
--if(@FecD = '' or @FecD is null)
--	begin
--		set @Cond = 'op.RucE= '''+@RucE+''' and op.Cd_OP >'''+isnull(@Ult_CdOP,'')+''''
--	end
--	else
--	begin
--		set @Cond = 'op.RucE= '''+@RucE+''' and op.FecE between '''+Convert(nvarchar,@FecD,103)+''' and '''+
--		Convert(nvarchar,@FecH,103)+''' and op.Cd_OP >'''+isnull(@Ult_CdOP,'')+''''
--	end





if(@Fecd='' or @Fecd is null)
begin 
  set @Cond= '(c.RucE='''+@RucE+''') and c.Cd_Cot > ''' + Convert(nvarchar,isnull(@Ult_CdCot,'')) +''''  		
end 
else 
begin -- num 2
set @Cond = '(c.RucE='''+@RucE+''')  and (c.FecEmi between '''+Convert(nvarchar,@FecD,103)+''' and '''+
		--case when @Dato IS null then Convert(nvarchar,@FecH,103)+''') and c.Cd_Cot > ''' + Convert(nvarchar,isnull(@Ult_CdCot,'')) +''''
		--else
		Convert(nvarchar,@FecH,103)+''') and c.Cd_Cot > ''' + Convert(nvarchar,isnull(@Ult_CdCot,'')) +''''
		--end
end		
	
--print 'esta es la condicion: ' +@Cond




--if(@llamadaOP = 1) set @Cond += ' and ((c.TipAut = 0 or c.TipAut is null) or (c.IB_Aut = 1)) '

if(@Colum = 'Cd_Cot') Set @Cond = ltrim(rtrim(rtrim(ltrim(@Cond)) + ' and c.Cd_Cot like '''+@Dato+''' '))
else if(@Colum = 'NroCot') Set @Cond = ltrim(rtrim(rtrim(ltrim(@Cond)) + ' and c.NroCot like '''+@Dato+''' '))
else if(@Colum = 'FecEmi') Set @Cond = ltrim(rtrim(rtrim(ltrim(@Cond)) + ' and Convert(nvarchar,c.FecEmi,103) like '''+@Dato+''' '))
else if(@Colum = 'FecCad') Set @Cond = ltrim(rtrim(rtrim(ltrim(@Cond)) + ' and Convert(nvarchar,c.FecCad,103) like '''+@Dato+''' '))
else if(@Colum = 'Asunto') Set @Cond = ltrim(rtrim(rtrim(ltrim(@Cond)) + ' and c.Asunto like '''+@Dato+''' '))
else if(@Colum = 'CostoTot') Set @Cond = ltrim(rtrim(rtrim(ltrim(@Cond)) + ' and c.CostoTot like '''+@Dato+''' '))
else if(@Colum = 'Valor') Set @Cond = @Cond + ' and c.Valor like '''+@Dato+''' '
else if(@Colum = 'MU_Imp') Set @Cond = @Cond + ' and c.MU_Imp like '''+@Dato+''' '
else if(@Colum = 'INF') Set @Cond = @Cond + ' and c.INF like '''+@Dato+''' '
else if(@Colum = 'DsctoFnzInf_I') Set @Cond = @Cond + ' and c.DsctoFnzInf_I like '''+@Dato+''' '
else if(@Colum = 'INF_Neto') Set @Cond = @Cond + ' and c.INF_Neto like '''+@Dato+''' '
else if(@Colum = 'BIM') Set @Cond = @Cond + ' and c.BIM like '''+@Dato+''' '
else if(@Colum = 'DsctoFnzAf_I') Set @Cond = @Cond + ' and c.DsctoFnzAf_I like '''+@Dato+''' '
else if(@Colum = 'BIM_Neto') Set @Cond = @Cond + ' and c.BIM_Neto like'''+@Dato+''' '
else if(@Colum = 'IGV') Set @Cond = @Cond + ' and c.IGV like '''+@Dato+''' '
else if(@Colum = 'Total') Set @Cond = @Cond + ' and c.Total like '''+@Dato+''' '
else if(@Colum = 'Simbolo') Set @Cond = @Cond + ' and s.Simbolo like '''+@Dato+''' '
else if(@Colum = 'CamMda') Set @Cond = @Cond + ' and c.CamMda like '''+@Dato+''' '
else if(@Colum = 'NomFPC') Set @Cond = @Cond + ' and f.Nombre like '''+@Dato+''' '
--else if(@Colum = 'Cd_TDICli') Set @Cond = @Cond + ' and e.Cd_TDI like '+''''+@D+''+@Dato+''+@I+''''
--else if(@Colum = 'NroCli') Set @Cond = @Cond + ' and e.NroCli like '+''''+@D+''+@Dato+''+@I+''''
--Dscomentado
else if(@Colum = 'NomCli') Set @Cond = @Cond + ' and (e.RSocial like '+''''+@Dato+''' or isnull(e.ApPat,'''')+'' ''+isnull(e.ApMat,'''')+'' ''+isnull(e.Nom,'''') like '''+@Dato+''' )'
--Descomentado
else if(@Colum = 'Cd_TDIVdr') Set @Cond = @Cond + ' and v.Cd_TDI like '''+@Dato+''' '
else if(@Colum = 'NroVdr') Set @Cond = @Cond + ' and v.NDoc like '''+@Dato+''' '
else if(@Colum = 'NomVdr') Set @Cond = @Cond + ' and isnull(v.ApPat,'''')+'' ''+isnull(v.ApMat,'''')+'' ''+isnull(v.Nom,'''') like '''+@Dato+''' '
else if(@Colum = 'NCortoArea') Set @Cond = @Cond + ' and a.NCorto like '''+@Dato+''' '
else if(@Colum = 'Obs') Set @Cond = @Cond + ' and c.Obs like '''+@Dato+''' '
else if(@Colum = 'NroCotBase') Set @Cond = @Cond + ' and o.NroCot like '''+@Dato+''' '
else if(@Colum = 'FecReg') Set @Cond = @Cond + ' and Convert(nvarchar,c.FecReg,103) like '''+@Dato+''' '
else if(@Colum = 'FecMdf') Set @Cond = @Cond + ' and Convert(nvarchar,c.FecMdf,103) like '''+@Dato+''' '
else if(@Colum = 'UsuCrea') Set @Cond = @Cond + ' and c.UsuCrea like '''+@Dato+''' '
else if(@Colum = 'UsuMdf') Set @Cond = @Cond + ' and c.UsuMdf like '''+@Dato+''' '
else if(@Colum = 'Estado') Set @Cond = @Cond + ' and s.Descrip like '''+@Dato+''' '

declare @Consulta varchar(8000)
set @Consulta='select  top '+Convert(nvarchar,@TamPag)+'
			c.Cd_Cot,
			c.NroCot,
			e.Cd_TDI as Cd_TDICli,e.NDoc as NroCli,isnull(e.RSocial,isnull(e.ApPat,'''')+'' ''+isnull(e.ApMat,'''')+'' ''+isnull(e.Nom,'''')) as NomCli,
			Convert(nvarchar,c.FecEmi,103) as FecEmi,
			Convert(nvarchar,c.FecCad,103) as FecCad,
			c.Asunto,	
			s.Descrip as Estado,			
			isnull(c.CostoTot,0.00) As CostoTot,
			isnull(c.Valor,0.00) As Valor,
			isnull(c.MU_Imp,0.00) As MU_Imp,
			isnull(c.INF,0.00) As INF,
			isnull(c.DsctoFnzInf_I,0.00) As DsctoFnzInf_I,
			isnull(c.INF_Neto,0.00) As INF_Neto,
			isnull(c.BIM,0.00) As BIM,
			isnull(c.DsctoFnzAf_I,0.00) As DsctoFnzAf_I,
			isnull(c.BIM_Neto,0.00) As BIM_Neto,
			isnull(c.IGV,0.00) As IGV,
			isnull(c.Total,0.00) As Total,			
			m.Simbolo,
			 c.CamMda,
			f.Nombre as NomFPC,
			v.Cd_TDI as Cd_TDIVdr,v.NDoc as NroVdr,isnull(v.ApPat,'''')+'' ''+isnull(v.ApMat,'''')+'' ''+isnull(v.Nom,'''') as NomVdr,
			a.NCorto as NCortoArea,
			c.Obs,
			o.NroCot as NroCotBase,
			Convert(nvarchar,c.FecReg,103) as FecReg,
			Convert(nvarchar,c.FecMdf,103) as FecMdf,
			c.UsuCrea,c.UsuMdf, isnull(c.TipAut,0) TipAut, c.AutorizadoPor, isnull(c.IB_Aut, 0) IB_Aut,
			isnull(cfg.DescripTip, ''**No requiere autorizacion**'') as DescripTip,
			c.CA01,c.CA02,c.CA03,c.CA04,c.CA05,c.CA06,c.CA07,c.CA08,c.CA09,c.CA10,c.CA11,c.CA12,c.CA13,c.CA14,c.CA15
		from '+@Inter+
		'where'+@Cond+ ' Order by c.RucE, c.Cd_Cot'
print @Consulta 


	if not exists (select top 1 * from Cotizacion where RucE=@RucE)
		set @msj='No se encontraron Cotizaciones registradas'
	else 
	begin 
		Exec(@Consulta)
			if(@Ult_CdCot is null or @Ult_CdCot = '')
			begin 
			 print @Ult_CdCot
			 set @sql='select @Regs = count(*) from ' +@Inter+ ' where '+@Cond
		
			 exec sp_executesql @sql, N'@Regs int output',@NroRegs output
		    set @NroPags = @NroRegs/@TamPag + case when @NroRegs%@TamPag=0 then 0 else 1 end
		end
		  set @sql = 'select @RMax = max(Cd_Cot) from(select top '+ Convert(nvarchar,@TamPag)+' c.Cd_Cot  from ' + @Inter + ' where ' + @Cond +' order by c.Cd_Cot) as  Cotizacion'
		  exec sp_executesql @sql, N'@RMax char(10) output',@Max output

		  set @sql = 'select top 1 @RMin = c.Cd_Cot from ' + @Inter + ' where ' +@Cond+' order by c.Cd_Cot'
		  exec sp_executesql @sql, N'@RMin char(10) output', @Min output
	end

GO
