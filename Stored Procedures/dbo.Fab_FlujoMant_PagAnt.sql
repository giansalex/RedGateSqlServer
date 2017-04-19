SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_FlujoMant_PagAnt]
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
	set @Inter = 'fabflujo fab
		inner join Producto2 pro on pro.Ruce=fab.ruce and pro.Cd_Prod=fab.Cd_Prod 
		inner join Prod_UM ump on ump.Ruce=fab.ruce and ump.ID_UMP=fab.ID_UMP and ump.Cd_prod=pro.Cd_prod '
	set @Cond = 'fab.RucE='''+@RucE +''' and Cd_Flujo < '''+isnull(@Ult_CdClt,'') +''''
	if(@Colum = 'Cd_Flujo') set @Cond = @Cond+ ' and fab.Cd_Flujo like '''+@Dato+''''
	else if(@Colum = 'Nombre') set @Cond = @Cond+ ' and vnd.NDoc like '''+@Dato+''''
	else if(@Colum = 'Descrip') set @Cond = @Cond+ ' and vnd.RSocial like '''+@Dato+''''
	else if(@Colum = 'Cd_prod') set @Cond = @Cond+ ' and vnd.ApPat like '''+@Dato+''''
	else if(@Colum = 'ID_UMP') set @Cond = @Cond+ ' and vnd.ApMat like '''+@Dato+''''
	else if(@Colum = 'Nom') set @Cond = @Cond+ ' and vnd.Nom like '''+@Dato+''''
	else if(@Colum = 'CodPost') set @Cond = @Cond+ ' and vnd.CodPost like '''+@Dato+''''	

	set @Consulta ='		select top '+Convert(nvarchar,@TamPag)+'
		fab.Ruce,
		fab.Cd_Flujo,
		fab.Nombre,
		fab.Descrip,
		fab.Cd_Prod,
		pro.Nombre1 as NomProducto,
		fab.ID_UMP,
		ump.DescripAlt as UMP,		
		fab.CA01,
		fab.CA02,
		fab.CA03,
		fab.CA04,
		fab.CA05,
		fab.CA06,
		fab.CA07,
		fab.CA08,
		fab.CA09,
		fab.CA10 		
	from '+@Inter+'
	where '+@Cond+'
	order by fab.RucE, Cd_Flujo'
print @Consulta
	Exec (@Consulta)

	if (isnull(@Ult_CdClt,'')='') -- si es primera pagina y primera busqueda
	begin
		set @sql= 'select @Regs = count(*) from '+@Inter+ '
			where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
	end

	set @sql = 'select @RMax = max(Cd_Flujo) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Flujo from '+@Inter+'
		where '+@Cond+' order by fab.RucE, Cd_Flujo
		) as Flujo'
	exec sp_executesql @sql, N'@RMax char(10) output', @Max output
	
	set @sql = 'select top 1 @RMin =Cd_Flujo from '+@Inter+'
		where '+@Cond+'
		order by fab.RucE, Cd_Flujo'
	exec sp_executesql @sql, N'@RMin char(10) output', @Min output

/*
----------------------------------------------------------------------------------------------------
--exec Fab_FlujoMant_PagAnt '11111111111',null,null,3,null,null,null,null,null,null

CE : 11/12/2012
*/


GO
