SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MtvoIngSalElim]  --<Procedimiento que elimina los motivos de Ingreso y/o Salida>
@RucE nvarchar(11),
@Cd_MIS char(3),
@msj varchar(100) output
as
set @msj = ''
if not exists (select * from MtvoIngSal where RucE= @RucE and Cd_MIS=@Cd_MIS)
	set @msj = 'Motivo de Ingreso/Salida no existe'
else
begin
  declare @Cd_TM char(2)

  set @Cd_TM = (select Cd_TM  from MtvoIngSal where RucE= @RucE and Cd_MIS=@Cd_MIS)

  if @Cd_TM = '01'
   begin
	if exists (select * from venta where RucE = @RucE and Cd_MIS = @Cd_MIS)
		set @msj = 'No se puede eliminar debido a que hay ventas realizadas con este movimiento'
   end
  else
   begin
	if @Cd_TM = '02'
	 begin
		if exists (select * from compra where RucE = @RucE and Cd_MIS = @Cd_MIS)
			set @msj = 'No se puede eliminar debido a que hay compras realizadas con este movimiento'
	 end
	else
	 begin
	  	if @Cd_TM = '05'
	   	 begin
			if exists (select * from inventario where RucE = @RucE and Cd_MIS = @Cd_MIS)
				set @msj = 'No se puede eliminar debido a movimientos de inventario realizadas con este motivo'
	   	 end
	 end
   end
end
if @msj = ''
begin
	delete from Asiento where RucE = @RucE and Cd_MIS = @Cd_MIS	
	delete from MtvoIngSal where RucE = @RucE and Cd_MIS = @Cd_MIS
	if @@rowcount <=0
		set @msj = 'El movimiento no pudo ser eliminado'	
end
GO
