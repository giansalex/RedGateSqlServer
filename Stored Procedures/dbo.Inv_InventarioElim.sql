SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  procedure [dbo].[Inv_InventarioElim] 
@RucE nvarchar(11),
@RegCtb nvarchar(15),
@msj varchar(100) output, 
@Ejer nvarchar(4),
@UsuModf nvarchar(10) = null
as 
set @msj = 'Debe actualizar el sistema.'
/*
declare @CadCd_Prod nvarchar(70)
declare @Cd_Prod char(7)
declare @FecMov datetime
set @CadCd_Prod = ''
select @FecMov = Min(FecMov) from Inventario where RucE = @RucE and  RegCtb= @RegCtb  and Ejer = @Ejer

declare Cur_Inv cursor for select Cd_Prod from Inventario where RucE = @RucE and  RegCtb= @RegCtb
open Cur_Inv
	fetch Cur_Inv into @Cd_Prod
		while(@@fetch_status = 0)
		begin
			set @CadCd_Prod = @CadCd_Prod + @Cd_Prod
			fetch Cur_Inv into @Cd_Prod
		end
close Cur_Inv
deallocate Cur_Inv
delete Inventario where RucE = @RucE and Ejer = @Ejer and  RegCtb= @RegCtb 
print @CadCd_Prod
exec dbo.Inv_Recalcular @RucE, @CadCd_Prod, @FecMov, null, @msj output
declare @MovInvCtb bit
select @MovInvCtb =  IB_MovInvCtbLin from CfgGeneral where RucE =@RucE
if (@MovInvCtb=1)
	if exists (select * from Voucher where  RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)  --Esta validacion siempre debe estar afuera --PV
		exec pvo.Ctb_VoucherElim2 @RucE,@Ejer,@RegCtb,@UsuModf,@msj output
if @msj is not null
	rollback transaction
*/

-- Leyenda --
-- PP : 2010-08-20 19:38:17.483	: <Creacion del procedimiento almacenado>
--CAM: 23/11/10 Agregue Ejercicio

GO
