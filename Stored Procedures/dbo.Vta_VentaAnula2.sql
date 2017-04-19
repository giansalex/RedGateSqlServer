SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaAnula2] 
@RucE nvarchar(11),
@Eje nvarchar(4), -- DATO AGREGADO
@Cd_Vta nvarchar(10),
@UsuModf nvarchar(10),
@msj varchar(100) output
as

if not exists (select * from Venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no existe'
else
begin

	--JS -> se modifico de usumdf a usucrea
	if (@UsuModf != (select UsuCrea from Venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta ))
	begin 	set @msj = 'Usuario no puede anular movimientos registrados por otro usuario'
		return
	end

	--OBTENIENDO INFORMACION PARA REGISTRAR MOVIMIENTO
	-----------------------------------------------------------------------------------
	declare @Cd_TD nvarchar(2), @NroDoc nvarchar(15), @Cd_Area nvarchar(6),@Cd_MR nvarchar(2), @Cd_Mda nvarchar(2), @Total decimal(13,2)
	set @Cd_TD = (select Cd_TD from Venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta)
	set @NroDoc = (select NroDoc from Venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta)
	set @Cd_Area = (select Cd_Area from Venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta)
	set @Cd_MR = (select Cd_MR from Venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta)
	set @Cd_Mda = (select Cd_Mda from Venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta)
	set @Total = (select Total from Venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta)
	-----------------------------------------------------------------------------------	
	declare @RegCtb nvarchar(15)
	set @RegCtb=(select RegCtb from venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta)

	
	update Venta set FecMdf=getdate(), UsuModf=@UsuModf, IB_Anulado=1
	where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta

	if @@rowcount <= 0
	begin
	   set @msj = 'Venta no pudo ser anulada'
	   return
	end
	

	exec pvo.Ctb_VoucherAnula2 @RucE,@Eje,@RegCtb,@UsuModf,output@msj


	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from VentaRM where RucE=@RucE)
	insert into VentaRM(NroReg,RucE,Cd_Vta,Cd_TD,NroDoc,Total,Cd_Mda,FecMov,Cd_Area,Cd_MR,Usu,Cd_Est)
		     Values(@NroReg,@RucE,@Cd_Vta,@Cd_TD,@NroDoc,@Total,@Cd_Mda,getdate(),@Cd_Area,@Cd_MR,@UsuModf,'04')
	-----------------------------------------------------------------------------------
end
print @msj
--PV
--DI : Lun 23/01/09
--JS : VIE 02/10/09 -MDF -> Se modifico para que anule tanto como en ventas como en contabilidad
--DI : JUE 15/04/2010  <Se modifico para que anule por ejercicio tanto en ventas como en contabilidad>
GO
