SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Cfg_AutorizarDocumento]
@RucE nvarchar (11),
@Cd_Doc char(10),
@NomUsu nvarchar(10),
@FecAut datetime,
@Obs varchar (300),
@TipoDoc int,
@msj varchar (100) output

AS
--------------------------------------------------
declare @Cadena nvarchar(500)
declare @Tabla varchar(10)
declare @Campo varchar(10)
--------------------------------------------------
declare @Tabla2 varchar(15)
declare @CdDMA char(2)
declare @num int
--------------------------------------------------
if(@TipoDoc = 0)
begin
	set @Tabla = 'AutOC'
	set @Tabla2 = 'OrdCompra'
	set @Campo = 'Cd_OC'
	set @CdDMA = 'OC'
end
else if(@TipoDoc = 1)
begin
	set @Tabla = 'AutOP'
	set @Tabla2 = 'OrdPedido'
	set @Campo = 'Cd_OP'
	set @CdDMA = 'OP'
end
else if(@TipoDoc = 2)
begin
	set @Tabla = 'AutSC'
	set @Tabla2 = 'SolicitudCom'
	set @Campo = 'Cd_SCo'
	set @CdDMA = 'SC'
end
else if(@TipoDoc = 3)
begin
	set @Tabla = 'AutSR'
	set @Tabla2 = 'SolicitudReq'
	set @Campo = 'Cd_SR'
	set @CdDMA = 'SR'
end
else if(@TipoDoc = 4)
begin
	set @Tabla = 'AutOF'
	set @Tabla2 = 'OrdFabricacion'
	set @Campo = 'Cd_OF'
	set @CdDMA = 'OF'
end
else if(@TipoDoc = 5)
begin
	set @Tabla = 'AutCot'
	set @Tabla2 = 'Cotizacion'
	set @Campo = 'Cd_Cot'
	set @CdDMA = 'CT'
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

set @Cadena = 'insert into '+@Tabla+' (RucE,'+@Campo+', NomUsu, FecAut, Obs) 
		values ( '''+@RucE+''','''+@Cd_Doc+''','''+@NomUsu+''','''+ Convert(nvarchar,@FecAut)+''','''+@Obs+''')'

print @Cadena
exec (@Cadena)

declare @Auts nvarchar(50)
set @Cadena = 'select @auto = AutorizadoPor from '+@Tabla2+'  where '+@Campo+' = '''+@Cd_Doc+''' and RucE = '''+@RucE+''''

exec sp_executesql @Cadena, N'@auto nvarchar(100) output', @Auts output

if(len(@Auts)>0) set @NomUsu = @Auts + ', ' +@NomUsu

set @Cadena = 'update '+@Tabla2+' set AutorizadoPor = '''+@NomUsu+''' where '+@Campo+' = '''+@Cd_Doc+''' and RucE = '''+@RucE+''''

exec(@Cadena)

----------------------------------------------------------------------------------------------------------------------------------
if(@@rowcount<=0) 
begin
	set @msj = 'La autorizacion no pudo ser ingresada'
end
else
begin

----------------------------------------------------------------------------------------------------------------------------------
declare @maxNivel int
declare @nivComp bit

set @Cadena = 'select  @max = max(c.Id_Niv) from cfgAutorizacion a
		join '+@Tabla2+' b on a.Cd_DMA = '''+@CdDMA+''' and b.TipAut = a.Tipo and a.RucE = b.RucE
		join CfgNivelAut c on c.Id_Aut = a.Id_Aut
		where a.RucE = '''+@RucE+''' and b.'+@Campo+' = '''+@Cd_Doc+''''

exec sp_executesql @cadena, N'@max int output', @maxNivel output
select @nivComp = IB_AutComNiv from CfgNivelAut where Id_Niv = @maxNivel

if(dbo.verificarAutNvlAnt(@RucE, @Cd_Doc, @maxNivel, @nivComp, @TipoDoc)=1)
begin
	set @Cadena =  'update '+@Tabla2+' set IB_Aut = 1 where '+@Campo+' = '''+@Cd_Doc+''''
	print(@Cadena)
	exec (@Cadena)
	if (@@rowcount <=0)
		set @msj = 'Error al actualizar el estado de autorizacion'

end
----------------------------------------------------------------------------------------------------------------------------------
/*
	set @Cadena =	'select @contador = count(*) from (
			select NomUsu from '+@Tabla+' where RucE = '''+@RucE+''' and '+@Campo+' = '''+@Cd_Doc+'''
		) as t1 right join (
			select d.NomUsu from '+@Tabla2+' a 
			join CfgAutorizacion b on a.'+@Campo+' = '''+@Cd_Doc+''' and b.Cd_DMA = '''+@CdDMA+''' and b.tipo = a.tipAut
			join CfgNivelAut c on c.Id_Aut = b.Id_Aut
			join CfgAutsXUsuario d on d.Id_Niv = c.Id_Niv
			where a.RucE = '''+@RucE+'''
		) as t2
		on t1.nomusu = t2.nomusu
		where t1.nomusu is null'	
	print @Cadena
*/

end

-- Leyenda --
-- MM : 2010-01-21    : <Creacion del procedimiento almacenado>
-- MM : 2010-01-25    : <Modificacion : Se agrego la actualizacion del estado de autorizacion en el documento>
-- MM : 2010-01-29    : <Modificacion : Se agrego la actualizacion del estado de autorizacion en el documento>



GO
