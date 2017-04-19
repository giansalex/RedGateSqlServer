SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaElim_X_NDNR2] /*ELIMINAR DESPUES DE ACTUALIZAR CEDIVE 03/02/09*/
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@RegCtb nvarchar(15),
@UsuModf  nvarchar(10),
@msj varchar(100) output
as

Declare @Cd_Vta nvarchar(10)
--Declare @Cd_Reg nvarchar(12)
set @Cd_Vta = ''
--set @Cd_Reg = ''
if(len(@NroDoc) > 0)
begin
	set @msj = 'Falta especificar numero de serie'  --- mensaje temporal para luego agregar nro de serie como parametro
	return

	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Eje=@Ejer and Cd_TD=@Cd_TD and NroDoc=@NroDoc)
	--set @Cd_Reg = (select RegCtb from Voucher where RucE=@RucE and Ejer=@Ejer and Cd_TD=@Cd_TD and NroDoc=@NroDoc)

	if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro Documento no pertenece a ninguna venta'
		return
	end
	else	
	begin
		exec Vta_VentaElim @RucE,@Cd_Vta,@UsuModf,@msj output
		
/*		--///////////////////////////////////////
		--//ELIMINANDO VOUCHER SI EXISTE
		if exists (select * from Voucher where  RucE=@RucE and Ejer=@Ejer and RegCtb=@Cd_Reg)
		begin
			exec pvo.Ctb_VoucherElim @RucE,@Cd_Reg,@UsuModf,@msj output
		end
		--////////////////////////////////////// 
*/
	end
end
else
begin
	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Eje=@Ejer and RegCtb=@RegCtb)
	
	if (@Cd_Vta = null or @Cd_Vta is null)
	begin
		set @msj = 'Nro de registro no pertenece a ninguna venta'
		return
	end
	else
	begin
		exec Vta_VentaElim @RucE,@Cd_Vta,@UsuModf,@msj output
	
/*		--///////////////////////////////////////
		--//ELIMINANDO VOUCHER SI EXISTE
		if exists (select * from Voucher where  RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
		begin
			exec pvo.Ctb_VoucherElim @RucE,@RegCtb,@UsuModf,@msj output
		end
		--//////////////////////////////////////
*/
	end
end
print @msj

--PV : Mar16/11/2010  Mdf  mensaje temporal para lueg.......
GO
