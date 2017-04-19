SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [User123].[Com_SolicitudReq_Aut]
@RucE nvarchar(11),
@Cd_SR char(10),
@UsuMdf nvarchar(10),
@Pass nvarchar(50),
@msj varchar(100) output
as
if not exists (select * from Usuario where NomUsu=@UsuMdf)
	set @msj = 'Usuario no existe'
else if not exists(select * from Usuario where NomUsu=@UsuMdf and Pass = @Pass )
	set @msj = 'Clave incorrecta'
else
---------------------------------------Temporalmente---------------------------------------------------
begin
	update SolicitudReq set Autorizadopor = @UsuMdf ,UsuMdf = @UsuMdf ,FecMdf = Getdate() 
	--,IC_NAut = '1' 
	where RucE = @RucE and Cd_SR = @Cd_SR
	if @@rowcount <= 0
	set @msj = 'Solicitud de Requerimiento no pudo ser Autorizada'	
end

-- Leyenda --
-- Jesus : 2010-08-06 : <Creacion del procedimiento almacenado>
--exec Com_SolicitudReq_Aut '11111111111','SC00000031','jesus','200613291',null

GO
