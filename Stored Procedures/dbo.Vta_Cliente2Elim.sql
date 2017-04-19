SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Cliente2Elim]
@RucE nvarchar(11),
@Cd_Clt nvarchar(10),

--Valores agregados
--******************
@Usu nvarchar(10),
@Cd_MR nvarchar(2),
--******************

@msj varchar(100) output
as
if not exists (select * from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt)
	set @msj = 'Cliente no existe'
else if exists (select * from DirecEnt where RucE = @RucE and Cd_Clt=@Cd_Clt)
	set @msj = 'No se puede eliminar el Cliente debido a que tiene direcciones relacionadas'

--else if exists (select * from Venta where RucE=@RucE and Cd_Cte=@Cd_Aux)
--	set @msj = 'Cliente ' + @Cd_Aux + ' no puede ser eliminado por tener data relacionada'

else
begin	
begin transaction
	--OBTENIENDO INFORMACION PARA REGISTRAR MOVIMIENTO
	-----------------------------------------------------------------------------------
	declare @Cd_TDI nvarchar(2), @NDoc nvarchar(15)
	set @Cd_TDI = (select Cd_TDI from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt)
	set @NDoc = (select NDoc from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt)
	-----------------------------------------------------------------------------------

	delete from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt

	if @@rowcount <= 0
	begin	   set @msj = 'Cliente no pudo ser eliminado'
	   rollback transaction
	   return
	end
	
	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from AuxiliarRM where RucE=@RucE)
	--Cd_MR : Codigo de Area
	--Cd_Estado : Tipo de Movimiento(Eliminar = 03)
	--Cd_TA : Codigo de Tipo de Auxiliar (Cliente = 01)
	insert into AuxiliarRM(RucE,NroReg,Cd_Aux,Cd_TDI,NroDoc,Cd_TA,Cd_MR,Usu,FecMov,Cd_Est)
	        values(@RucE,@NroReg,@Cd_Clt,@Cd_TDI,@NDoc,'01',@Cd_MR,@Usu,getdate(),'03')
	-----------------------------------------------------------------------------------

commit transaction
end
print @msj
-- JU 29/05/2010
GO
