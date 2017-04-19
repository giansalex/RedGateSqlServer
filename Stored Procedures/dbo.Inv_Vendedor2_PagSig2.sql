SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Vendedor2_PagSig2]
@RucE nvarchar(11),
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --Tamaño Pagina
@Ult_CdVdr char(7),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(7) output,
@Min char(7) output,

----------------------
@msj varchar(100) output
as
	declare @Inter varchar(1000)
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	declare @Consulta  nvarchar(4000)
	set @Inter = 'Vendedor2 vnd
		left join TipDocIdn tdi on tdi.Cd_TDI=vnd.Cd_TDI
		left join ComisionGrupVdr cgv on cgv.Cd_CGV= vnd.Cd_CGV 
		left join CarteraProd ct on ct.Cd_Ct=vnd.Cd_Ct and ct.RucE=vnd.RucE'
	set @Cond = 'vnd.RucE='''+@RucE +''' and Cd_Vdr > '''+isnull(@Ult_CdVdr,'') +''''
	if(@Colum = 'Cd_Vdr') set @Cond = @Cond+ ' and vnd.Cd_Vdr like '''+@Dato+''''
	else if(@Colum = 'NCorto') set @Cond = @Cond+ ' and tdi.NCorto like '''+@Dato+''''
	else if(@Colum = 'NDoc') set @Cond = @Cond+ ' and vnd.NDoc like '''+@Dato+''''
	else if(@Colum = 'RSocial') set @Cond = @Cond+ ' and vnd.RSocial like '''+@Dato+''''
	else if(@Colum = 'ApPat') set @Cond = @Cond+ ' and vnd.ApPat like '''+@Dato+''''
	else if(@Colum = 'ApMat') set @Cond = @Cond+ ' and vnd.ApMat like '''+@Dato+''''
	else if(@Colum = 'Nom') set @Cond = @Cond+ ' and vnd.Nom like '''+@Dato+''''
	else if(@Colum = 'Ubigeo') set @Cond = @Cond+ ' and vnd.Ubigeo like '''+@Dato+''''
	else if(@Colum = 'CGVDesc') set @Cond = @Cond+ ' and cgv.Descrip like '''+@Dato+''''
	else if(@Colum = 'CtDesc') set @Cond = @Cond+ ' and ct.Descrip like '''+@Dato+''''
	else if(@Colum = 'Direc') set @Cond = @Cond+ ' and vnd.Direc like '''+@Dato+''''
	else if(@Colum = 'Telf1') set @Cond = @Cond+ ' and vnd.Telf1 like '''+@Dato+''''
	else if(@Colum = 'Telf2') set @Cond = @Cond+ ' and vnd.Telf2 like '''+@Dato+''''
	else if(@Colum = 'Correo') set @Cond = @Cond+ ' and vnd.Correo like '''+@Dato+''''
	else if(@Colum = 'Cargo') set @Cond = @Cond+ ' and vnd.Cargo like '''+@Dato+''''
	else if(@Colum = 'Estado') set @Cond = @Cond+ ' and vnd.Estado like '''+@Dato+''''

	set @Consulta ='		select top '+Convert(nvarchar,@TamPag)+'
		vnd.RucE,
		vnd.Cd_Vdr,tdi.NCorto,vnd.NDoc,vnd.ApPat,
		vnd.ApMat,vnd.Nom,vnd.Ubigeo,
		cgv.Descrip as CGVDesc,
		ct.Descrip as CtDesc,
		vnd.Direc,
		vnd.Telf1,
		vnd.Telf2,
		vnd.Correo,
		vnd.Cargo,
		vnd.Estado,
		vnd.UsuCrea,
		vnd.FecReg,
		vnd.UsuMdf,
		vnd.FecMdf
	from '+@Inter+'
	where '+@Cond+'
	order by vnd.RucE, Cd_Vdr'
print @Consulta
	Exec (@Consulta)

	if (isnull(@Ult_CdVdr,'')='') -- si es primera pagina y primera busqueda
	begin
		set @sql= 'select @Regs = count(*) from '+@Inter+ '
			where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
	end

	set @sql = 'select @RMax = max(Cd_Vdr) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Vdr from '+@Inter+'
		where '+@Cond+ 'order by Cd_Vdr asc
	            ) as Vendedor2'
	print @sql

	exec sp_executesql @sql, N'@RMax char(7) output', @Max output
				print 'maximo : '+ @Max
	set @sql = 'select top 1 @RMin =Cd_Vdr from '+@Inter+'
		where '+@Cond+'
		order by vnd.RucE, Cd_Vdr'
	exec sp_executesql @sql, N'@RMin char(7) output', @Min output
				print 'minimo : '+@Min
----------------------------------------------------------------------------------------------------
-- Leyenda --
-- CAM 04/10/2010 Creado.

--exec Inv_Vendedor2_PagSig '11111111111',null,null,3,null,null,null,null,null,null
GO
