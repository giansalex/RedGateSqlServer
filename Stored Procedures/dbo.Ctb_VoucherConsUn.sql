SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherConsUn]
@RucE nvarchar(11),
@Cd_Vou int,
@RegCtb nvarchar(15),
@msj varchar(100) output
as
if not exists (select * from Voucher where RucE=@RucE and Cd_Vou=@Cd_Vou and RegCtb = @RegCtb)
	set @msj = 'Voucher no existe'
else	select * from Voucher where RucE=@RucE and Cd_Vou=@Cd_Vou and  RegCtb = @RegCtb
print @msj
--PV: Vie 30/01/09
GO
