SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Fab_FabricacionCons_explo_PagSig]

@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, 
@Ult_CdFab char(10),
@NroRegs int output,
@NroPags int output,
@Max char(10) output,
@Min char(10) output,
----------------------
@msj varchar(100) output
as

declare @Inter varchar(4000)
set @Inter = 'FabFabricacion fb
		left join Producto2 prod on fb.Cd_Prod = prod.Cd_Prod and prod.RucE = fb.RucE
		left join Prod_UM um on um.RucE =  fb.RucE and um.ID_UMP = fb.ID_UMP and um.Cd_Prod = fb.Cd_Prod	
		left join Moneda mon on mon.Cd_Mda = fb.Cd_Mda  
		inner join FabFlujo as fl on fl.RucE=fb.RucE and fl.Cd_Flujo = fb.Cd_Flujo
		left join Cliente2 as cl on cl.RucE=fb.RucE and cl.Cd_Clt = fb.Cd_Clt '

declare @Cond varchar(4000)
declare @sql nvarchar(4000)

--set @Cond = 'ofb.RucE= '''+@RucE+''' and ofb.FecE between '''+Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and ofb.Cd_OF >'''+isnull(@Ult_CdOF,'')+''''
if(@FecD = '' or @FecD is null)
		set @Cond = 'fb.RucE= '''+@RucE+''' and fb.Cd_Fab >'''+isnull(@Ult_CdFab,'')+''''
	else
		set @Cond = 'fb.RucE= '''+@RucE+''' and fb.FecEmi between '''+ Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and fb.Cd_Fab >'''+isnull(@Ult_CdFab,'')+''' and  fb.FecEmi !='''+Convert(nvarchar,@FecH,103)+''''  

if(@Colum = 'Cd_Fab') set @Cond = @Cond+ ' and fb.Cd_Fab like '''+@Dato+''''
else if(@Colum = 'NroFab') set @Cond = @Cond+ ' and fb.NroOF like '''+@Dato+''''
else if(@Colum = 'FecEmi') set @Cond = @Cond+' and Convert(nvarchar,fb.FecEntR,103) like '''+@Dato+''''
else if(@Colum = 'Nombre1') set @Cond = @Cond+' and prod.Nombre1 like '''+@Dato+''''
else if(@Colum = 'Descrip') set @Cond = @Cond+' and prod.Descrip like '''+@Dato+''''
else if(@Colum = 'Cd_Area') set @Cond = @Cond+' and fb.Cd_Area like '''+@Dato+''''
else if(@Colum = 'Cd_Prod') set @Cond = @Cond+' and fb.Cd_Prod like '''+@Dato+''''
else if(@Colum = 'ID_UMP') set @Cond = @Cond+' and fb.ID_UMP like '''+@Dato+''''
else if(@Colum = 'Asunto') set @Cond = @Cond+' and fb.Asunto like '''+@Dato+''''
else if(@Colum = 'Lote') set @Cond = @Cond+' and fb.Lote like '''+@Dato+''''
else if(@Colum = 'Cd_Mda') set @Cond = @Cond+' and fb.Cd_Mda like '''+@Dato+''''
else if(@Colum = 'CamMda') set @Cond = @Cond+' and fb.CamMda like '''+@Dato+''''
else if(@Colum = 'FecReg') set @Cond = @Cond+' and Convert(nvarchar,fb.FecReg,103) like '''+@Dato+''''
else if(@Colum = 'FecMdf') set @Cond = @Cond+' and Convert(nvarchar,fb.FecMdf,103) like '''+@Dato+''''
else if(@Colum = 'UsuCrea') set @Cond = @Cond+' and fb.UsuCrea like '''+@Dato+''''
else if(@Colum = 'UsuModf') set @Cond = @Cond+' and fb.UsuModf like '''+@Dato+''''
else if(@Colum = 'Cd_CC') set @Cond = @Cond+' and fb.Cd_CC like '''+@Dato+''''
else if(@Colum = 'Cd_SC') set @Cond = @Cond+' and fb.Cd_SC like '''+@Dato+''''
else if(@Colum = 'Cd_SS') set @Cond = @Cond+' and fb.Cd_SS like '''+@Dato+''''
else if(@Colum = 'CA01') set @Cond = @Cond+' and fb.CA01 like '''+@Dato+''''
else if(@Colum = 'CA02') set @Cond = @Cond+' and fb.CA02 like '''+@Dato+''''
else if(@Colum = 'CA03') set @Cond = @Cond+' and fb.CA03 like '''+@Dato+''''
else if(@Colum = 'CA04') set @Cond = @Cond+' and fb.CA04 like '''+@Dato+''''
else if(@Colum = 'CA05') set @Cond = @Cond+' and fb.CA05 like '''+@Dato+''''
else if(@Colum = 'CA06') set @Cond = @Cond+' and fb.CA06 like '''+@Dato+''''
else if(@Colum = 'CA07') set @Cond = @Cond+' and fb.CA07 like '''+@Dato+''''
else if(@Colum = 'CA08') set @Cond = @Cond+' and fb.CA08 like '''+@Dato+''''
else if(@Colum = 'CA09') set @Cond = @Cond+' and fb.CA09 like '''+@Dato+''''
else if(@Colum = 'CA10') set @Cond = @Cond+' and fb.CA10 like '''+@Dato+''''
else if(@Colum = 'NomProd') set @Cond = @Cond+' and prod.Nombre1 like '''+@Dato+''''
else if(@Colum = 'DescripProd') set @Cond = @Cond+' and prod.Descrip like '''+@Dato+''''
else if(@Colum = 'DescripUMP') set @Cond = @Cond+' and um.DescripAlt like '''+@Dato+''''
else if(@Colum = 'Moneda') set @Cond = @Cond+' and mon.Nombre like '''+@Dato+''''


declare @Consulta varchar(8000)
set @Consulta = 'select top '+Convert(nvarchar,@TamPag)+' convert(bit,0) As Sel, fb.RucE,fb.Cd_Clt,
		-- cl.RSocial,
		case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat +  '''' + cl.ApMat + '','' + cl.Nom else cl.RSocial end as NomCli,
		fb.Cd_Fab, fb.NroFab, fb.Cd_Flujo, fl.Nombre as NomFlujo,  convert(nvarchar,fb.FecEmi,103) as FecEmi, 
		convert(nvarchar,fb.FecReq,103) as FecReq, fb.Asunto, fb.Obs as ObsFab, fb.Lote, fb.Cd_Prod, prod.Nombre1 as NomProd, 
		prod.Descrip as DescripProd, fb.ID_UMP,fb.Cant, um.DescripAlt as DescripUMP, 
		fb.Cd_Mda, mon.Nombre as Moneda, fb.CamMda, 
		convert(nvarchar,fb.FecReg,103) as FecReg, fb.UsuCrea, convert(nvarchar,fb.FecMdf,103) as FecMdf, fb.UsuModf, 
		fb.Cd_CC, fb.Cd_SC, fb.Cd_SS, fb.CA01, fb.CA02, fb.CA03, fb.CA04, fb.CA05, fb.CA06, fb.CA07, fb.CA08, fb.CA09, fb.CA10 
		from '
		+@Inter+' 
		where '+ @Cond+' order by fb.Cd_Fab'

exec (@Consulta)
print  (@Consulta)
if(@Ult_CdFab is null) 
begin
	set @sql= 'select @Regs = count(*) from '+@Inter+ '  where ' + @Cond
	exec sp_executesql @sql, N'@Regs int output', @NroRegs output
	select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
end
set @sql = 'select @RMax = max(Cd_Fab) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Fab from '+@Inter+' where '+@Cond+' order by Cd_Fab) as FabFabricacion'
exec sp_executesql @sql, N'@RMax char(10) output', @Max output

set @sql = 'select top 1 @RMin =Cd_Fab from '+@Inter+' where '+@Cond+' order by Cd_Fab'
exec sp_executesql @sql, N'@RMin char(10) output', @Min output
print @sql

-- Leyenda --
-- CE : 18-01-2013 : <Creacion del SP>
--  exec Fab_FabricacionCons_explo_PagSig '11111111111', '01/03/2013', '31/03/2013', null, null, 100, '', null, null, null, null, null
GO
