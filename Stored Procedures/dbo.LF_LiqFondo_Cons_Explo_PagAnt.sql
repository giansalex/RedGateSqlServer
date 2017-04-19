SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[LF_LiqFondo_Cons_Explo_PagAnt]

@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, 
@Ult_CdLF char(10),
@NroRegs int output,
@NroPags int output,
@Max char(10) output,
@Min char(10) output,
----------------------
@msj varchar(100) output
as

declare @Inter varchar(4000)
set @Inter = 'Liquidacion lq
		left join Area as ar on lq.Cd_Area = ar.Cd_area and lq.RucE = ar.RucE
		left join MtvoIngsal mis on lq.RucE =  mis.RucE and lq.Cd_MIS = mis.Cd_MIS 
		eft join CCostos c on c.RucE = lq.RucE and c.Cd_CC = lq.Cd_CC
	    left join CCSub s on c.RucE = s.RucE and c.Cd_CC = s.Cd_CC and s.Cd_SC = lq.Cd_SC
		left join CCSubSub ss on c.RucE = ss.RucE and c.Cd_CC = ss.Cd_CC and s.Cd_SC = ss.Cd_SC and ss.Cd_SS = lq.Cd_SS '

declare @Cond varchar(4000)
declare @sql nvarchar(4000)

if(@FecD = '' or @FecD is null)
		set @Cond = 'lq.RucE= '''+@RucE+''' and lq.Cd_Liq <'''+isnull(@Ult_CdLF,'')+''''
	else
		set @Cond = 'lq.RucE= '''+@RucE+''' and lq.FechaAper between '''+ Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and lq.Cd_Liq <'''+isnull(@Ult_CdLF,'')+''' and  lq.FechaAper !='''+Convert(nvarchar,@FecH,103)+''''  

if(@Colum = 'Cd_Liq') set @Cond = @Cond+ ' and lq.Cd_Liq like '''+@Dato+''''
else if(@Colum = 'RegCtb') set @Cond = @Cond+ ' and lq.RegCtb like '''+@Dato+''''
else if(@Colum = 'FechaAper') set @Cond = @Cond+' and Convert(nvarchar,lq.FechaAper,103) like '''+@Dato+''''
else if(@Colum = 'FechaCierre') set @Cond = @Cond+' and Convert(nvarchar,lq.FechaCierre,103) like '''+@Dato+''''
else if(@Colum = 'UsuAper') set @Cond = @Cond+' and lq.UsuAper like '''+@Dato+''''
else if(@Colum = 'FecAper') set @Cond = @Cond+' and Convert(nvarchar,lq.FecAper,103) like '''+@Dato+''''
else if(@Colum = 'UsuCierre') set @Cond = @Cond+' and lq.UsuCierre like '''+@Dato+''''
else if(@Colum = 'FecCierre') set @Cond = @Cond+' and  Convert(nvarchar,lq.FecCierre,103) like '''+@Dato+''''
else if(@Colum = 'Cd_Area') set @Cond = @Cond+' and lq.Cd_Area like '''+@Dato+''''
else if(@Colum = 'Cd_CC') set @Cond = @Cond+' and lq.Cd_CC like '''+@Dato+''''
else if(@Colum = 'Cd_SC') set @Cond = @Cond+' and lq.Cd_SC like '''+@Dato+''''
else if(@Colum = 'Cd_SS') set @Cond = @Cond+' and lq.Cd_SS like '''+@Dato+''''
else if(@Colum = 'Cd_MIS') set @Cond = @Cond+' and lq.Cd_MIS like '''+@Dato+''''
else if(@Colum = 'MtoAnt') set @Cond = @Cond+' and lq.MtoAnt like '''+@Dato+''''
else if(@Colum = 'UsuCrea') set @Cond = @Cond+' and lq.UsuCrea like '''+@Dato+''''
else if(@Colum = 'UsuModf') set @Cond = @Cond+' and lq.UsuModf like '''+@Dato+''''
else if(@Colum = 'MtoAsig') set @Cond = @Cond+' and lq.MtoAsig like '''+@Dato+''''
else if(@Colum = 'MtoAper') set @Cond = @Cond+' and lq.MtoAper like '''+@Dato+''''
else if(@Colum = 'MtoCierre') set @Cond = @Cond+' and lq.MtoCierre like '''+@Dato+''''
else if(@Colum = 'CA01') set @Cond = @Cond+' and lq.CA01 like '''+@Dato+''''
else if(@Colum = 'CA02') set @Cond = @Cond+' and lq.CA02 like '''+@Dato+''''
else if(@Colum = 'CA03') set @Cond = @Cond+' and lq.CA03 like '''+@Dato+''''
else if(@Colum = 'CA04') set @Cond = @Cond+' and lq.CA04 like '''+@Dato+''''
else if(@Colum = 'CA05') set @Cond = @Cond+' and lq.CA05 like '''+@Dato+''''
else if(@Colum = 'CA06') set @Cond = @Cond+' and lq.CA06 like '''+@Dato+''''
else if(@Colum = 'CA07') set @Cond = @Cond+' and lq.CA07 like '''+@Dato+''''
else if(@Colum = 'CA08') set @Cond = @Cond+' and lq.CA08 like '''+@Dato+''''
else if(@Colum = 'CA09') set @Cond = @Cond+' and lq.CA09 like '''+@Dato+''''
else if(@Colum = 'CA10') set @Cond = @Cond+' and lq.CA10 like '''+@Dato+''''
else if(@Colum = 'MtoAnt_ME') set @Cond = @Cond+' and lq.MtoAnt_ME like '''+@Dato+''''
else if(@Colum = 'MtoAsig_ME') set @Cond = @Cond+' and lq.MtoAsig_MElike '''+@Dato+''''
else if(@Colum = 'MtoAper_ME') set @Cond = @Cond+' and lq.MtoAper_ME like '''+@Dato+''''
else if(@Colum = 'MtoCierre_ME') set @Cond = @Cond+' and lq.MtoCierre_ME like '''+@Dato+''''


declare @Consulta varchar(8000)
set @Consulta = 'select top '+Convert(nvarchar,@TamPag)+' lq.RucE,lq.Cd_Liq,		
		lq.RegCtb, convert(nvarchar,lq.FechaAper,103) as FechaAper, convert(nvarchar,lq.FechaCierre,103) as  FechaCierre,
		lq.UsuAper,  convert(nvarchar,lq.FecAper,103) as FecAper, lq.UsuCierre, convert(nvarchar,lq.FecCierre,103) as FecCierre,  
		lq.Cd_Area, 
		lq.Cd_CC, lq.Cd_SC, lq.Cd_SS,lq.Cd_MIS, mis.Descrip as nomMIS,
		lq.MtoAnt, lq.MtoAsig, lq.MtoAper, lq.MtoCierre,lq.MtoAnt_ME, lq.MtoAsig_ME, lq.MtoAper_ME, lq.MtoCierre_ME,
		lq.CA01, lq.CA02, lq.CA03, lq.CA04, lq.CA05, lq.CA06, lq.CA07, lq.CA08, lq.CA09, lq.CA10 
		,c.Descrip as nomCC,s.Descrip as nomSC, ss.Descrip as nomSS 
		from '
		+@Inter+' 
		where '+ @Cond+' order by lq.Cd_Liq'

exec (@Consulta)
print  (@Consulta)
if(@Ult_CdLF is null) 
begin
	set @sql= 'select @Regs = count(*) from '+@Inter+ '  where ' + @Cond
	exec sp_executesql @sql, N'@Regs int output', @NroRegs output
	select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
end
set @sql = 'select @RMax = max(Cd_Liq) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Liq from '+@Inter+' where '+@Cond+' order by Cd_Liq) as Liquidacion'
exec sp_executesql @sql, N'@RMax char(10) output', @Max output

set @sql = 'select top 1 @RMin =Cd_Liq from '+@Inter+' where '+@Cond+' order by Cd_Liq'
exec sp_executesql @sql, N'@RMin char(10) output', @Min output
print @sql

-- Leyenda --
-- CE : 18-01-2013 : <Creacion del SP>
--  exec Fab_FabricacionCons_explo_PagSig '11111111111', '01/01/2013', '31/01/2013', null, null, 100, '', null, null, null, null, null
GO
