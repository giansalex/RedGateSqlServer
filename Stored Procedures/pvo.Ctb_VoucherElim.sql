SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherElim]
@RucE nvarchar(11),
@RegCtb nvarchar(15),
@UsuMdf nvarchar(10),
@msj varchar(100) output
as

set @msj = 'Para eliminar voucher, debe actualizar el sistema'
/*

if not exists (select * from Voucher where RucE=@RucE and RegCtb=@RegCtb)
	set @msj = 'Voucher no existe'
else
begin
	/ *
	declare @Cd_Vou varchar(10)
	set @Cd_Vou = (select Cd_Vou from Voucher where RucE=@RucE and RegCtb=@RegCtb)

	
	--DECLARANDO VALORES PARA REGISTRAR EL MOVIMIENTO EN VOUCHERMR
	------------------------------------------------------------------------
	Declare @NroReg int, @Cd_TD nvarchar(2), @NroDoc nvarchar(15)
	Declare @Debe decimal(13,2), @Haber decimal(13,2), @Cd_Mda nvarchar(2)
	Declare @Cd_Area nvarchar(6), @Cd_MR nvarchar(2)
	
	set @NroReg = (select isnull(max(NroReg),0)+1 from VoucherRM where RucE=@RucE)
	select @Cd_TD=Cd_TD, @NroDoc=NroDoc, @Debe=MtoD, @Haber=MtoH, @Cd_Mda=Cd_MdRg,
	       @Cd_Area=Cd_Area, @Cd_MR=Cd_MR 
	from   Voucher
	where RucE=@RucE and Cd_Vou=@Cd_Vou
	

	* /

	delete from Voucher where RucE=@RucE and RegCtb=@RegCtb
	if @@rowcount <= 0
	begin
		set @msj = 'Voucher no pudo ser eliminado'
		return
	end

	/ *
	--INSERTANDO MOVIMIENTO DE REGISTRO--
	-----------------------------------------------------------------------------------
	insert into VoucherRM(RucE,NroReg,Cd_Vou,Cd_TD,NroDoc,Debe,Haber,Cd_Mda,Cd_Area,Cd_MR,Usu,FecMov)
		       Values(@RucE,@NroReg,@Cd_Vou,@Cd_TD,@NroDoc,@Debe,@Haber,@Cd_Mda,@Cd_Area,@Cd_MR,@UsuMdf,getdate())
	-----------------------------------------------------------------------------------	
	* /


	--ELIMINANDO MOVIMINETO EN VENTA
	
	if exists (Select * from Venta where RucE=@RucE and RegCtb=@RegCtb)
	begin
		exec Vta_VentaElim_X_NDNR @RucE,'','',@RegCtb,@UsuMdf,@msj output
	end
end
*/

print @msj
--PV: Vie 30/01/09
--PV: Mar 17/02/09
--DI: Vie 20/02/09
GO
