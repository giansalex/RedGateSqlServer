SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Inv_Serial_Explo_PagAnt]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
------------------------
@TamPag int,
@Ult_Sig char(107),
@Max char(107) output,
@Min char(107) output,
-------------------------
@msj varchar(100) output
as

	declare @Inter varchar(4000)

	set @Inter='user321.VSerial_Explorador'
		print @Inter
	declare @Cond varchar(4000)
	declare @sql nvarchar(4000)

	set @Cond='RucE='''+@RucE+''' and FecIng between '''+ Convert(varchar,@FecD,103)+''' and '''+ Convert(varchar,@FecH,103)
		+''' and siguient <'''+isnull(@Ult_Sig,'')+''''
		print @Cond
	if(@Colum = 'Cd_Prod') set @Cond=@Cond+' and Cd_Prod like '''+@Dato+''''
	else if(@Colum='Producto') set @Cond=@Cond+' and Producto like '''+@Dato+''''
	else if(@Colum='Serial') set @Cond=@Cond+' and Serial like '''+@Dato+''''
	else if(@Colum='Lote') set @Cond=@Cond+' and Lote like '''+@Dato+''''
	else if(@Colum='Cd_AlmAct') set @Cond=@Cond+' and Cd_AlmAct like '''+@Dato+''''
	else if(@Colum='CodAlm') set @Cond=@Cond+' and CodAlm like '''+@Dato+''''
	else if(@Colum='Almacen') set @Cond=@Cond+' and Almacen like '''+@Dato+''''
	else if(@Colum='FecIng') set @Cond=@Cond+' and FecIng like '''+@Dato+''''
	else if(@Colum='FecSal') set @Cond=@Cond+' and FecSal like '''+@Dato+''''
	
	declare @Consulta varchar(4000)
	Set @Consulta =' Select *from (
		select top '+Convert(nvarchar,@TamPag)+'
		Cd_Prod,Producto,Serial,Lote,Cd_AlmAct,CodAlm,Almacen,FecIng,FecSal,Siguient
		from '+@Inter+ ' Where '+@Cond +' Order by Siguient Desc) as Serial Order by Siguient'

	Print @Consulta
	exec(@Consulta)

	set @sql = '
		      select top 1 @RMax =Siguient from '+@Inter+' where  '+@Cond+' order by Siguient desc'
	exec sp_executesql @sql, N'@RMax char(107) output', @Max output
	print @sql
	set @sql = '
		      select @RMin = min(Siguient) from(select top '+Convert(nvarchar,@TamPag)+' Siguient from '+@Inter+' where  '+@Cond+' order by Siguient desc) as Serial'
	exec sp_executesql @sql, N'@RMin char(107) output', @Min output
	print @sql

/*
select *from user321.VSerial_Explorador 
order by Cd_Prod, Serial

select *from Serial
select *from SerialMov
exec Inv_Serial_Explo_PagAnt '11111111111','01/03/2010','31/03/2011',null,null,2,'PD00084A0001',null,null,null
*/




GO
