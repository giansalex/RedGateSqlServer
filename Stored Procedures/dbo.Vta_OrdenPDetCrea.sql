SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdenPDetCrea]
@RucE nvarchar(11),
@Cd_OP nvarchar(10),
@NroReg int,
@Cd_Pro nvarchar(7),
@Cant numeric(13,3),
@Cd_UM nvarchar(2),
@Valor numeric(13,2),
@DsctoP numeric(5,2),
@DsctoI numeric(13,2),
@IMP numeric(13,2),
@IGV numeric(13,2),
@Total numeric(13,2),
--@FecReg datetime,
--@FecMdf datetime,
@UsuCrea nvarchar(10),
--@UsuModf nvarchar(10),
@msj nvarchar(100) output
as

if not exists (select * from OrdenP where RucE=@RucE and Cd_OP=@Cd_OP)
	set @msj = 'Se produjo error al ingresar registro verificar Orden Pedido'
else
begin transaction

	insert into OrdenPDet(RucE,Cd_OP,NroReg,Cd_Pro,Cant,Cd_UM,Valor,DsctoP,DsctoI,IMP,IGV,Total,FecReg,UsuCrea)
	               Values(@RucE,@Cd_OP,@NroReg,@Cd_Pro,@Cant,@Cd_UM,@Valor,@DsctoP,@DsctoI,@IMP,@IGV,@Total,getdate(),@UsuCrea)

	if @@rowcount <= 0
	begin
		set @msj = '(*)Orden de Pedido no puso ser ingresado' 
		rollback transaction
	end
commit transaction
print @msj
GO
