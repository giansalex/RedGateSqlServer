SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Com_SolicitudCom_Aut]
@RucE nvarchar(11),
@Cd_SCo char(10),
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
	update SolicitudCom set Autorizadopor = @UsuMdf ,UsuMdf = @UsuMdf ,FecMdf = Getdate(),IB_Aut='1'
	--,IC_NAut = '1' 
	where RucE = @RucE and Cd_SCo = @Cd_SCo
	if @@rowcount <= 0
	set @msj = 'Solicitud de Compra no pudo ser Autorizada'	
end

-- Leyenda --
-- Jesus : 2010-08-06 : <Creacion del procedimiento almacenado>
--exec Com_SolicitudCom_Aut '11111111111','SC00000031','jesus','200613291',null




GO
