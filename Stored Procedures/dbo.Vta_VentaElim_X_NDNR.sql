SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaElim_X_NDNR] /*ELIMINAR DESPUES DE ACTUALIZAR CEDIVE 03/02/09*/
@RucE nvarchar(11),
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@RegCtb nvarchar(15),
@UsuModf  nvarchar(10),
@msj varchar(100) output
as


set @msj = 'Para eliminar venta, debe actualizar el sistema'
/*

Declare @Cd_Vta nvarchar(10)
set @Cd_Vta = ''
if(len(@NroDoc) > 0)
begin
	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Cd_TD=@Cd_TD and NroDoc=@NroDoc)

	if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro Documento no pertenece a ninguna venta'
		return
	end
	else	exec Vta_VentaElim @RucE,@Cd_Vta,@UsuModf,@msj output
end
else
begin
	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and RegCtb=@RegCtb)
	
	if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro de registro no pertenece a ninguna venta'
		return
	end
	else	exec Vta_VentaElim @RucE,@Cd_Vta,@UsuModf,@msj output
end
*/
print @msj

--PV: VIE 26/03/2010 Mdf:  msj actualizar sistema
GO
