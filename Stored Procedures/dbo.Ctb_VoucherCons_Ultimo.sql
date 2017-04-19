SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherCons_Ultimo]
@RucE nvarchar(11),
@Eje nvarchar(4),
@msj varchar(100) output
as
declare @Cd_Vou nvarchar(10)
set @Cd_Vou = (select isnull(max(Cd_Vou),0) as Maximo from Voucher where RucE=@RucE and Ejer=@Eje)
if(@Cd_Vou = '0')
begin
	set @msj = 'No se encontraron Voucher registros'
	return
end
select vo.Cd_Vou,vo.Cd_TD,vo.NroSre,vo.NroDoc,vo.RegCtb from Voucher vo where vo.RucE=@RucE and vo.Ejer=@Eje and vo.Cd_Vou=@Cd_Vou and vo.IB_Anulado<>1
GO
