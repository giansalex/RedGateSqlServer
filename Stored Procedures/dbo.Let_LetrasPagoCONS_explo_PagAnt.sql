SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Let_LetrasPagoCONS_explo_PagAnt]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
--------------------------------------
@TamPag int, --Tamano Pagina
@Ult_CdCnj char(10),
@NroRegs int output,--Nro de Registros solo es consultado la primera vez
@NroPags int output,--Nro de Paginas solo es Consulado la primera vez
@Max char(10) output,
@Min char(10) output,
--------------------------------------
@msj varchar(100) output

as
set language 'spanish'
	declare @Inter varchar(2000)

	--Interseccion
		set @Inter = 'Canje Can inner join Area Ar on Ar.Cd_Area = Can.Cd_Area and Can.RucE = Ar.RucE
				inner join Proveedor2 Clt on Clt.Cd_Prv=Can.Cd_Prv and Can.RucE = Clt.RucE
				inner join Moneda Mda on Mda.Cd_Mda = Can.Cd_Mda
				Left Join(	Select d.RucE,c.Cd_Cnj As Padre,Max(d.Cd_Cnj) As Hijo,convert(bit,isnull(c2.IB_Anulado,0)) As HijoAnulado
							From CanjePagoDet d Left Join Letra_Pago l On l.RucE=d.RucE and l.Cd_Ltr=d.Cd_Ltr Left Join CanjePago c On c.RucE=l.RucE and c.Cd_Cnj=l.Cd_Cnj Left Join CanjePago c2 On c2.RucE=d.RucE and c2.Cd_Cnj=d.Cd_Cnj
							Where d.RucE='''+@RucE+''' and isnull(c.Cd_Cnj,'''')<>'''' and convert(bit,isnull(c2.IB_Anulado,0))=0 Group by d.RucE,c.Cd_Cnj,convert(bit,isnull(c2.IB_Anulado,0))) l1 On l1.RucE=Can.RucE and l1.Padre=Can.Cd_Cnj	
				Left Join(	Select d.RucE,c.Cd_Cnj As Padre, d.Cd_Cnj As Hijo,convert(bit,isnull(c.IB_Anulado,0)) As PadreAnulado,convert(bit,isnull(c2.IB_Anulado,0)) As HijoAnulado
							From CanjePagoDet d	Left Join Letra_Pago l On l.RucE=d.RucE and l.Cd_Ltr=d.Cd_Ltr Left Join CanjePago c On c.RucE=l.RucE and c.Cd_Cnj=l.Cd_Cnj	Left Join CanjePago c2 On c2.RucE=d.RucE and c2.Cd_Cnj=d.Cd_Cnj
							Where d.RucE='''+@RucE+''' and isnull(c.Cd_Cnj,'''')<>'''') l2 On l2.RucE=Can.RucE and l2.Hijo=Can.Cd_Cnj
				'
	--print @Inter
	declare @Cond varchar(1000)
	declare @Cond1 varchar(1000)
	declare @sql nvarchar(4000)
	--Condicion
	set @Cond = 'Can.RucE='''+@RucE+''' and Can.FecMov between '''+Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and Can.Cd_Cnj < ''' + Convert(nvarchar,isnull(@Ult_CdCnj,'')) +''''

	if(@Colum = 'Cd_Cnj') set @Cond = @Cond+ ' and Can.Cd_Cnj like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+ ' and Can.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Prdo') set @Cond =@Cond+ ' and Can.Prdo '''+@Dato+''''
	else if(@Colum = 'FecMov') set @Cond=@Cond +' and Convert(nvarchar,Can.FecMov,103) like '''+@Dato+''''
	else if(@Colum = 'Cd_Prv') set @Cond=@Cond +' and Can.Cd_Prv like '''+@Dato+''''
	else if(@Colum = 'Proveedor') set @Cond=@Cond +' and case when Clt.RSocial is not null then Clt.RSocial like ''' + @Dato + ''' else (isnull(Clt.ApPat,'''') +'' ''+ isnull(Clt.ApMat,'''') + '' ''+ isnull(Clt.Nom,'''')) end like '''+@Dato+''''
	else if(@Colum = 'Cd_MIS') set @Cond = @Cond+' and Can.Cd_MIS like '''+@Dato+''''
	else if(@Colum = 'CantLtr') set @Cond=@Cond +' and Abs(Can.CantLtr) like '''+@Dato+''''
	else if(@Colum = 'Total') set @Cond=@Cond +' and Abs(Can.Total) like '''+@Dato+''''
	else if(@Colum = 'Obs') set @Cond = @Cond+' and Can.Obs like '''+@Dato+''''
	else if(@Colum = 'Cd_Area') set @Cond = @Cond+' and Can.Cd_Area like '''+@Dato+''''
	else if(@Colum = 'Area') set @Cond =@Cond+ ' and Ar.Descrip like '''+@Dato+''''	
	else if(@Colum = 'Cd_CC') set @Cond = @Cond+' and Can.Cd_CC like '''+@Dato+''''
	else if(@Colum = 'Cd_SC') set @Cond=@Cond +' and Can.Cd_SC like '''+@Dato+''''
	else if(@Colum = 'Cd_SS') set @Cond=@Cond +' and Can.Cd_SS like '''+@Dato+''''
	--else if(@Colum = 'NDOC_Clt') set @Cond=@Cond +' and  Clt.NDOC like '''+@Dato+''''
	else if(@Colum = 'CA01') set @Cond=@Cond +' and Can.CA01 like '''+@Dato+''''
	else if(@Colum = 'CA02') set @Cond=@Cond +' and Can.CA02 like '''+@Dato+''''
	else if(@Colum = 'CA03') set @Cond=@Cond +' and Can.CA03 like '''+@Dato+''''
	else if(@Colum = 'CA04') set @Cond=@Cond +' and Can.CA04 like '''+@Dato+''''
	else if(@Colum = 'CA05') set @Cond=@Cond +' and Can.CA05 like '''+@Dato+''''	
	else if(@Colum = 'CA06') set @Cond=@Cond +' and Can.CA06 like '''+@Dato+''''
	else if(@Colum = 'CA07') set @Cond=@Cond +' and Can.CA07 like '''+@Dato+''''
	else if(@Colum = 'CA08') set @Cond=@Cond +' and Can.CA08 like '''+@Dato+''''
	else if(@Colum = 'CA09') set @Cond=@Cond +' and Can.CA09 like '''+@Dato+''''
	else if(@Colum = 'CA010') set @Cond=@Cond +' and Can.CA010 like '''+@Dato+''''
	else if(@Colum = 'FecMov') set @Cond=@Cond +' and Convert(nvarchar,Can.FecMov,103) like '''+@Dato+''''
	else if(@Colum = 'UsuCrea') set @Cond=@Cond +' and Can.UsuCrea like '''+@Dato+''''
	else if(@Colum = 'UsuMdf') set @Cond=@Cond +' and Can.UsuMdf like '''+@Dato+''''
	else if(@Colum = 'Moneda') set @Cond=@Cond +' and Mda.Nombre like '''+@Dato+''''
	
	
	declare @Consulta nvarchar(4000)
		set @Consulta='		select top '+convert(nvarchar,@TamPag)+'
				Can.Cd_Cnj, Can.RegCtb, Can.Prdo, Can.FecMov,Can.Cd_Prv,
				case when Clt.RSocial is not null then Clt.RSocial else (isnull(Clt.ApPat,'''') +'' ''+ isnull(Clt.ApMat,'''') + '' ''+ isnull(Clt.Nom,'''')) end as Proveedor,			 
				Can.Cd_MIS, Can.CantLtr, can.Total, Can.Obs, Can.Cd_Area, Ar.Descrip as Area,
				Can.Cd_CC, Can.Cd_SC, Can.Cd_SS,
				Can.CA01, Can.CA02, Can.CA03, Can.CA04, Can.CA05,Can.CA06,Can.CA07,Can.CA08,Can.CA09,Can.CA10,
				Can.FecReg, Can.UsuReg,Can.FecMdf,Can.UsuMdf,convert(bit,isnull(Can.IB_Anulado,0)) AS IB_Anulado,
				Mda.Cd_Mda, Mda.Nombre as NombreMda 
				,Case When isnull(l1.Hijo,'''')<>'''' Then ''0'' Else ''1'' End As pElim
				,Case When isnull(l1.Hijo,'''')='''' and (isnull(l2.Padre,'''')<>'''' and isnull(l2.PadreAnulado,0)=0) Then ''1''
					  Else Case When isnull(l1.Hijo,'''')='''' and isnull(l2.Padre,'''')='''' Then ''1''
								Else Case When isnull(l1.Hijo,'''')<>'''' and isnull(l1.HijoAnulado,0)=1 and isnull(l2.PadreAnulado,0)=0 Then ''1''
										  Else ''0'' End End End As pAnul									  
				from
				' +@Inter+' where 
				'+@Cond + ' order by Can.Cd_Cnj '
				--print @Consulta
	if not exists (select top 1 * from CanjePago where RucE=@RucE)
		set @msj = 'No existe movimientos de Canje.'
	else
	--select top 1 * from Producto2
	  begin
		Exec (@Consulta)
		print @Consulta
		if(@Ult_CdCnj is null) -- si es primera pagina y primera busqueda
		  begin
		    set @sql = 'select @Regs = count(*) from ' +@Inter+ ' where '+@Cond
		    exec sp_executesql @sql, N'@Regs int output',@NroRegs output
		    set @NroPags = @NroRegs/@TamPag + case when @NroRegs%@TamPag=0 then 0 else 1 end
		    --print @sql
		  end
		  set @sql = 'select @RMax = max(Cd_Cnj) from(select top '+ Convert(nvarchar,@TamPag)+' Cd_Cnj  from ' + @Inter + ' where ' + @Cond +' order by Cd_Cnj) as  CanjePago'
		  exec sp_executesql @sql, N'@RMax char(12) output',@Max output

		  set @sql = 'select top 1 @RMin = Cd_Cnj from ' + @Inter + ' where ' +@Cond+' order by Cd_Cnj'
		  exec sp_executesql @sql, N'@RMin char(12) output', @Min output
	end
	
-- Leyenda --
-- Di : 09/04/2012 <Creacion del SP>
 
GO
