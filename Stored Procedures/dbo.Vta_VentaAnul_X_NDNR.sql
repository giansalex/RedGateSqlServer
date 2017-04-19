SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Vta_VentaAnul_X_NDNR] /*ELIMINAR DESPUES DE ACTUALIZAR CEDIVE 03/02/09*/
@RucE nvarchar(11),
--@Ejer nvarchar(4)
@Cd_TD nvarchar(2),
--@NroSre nvarchar(XX),
@NroDoc nvarchar(15),
@RegCtb nvarchar(15),
@UsuModf  nvarchar(10),
@msj varchar(100) output
as

set @msj = 'Para anular una venta ,debe actualizar el sistema'




--Declare @Cd_Vta nvarchar(10) --,@Cd_Sr nvarchar(XX)
--set @Cd_Vta = ''

--select @Cd_Sr from Serie where RucE=@RucE and NroSerie=@NroSre

--if(len(@NroDoc) > 0)
--begin
	--set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Cd_TD=@Cd_TD /* and NroSre=@NroSre*/ --and NroDoc=@NroDoc )

	/*if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro Documento no pertenece a ninguna venta'
		return
	end
	else	exec Vta_VentaAnula @RucE,@Cd_Vta,@UsuModf,@msj output
end
else
begin
	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and RegCtb=@RegCtb) -- and Ejer=@Ejer
	
	if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro de registro no pertenece a ninguna venta'
		return
	end
	else	exec Vta_VentaAnula @RucE,@Cd_Vta,@UsuModf,@msj output
end
print @msj*/
GO
