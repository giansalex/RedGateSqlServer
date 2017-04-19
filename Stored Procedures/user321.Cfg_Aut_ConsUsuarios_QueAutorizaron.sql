SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Cfg_Aut_ConsUsuarios_QueAutorizaron]
@RucE nvarchar(11),
@TipoDoc int,
@Cd_Doc char(10),
@TipAut int,
@NivPendiente nvarchar(100) output,
@msj varchar(100) output
as

declare @Tabla varchar(15)
declare @CdDMA char(2)
declare @Campo varchar(10)
declare @Cadena nvarchar(1000)

-----------------------------------------------
if(@TipoDoc = 0)
begin
	set @Tabla = 'AutOC'
	set @Campo = 'Cd_OC'
	set @CdDMA = 'OC'
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

declare @cont int

set @Cadena = 'select @contador = count(*) from CfgAutorizacion where Cd_DMA = '''+@CdDMA +''' and Tipo = '+Convert(varchar, @TipAut)
print @Cadena
exec sp_executesql @Cadena, N'@contador int output', @cont output
if(@cont=0)
begin
	print 'No existe el tipo de autorizacion'
	return
end

set @Cadena = 'select e.NomComp as Usuario , b.Niv as Nivel, d.Obs from CfgAutorizacion a 
		join CfgNivelAut b on a.Id_Aut = b.Id_Aut and a.Cd_DMA = '''+@CdDMA+''' and a.Tipo = '+Convert(varchar, @TipAut)+' 
		and a.RucE = '''+@RucE+'''
		join CfgAutsXUsuario c on b.Id_Niv = c.Id_Niv 
		join '+@Tabla+' d on c.NomUsu = d.NomUsu and d.RucE = '''+@RucE+''' and d.'+@Campo+' = '''+@Cd_Doc+''' 
		join Usuario e on d.NomUsu = e.NomUsu 
		order by b.Niv, d.FecAut'

exec (@Cadena)

---------------------------------------------NIVELES PENDIENTES-----------------------------------------------------
set @NivPendiente = ''
set @Cadena = 'select @NivP = (@NivP + case when N.IB_AutComNiv = 0 and  Count(A.NomUsu) = 1 
		then '''' when N.IB_AutComNiv = 1 and  Count(A.NomUsu) = Count(U.NomUsu) 
		then '''' else Convert(nvarchar,N.Niv) + '','' end) 
		from  CfgAutorizacion CA 
		join CfgNivelAut as N on CA.Cd_DMA = '''+@CdDMA+''' and CA.Tipo = '+Convert(varchar, @TipAut)+' and CA.Id_Aut = N.Id_Aut and CA.RucE = '''+@RucE+'''
		 join CfgAutsXUsuario as U on N.Id_Niv = U.Id_Niv 
		left join '+@Tabla+' as A on A.RucE = '''+@RucE+''' and  A.'+@Campo+' = '''+@Cd_Doc+''' and A.NomUsu  =  U.NomUsu 
		group by N.Niv, N.IB_AutComNiv 
		order by N.Niv'

print @Cadena
exec sp_executesql @Cadena, N'@NivP nvarchar(100) output', @NivPendiente output
set @NivPendiente = '[' + SUBSTRING(@NivPendiente, 0, LEN(@NivPendiente)) + ']'
print @NivPendiente


-- MM : 2010-02-04    : <Creacion del procedimiento almacenado>
GO
