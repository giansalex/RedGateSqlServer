SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Venta2Elim]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@UsuModf nvarchar(10),
@msj varchar(100) output
as



set @msj = 'Para eliminar venta, debe actualizar el sistema'
-- Este sp no se debe utilizar --PV
return
/*

if not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no existe'
else if exists (select *from inventario where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj='Venta Tiene Inventario Relacionado'

else  if exists (select * from Cobro where RucE = @RucE and Cd_Vta = @Cd_Vta)
	set @msj='Venta a sido cobrada'
else if(@UsuModf != (select UsuCrea from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta))
		set @msj='No tiene permisos para modificar la venta'
else
begin
begin transaction
	--OBTENIENDO INFORMACION PARA REGISTRAR MOVIMIENTO
	-----------------------------------------------------------------------------------
	declare @Cd_TD nvarchar(2), @NroDoc nvarchar(15), @Cd_Area nvarchar(6),@Cd_MR nvarchar(2), @Cd_Mda nvarchar(2), @Total decimal(13,2)
	set @Cd_TD = (select Cd_TD from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @NroDoc = (select NroDoc from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @Cd_Area = (select Cd_Area from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @Cd_MR = (select Cd_MR from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @Cd_Mda = (select Cd_Mda from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @Total = (select Total from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	-----------------------------------------------------------------------------------

	delete from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta 
	delete from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta
	if @@rowcount <= 0
	begin	   set @msj = 'Venta no pudo ser eliminado'
	   rollback transaction
	end
	else
	begin
	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from VentaRM where RucE=@RucE)
	insert into VentaRM(NroReg,RucE,Cd_Vta,Cd_TD,NroDoc,Total,Cd_Mda,FecMov,Cd_Area,Cd_MR,Usu,Cd_Est)
		     Values(@NroReg,@RucE,@Cd_Vta,@Cd_TD,@NroDoc,@Total,@Cd_Mda,getdate(),@Cd_Area,@Cd_MR,@UsuModf,'03')
	-----------------------------------------------------------------------------------
	end
commit transaction
end

--print @msj
*/

-- Leyenda --
-- JJ :  2010-09-14 : <Creacion del procedimiento almacenado>
-- PV:  04/02/2011:  se comento todo el sp para que ya no se use.
GO
