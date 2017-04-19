SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdenPAnul]
@RucE nvarchar(11),
@Cd_OP nvarchar(10),
@CamMda numeric(6,3),
--@FecMdf datetime,
@UsuModf nvarchar(10),
@IB_Anulado bit,
@msj varchar(100) output
as
if not exists (select * from OrdenP where RucE=@RucE and Cd_OP=@Cd_OP)
	set @msj = 'No existe Orden de Pedido'
else
begin
	update Orden set FecMdf=getdate(), UsuModf=@UsuModf, IB_Anulado=@IB_Anulado
	where RucE=@RucE and Cd_OP=@Cd_OP

	if @@rowcount <= 0
		set @msj = 'Orden de Pedido no pudo ser anulado'
end
print @msj
GO
