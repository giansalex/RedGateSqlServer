SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AnulaGRS] 
@RucE nvarchar(11),
@Cd_GR char(10),
@IC_ES char(1),
@UsuMdf nvarchar(20),
@msj varchar(100) output
as 
if not exists (select * from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR and @IC_ES='S')
	set @msj = 'Guia de Remision No existe no existe'
else
begin

	if (@UsuMdf != (select UsuCrea from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR and @IC_ES='S'))
	begin 	set @msj = 'Usuario no puede anular movimientos registrados por otro usuario'
		return
	end
	else if exists (select * from GuiaRemision where RucE=@RucE and @Cd_GR in (select Cd_GR from Inventario where RucE=@RucE))
	begin 	set @msj = 'Usuario no puede anular movimiento porque esta relacionado con un movimiento de inventario'
		return
	end
	--else if exists (select * from GuiaRemision where RucE=@RucE and @Cd_GR in (select Cd_GR from GuiaXVenta where RucE=@RucE)  )
	--else if exists (select * from GuiaRemision where RucE=@RucE and @Cd_GR in (select Cd_GR from GuiaXVenta where RucE=@RucE)  )
	else if exists (select Cd_GR from GuiaXVenta gv inner join Venta v on v.RucE=gv.RucE and v.Cd_Vta=gv.Cd_Vta where v.RucE=@RucE and gv.Cd_GR=@Cd_GR and v.IB_Anulado<>1)
	begin 	set @msj = 'Usuario no puede anular movimiento porque esta relacionado con un movimiento de venta'
		return
	end
	
	update GuiaRemision set FecMdf=getdate(), UsuMdf=@UsuMdf, IB_Anulado=1
	where RucE=@RucE and Cd_GR=@Cd_GR

	if @@rowcount <= 0
	begin
	   set @msj = 'Guia de Remisión no pudo ser anulada'
	   return
	end
	
end
print @msj
--FL : 16/05/2011 <creacion del procedimiento almacenado>
GO
