SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompra_Aut]
@RucE nvarchar(11),
@Cd_OC char(10),
@UsuModf nvarchar(10),
@Pass nvarchar(50),
@msj varchar(100) output
as
if not exists (select * from Usuario where NomUsu=@UsuModf)
	set @msj = 'Usuario no existe'
else if not exists(select * from Usuario where NomUsu=@UsuModf and Pass = @Pass )
	set @msj = 'Clave incorrecta'
else
---------------------------------------Temporalmente---------------------------------------------------
begin
	update OrdCompra set AutdoPorN1 = @UsuModf ,UsuModf = @UsuModf ,FecMdf = Getdate(),IB_Aut='1' 
	,IC_NAut = '1' 
	where RucE = @RucE and Cd_OC = @Cd_OC
	if @@rowcount <= 0
	set @msj = 'Orden de compra no pudo ser Autorizada'	
end

-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>



GO
