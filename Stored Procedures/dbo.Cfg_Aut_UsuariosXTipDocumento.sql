SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Cfg_Aut_UsuariosXTipDocumento]
@RucE nvarchar(11),
@TipoDoc int,
@Cd_Doc varchar(4000),
@msj varchar(100) output
/*
set @RucE = '11111111111'
set @TipoDoc = 0
set @Cd_Doc = '''OC00000202'',''OC00000205'',''OC00000207'''
set @TipAut = 15
set @NivPendiente = ''
set @msj  = ''
print @cd_doc
*/ 
as
declare @Tabla varchar(15)
declare @CdDMA char(2)
declare @Campo varchar(10)
declare @Cadena nvarchar(1000)
declare @TablaMov varchar(20)
-----------------------------------------------
if(@TipoDoc = 0)
begin
	set @Tabla = 'AutOC'
	set @Campo = 'Cd_OC'
	set @CdDMA = 'OC'
	set @TablaMov = 'OrdCompra'
end
else if(@TipoDoc = 1)
begin
	set @Tabla = 'AutOP'
	set @Campo = 'Cd_OP'
	set @CdDMA = 'OP'	
end
else if(@TipoDoc = 2)
begin
	set @Tabla = 'AutSC'
	set @Campo = 'Cd_SCo'
	set @CdDMA = 'SC'
end
else if(@TipoDoc = 3)
begin
	set @Tabla = 'AutSR'
	set @Campo = 'Cd_SR'
	set @CdDMA = 'SR'
end
else if(@TipoDoc = 4)
begin
	set @Tabla = 'AutOF'
	set @Campo = 'Cd_OF'
	set @CdDMA = 'OF'
end
else if(@TipoDoc = 5)
begin
	set @Tabla = 'AutCot'
	set @Campo = 'Cd_Cot'
	set @CdDMA = 'CT'
end
-----------------------------------------------
set @Cadena = 'select tm.'+@campo+', usu.NomComp, niv.Niv, Convert(nvarchar,aut.FecAut,103) as FecAut
	from '+@TablaMov+' tm
	join '+@Tabla+' aut on aut.RucE = tm.RucE and aut.'+@campo+' = tm.'+@campo+'
	join CfgAutorizacion cf on cf.RucE = aut.RucE and cf.Tipo = tm.TipAut and cf.Cd_DMA = '''+@CdDMA+'''
	join CfgNivelAut niv on niv.Id_Aut = cf.Id_Aut
	join CfgAutsXUsuario autU on autU.Id_Niv = niv.Id_Niv
	join Usuario usu on usu.NomUsu = aut.NomUsu and usu.NomUsu = autU.NomUsu
	where tm.RucE = '''+@RucE+''' and tm.'+@campo+' in ('+@Cd_Doc+') 
	order by tm.'+@campo+''
	
print @cadena
exec (@Cadena)



GO
