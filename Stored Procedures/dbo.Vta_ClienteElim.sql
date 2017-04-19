SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ClienteElim]
@RucE nvarchar(11),
@Cd_Aux nvarchar(7),

--Valores agregados
--******************
--@Cd_MR nvarchar(2),
@Usu nvarchar(10),

@msj varchar(100) output
as
if not exists (select * from Auxiliar where RucE=@RucE and Cd_Aux=@Cd_Aux)
	set @msj = 'Auxiliar no existe'


else if exists (select * from Venta where RucE=@RucE and Cd_Cte=@Cd_Aux)
	set @msj = 'Cliente ' + @Cd_Aux + ' no puede ser eliminado por tener data relacionada'

else
begin	
begin transaction
	--OBTENIENDO INFORMACION PARA REGISTRAR MOVIMIENTO
	-----------------------------------------------------------------------------------
	declare @Cd_TDI nvarchar(2), @NDoc nvarchar(15)
	set @Cd_TDI = (select Cd_TDI from Auxiliar where RucE=@RucE and Cd_Aux=@Cd_Aux)
	set @NDoc = (select NDoc from Auxiliar where RucE=@RucE and Cd_Aux=@Cd_Aux)
	-----------------------------------------------------------------------------------

	delete from Cliente where RucE=@RucE and Cd_Aux=@Cd_Aux

	if @@rowcount <= 0
	begin	   set @msj = 'Cliente no pudo ser eliminado'
	   rollback transaction
	   return
	end

	delete from Auxiliar where RucE=@RucE and Cd_Aux=@Cd_Aux

	if @@rowcount <= 0
	begin	   set @msj = 'Auxiliar no pudo ser eliminado'
	   rollback transaction
	   return
	end

	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from AuxiliarRM where RucE=@RucE)
	insert into AuxiliarRM(RucE,NroReg,Cd_Aux,Cd_TDI,NroDoc,Cd_TA,Cd_MR,Usu,FecMov,Cd_Est)
	        values(@RucE,@NroReg,@Cd_Aux,@Cd_TDI,@NDoc,'01','01',@Usu,getdate(),'03')
	-----------------------------------------------------------------------------------

commit transaction
end
print @msj
-- DI 20/01/2009
GO
