SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_Cliente2Mant_PagSig]
@RucE nvarchar(11),
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --TamaÃ±o Pagina
@Ult_CdClt char(10),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(10) output,
@Min char(10) output,

----------------------
@msj varchar(100) output
as 
	declare @Inter varchar(1000)
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	declare @Consulta  nvarchar(4000)
	set @Inter = 'Cliente2 vnd
		left join TipDocIdn tdi on tdi.Cd_TDI=vnd.Cd_TDI'
	set @Cond = 'vnd.RucE='''+@RucE +''' and Cd_Clt > '''+isnull(@Ult_CdClt,'') +''''
	if(@Colum = 'Cd_Clt') set @Cond = @Cond+ ' and vnd.Cd_Clt like '''+@Dato+''''
	else if(@Colum = 'NCorto') set @Cond = @Cond+ ' and tdi.NCorto like '''+@Dato+''''
	else if(@Colum = 'NDoc') set @Cond = @Cond+ ' and vnd.NDoc like '''+@Dato+''''
	else if(@Colum = 'RSocial') set @Cond = @Cond+ ' and vnd.RSocial like '''+@Dato+''''
	else if(@Colum = 'ApPat') set @Cond = @Cond+ ' and vnd.ApPat like '''+@Dato+''''
	else if(@Colum = 'ApMat') set @Cond = @Cond+ ' and vnd.ApMat like '''+@Dato+''''
	else if(@Colum = 'Nom') set @Cond = @Cond+ ' and vnd.Nom like '''+@Dato+''''
	else if(@Colum = 'CodPost') set @Cond = @Cond+ ' and vnd.CodPost like '''+@Dato+''''
	else if(@Colum = 'Ubigeo') set @Cond = @Cond+ ' and vnd.Ubigeo like '''+@Dato+''''
	else if(@Colum = 'Direc') set @Cond = @Cond+ ' and vnd.Direc like '''+@Dato+''''
	else if(@Colum = 'Telf1') set @Cond = @Cond+ ' and vnd.Telf1 like '''+@Dato+''''
	else if(@Colum = 'Telf2') set @Cond = @Cond+ ' and vnd.Telf2 like '''+@Dato+''''
	else if(@Colum = 'Correo') set @Cond = @Cond+ ' and vnd.Correo like '''+@Dato+''''
	else if(@Colum = 'Estado') set @Cond = @Cond+ ' and vnd.Estado like '''+@Dato+''''
	else if(@Colum = 'FecMdf') set @Cond = @Cond+ ' and vnd.FecMdf like '''+@Dato+''''
	else if(@Colum = 'FecReg') set @Cond = @Cond+ ' and vnd.FecReg like '''+@Dato+''''
	else if(@Colum = 'UsuCrea') set @Cond = @Cond+ ' and vnd.UsuCrea like '''+@Dato+''''
	else if(@Colum = 'UsuMdf') set @Cond = @Cond+ ' and vnd.UsuMdf like '''+@Dato+''''
	else if(@Colum = 'NComercial') set @Cond = @Cond+ ' and vnd.NComercial like '''+@Dato+''''

	set @Consulta ='		select top '+Convert(nvarchar,@TamPag)+'
		vnd.RucE,
		vnd.Cd_Clt,tdi.NCorto,vnd.NDoc,vnd.RSocial,vnd.ApPat,
		vnd.ApMat,vnd.Nom,vnd.Cd_Pais,vnd.CodPost,vnd.Ubigeo,
		vnd.Direc,
		vnd.Telf1,
		vnd.Telf2,
		vnd.Fax,
		vnd.Correo,
		vnd.PWeb,
		vnd.Obs,
		vnd.CtaCtb,
		vnd.DiasCbr,
		vnd.PerCbr,
		vnd.CtaCte,
		vnd.Cd_CGC,
		vnd.Estado,
		vnd.CA01,
		vnd.CA02,
		vnd.CA03,
		vnd.CA04,
		vnd.CA05,
		vnd.CA06,
		vnd.CA07,
		vnd.CA08,
		vnd.CA09,
		vnd.CA10,
		vnd.UsuCrea,
        vnd.UsuMdf,
        vnd.FecReg,
        vnd.FecMdf,
        vnd.NComercial
	from '+@Inter+'
	where '+@Cond+'
	order by vnd.RucE, Cd_Clt'
print @Consulta
	Exec (@Consulta)

	if (isnull(@Ult_CdClt,'')='') -- si es primera pagina y primera busqueda
	begin
		set @sql= 'select @Regs = count(*) from '+@Inter+ '
			where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
	end

	set @sql = 'select @RMax = max(Cd_Clt) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Clt from '+@Inter+'
		where '+@Cond+' order by vnd.RucE, Cd_Clt
		) as Cliente2'
	exec sp_executesql @sql, N'@RMax char(10) output', @Max output
	
	set @sql = 'select top 1 @RMin =Cd_Clt from '+@Inter+'
		where '+@Cond+'
		order by vnd.RucE, Cd_Clt'
	exec sp_executesql @sql, N'@RMin char(10) output', @Min output

/*
----------------------------------------------------------------------------------------------------
--exec Inv_Cliente2_PagSig '11111111111',null,null,3,null,null,null,null,null,null
------------------------
Ejemplo de Prueba
------------------------
exec dbo.Ctb_Cliente2Mant_PagSig '11111111111',0,100,'',1456,15,'CLT0082','AUX0001',null

------------------------
Ejemplo de Prueba con data masiva
------------------------
exec dbo.Ctb_Cliente2Mant_PagSig '11111111111',null,null,5,'',0,0,null,null,null  -- demora 0.00:01s

Autor : MP -> Modificado 04-10-2010 -> PAGINACION

LA : 14/11/2011  modificacion 		vnd.UsuCrea, vnd.UsuMdf, vnd.FecReg, vnd.FecMdf 

*/


GO
