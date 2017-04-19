SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Almacen_PagSig]
@RucE nvarchar(11),
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --Tamaño Pagina
@Ult_CdAlm char(7),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(7) output,
@Min char(7) output,
---------------------------
			
----------------------
@msj varchar(100) output
as
	declare @Inter varchar(1000)
	declare @Cond varchar(1000)
	declare @sql nvarchar(1000)
	declare @Consulta  nvarchar(4000)


	set @Inter = 'Almacen as a1 
		left join Almacen a2 On a2.RucE=a1.RucE and 
		left(a2.Cd_Alm,len(a1.Cd_Alm)) = a1.Cd_Alm and 
		len(a2.Cd_Alm)=len(a1.Cd_Alm)+2'
	set @Cond = 'a1.RucE='''+@RucE +''' and len(a1.Cd_Alm) = 3 and a1.Cd_Alm > '''+isnull(@Ult_CdAlm,'') +''''
	if(@Colum = 'CodAlma') set @Cond = @Cond+ ' and a1.Cd_Alm like '''+@Dato+''''
	else if(@Colum = 'Codigo') set @Cond = @Cond+ ' and a1.Codigo like '''+@Dato+''''
	else if(@Colum = 'Nombre') set @Cond = @Cond+ ' and a1.Nombre like '''+@Dato+''''
	else if(@Colum = 'NCorto') set @Cond = @Cond+ ' and a1.NCorto like '''+@Dato+''''
	else if(@Colum = 'Ubigeo') set @Cond = @Cond+ ' and a1.Ubigeo like '''+@Dato+''''
	else if(@Colum = 'Direccion') set @Cond = @Cond+ ' and a1.Direccion like '''+@Dato+''''
	else if(@Colum = 'Encargado') set @Cond = @Cond+ ' and a1.Encargado like '''+@Dato+''''
	else if(@Colum = 'Telefono') set @Cond = @Cond+ ' and a1.Telef like '''+@Dato+''''
	else if(@Colum = 'Capacidad') set @Cond = @Cond+ ' and a1.Capacidad like '''+@Dato+''''
	else if(@Colum = 'Observacion') set @Cond = @Cond+ ' and a1.Obs like '''+@Dato+''''
	else if(@Colum = 'Stado') set @Cond = @Cond+ ' and a1.Estado like '''+@Dato+''''
	else if(@Colum = 'Cargo') set @Cond = @Cond+ ' and a1.Cargo like '''+@Dato+''''
	else if(@Colum = 'Estado') set @Cond = @Cond+ ' and a1.Estado like '''+@Dato+''''
	else if(@Colum = 'Hijo') set @Cond = @Cond+ ' and a1.Hijo like '''+@Dato+''''

	set @Consulta ='		select top '+Convert(nvarchar,@TamPag)+'
		a1.RucE,
		a1.Cd_Alm,
		a1.Codigo,
		a1.Nombre,
		a1.NCorto, 
		a1.Ubigeo,
		a1.Direccion,
		a1.Encargado,
		a1.Telef,
		a1.Capacidad,
		a1.Obs, 
		a1.Estado,
		count(a2.Cd_Alm) as Hijo
	from '+@Inter+'
	where '+@Cond+'
	group by a1.RucE,a1.Cd_Alm,a1.Codigo,a1.Nombre,a1.NCorto, a1.Ubigeo,a1.Direccion,a1.Encargado,a1.Telef,a1.Capacidad,a1.Obs, a1.Estado'
print @Consulta
	Exec (@Consulta)

	if (isnull(@Ult_CdAlm,'')='') -- si es primera pagina y primera busqueda
	begin
		set @sql= 'select @Regs = count(*) from '+@Inter+ '
			where ' + @Cond
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
	end

	--set @sql = 'select @RMax = max(a1.Cd_Alm) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Alm from '+@Inter+'
		--where '+@Cond+ 'order by Cd_Alm asc
	          --  ) as Almacen'
	--print @sql

	--exec sp_executesql @sql, N'@RMax char(7) output', @Max output
		--		print 'maximo : '+ @Max
	--set @sql = 'select top 1 @RMin =a1.Cd_Alm from '+@Inter+'
		--where '+@Cond+'
		--order by a1.RucE, a1.Cd_Alm'
	--exec sp_executesql @sql, N'@RMin char(7) output', @Min output
		--		print 'minimo : '+@Min
----------------------------------------------------------------------------------------------------
-- Leyenda --
-- CAM 04/10/2010 Creado.

--exec Inv_Almacen_PagSig '11111111111',null,null,10,null,null,null,null,null,null


GO
