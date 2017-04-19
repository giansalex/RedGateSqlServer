SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_ConsultarAutorizacion]
@RucE nvarchar (11),
@Cd_Doc char(10),
@NomUsu nvarchar(10),
@tipo int,
@TipoDoc int,
@Cd_DMA char (2),
@msj varchar (100) output

as
----------------------------------------
declare @idNivel int 
declare @idAut int 
declare @IB_AutComNiv bit
----------------------------------------
declare @Niv int
declare @Tabla varchar(10)
declare @Tabla2 varchar (20)
declare @Campo varchar(10)
declare @Cadena nvarchar(200)
declare @cont int
----------------------------------------
if(@TipoDoc = 0)
begin
	set @Tabla = 'AutOC'
	set @Tabla2 = 'OrdCompra'
	set @Campo = 'Cd_OC'
end
else if(@TipoDoc = 1)
begin
	set @Tabla = 'AutOP'
	set @Tabla2 = 'OrdPedido'
	set @Campo = 'Cd_OP'
end
else if(@TipoDoc = 2)
begin
	set @Tabla = 'AutSC'
	set @Tabla2 = 'SolicitudCom'
	set @Campo = 'Cd_SCo'
end
else if(@TipoDoc = 3)
begin
	set @Tabla = 'AutSR'
	set @Tabla2 = 'SolicitudReq'
	set @Campo = 'Cd_SR'
end
else if(@TipoDoc = 4)
begin
	set @Tabla = 'AutOF'
	set @Tabla2 = 'OrdFabricacion'
	set @Campo = 'Cd_OF'
end
else if(@TipoDoc = 5)
begin
	set @Tabla = 'AutCot'
	set @Tabla2 = 'Cotizacion'
	set @Campo = 'Cd_Cot'
end
----------------------------------------
if not exists (select * from Empresa where Ruc = @RucE)
begin
	set @msj = 'No existe la empresa'
	print @msj
	return
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if not exists (select * from cfgAutorizacion where Tipo = @tipo)
begin
	set @msj = 'No existe el tipo de autorizacion'
	print @msj
	return
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
set @Cadena = 'select @contador = count(*) from '+@Tabla2+' where RucE = '''+@RucE+''' and '+@Campo+' = '''+@Cd_Doc+''''
exec sp_executesql @Cadena, N'@contador int output', @cont output
if(@cont=0)
begin
	set @msj = 'No existe el documento'
	print @msj
	return	
end
--------------------------------------------------------------------------------------------------------------------------------------------
/*if not exists (select * from CfgAutsXUsuario where NomUsu = @NomUsu and Id_Niv = @idNivel)
begin
	set @msj = 'No tiene permisos para autorizar este documento'	
	print @msj
	return
end*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
set @Cadena = 'select @contador = count(*) from '+@Tabla+' where RucE ='''+@RucE+''' and '+@Campo+' = '''+@Cd_Doc+''' and NomUsu = '''+@NomUsu+''''
exec sp_executesql @Cadena, N'@contador int output', @cont output
if(@cont>0)
begin
	set @msj = 'Ya autorizo este documento'
	print @msj
	return
end

select @idAut = c.Id_Aut, @idNivel = a.Id_Niv, @Niv = b.Niv from CfgAutsXUsuario a
join CfgNivelAut b on a.Id_Niv = b.Id_Niv and NomUsu = @NomUsu
join CfgAutorizacion c on c.Id_Aut = b.Id_Aut and c.Tipo = @tipo and Cd_DMA = @Cd_DMA and RucE = @RucE
if not exists (select * from CfgAutsXUsuario where NomUsu = @NomUsu and Id_Niv = @idNivel)
begin
	set @msj = 'Usuario no esta asignado para autorizar este tipo de documento'	
	print @msj
	return
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if(@Niv>1)
begin
	--Verificar si hay algun usuario del nivel anterior
	select @idNivel = (Id_Niv) from CfgNivelAut where Id_Aut = @idAut and Niv = (@Niv -1)
	select @IB_AutComNiv = IB_AutComNiv from CfgNivelAut where Id_Aut = @idAut and Id_Niv = @idNivel
	if(dbo.verificarAutNvlAnt(@RucE, @Cd_Doc, @idNivel, @IB_AutComNiv, @TipoDoc) = 0)
	begin
		set @msj = 'Usuario no esta asignado para autorizar este nivel '
		return
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select @idNivel = Id_Niv from CfgNivelAut where Id_Aut = @idAut and Niv = @Niv
select @IB_AutComNiv = IB_AutComNiv from CfgNivelAut where Id_Aut = @idAut and Id_Niv = @idNivel
if(@IB_AutComNiv = 0)
begin
	if(dbo.verificarAutNvlAnt(@RucE, @Cd_Doc, @idNivel, @IB_AutComNiv, @TipoDoc) = 1)
		set @msj = 'El documento ya no necesita volver a ser autorizado para el nivel ' + Convert(nvarchar,@Niv)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Leyenda --
-- MM : 2010-01-20    : <Creacion del procedimiento almacenado>
-- 
GO
