SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_OrdPedidoDet_ConsUn]
@RucE nvarchar(11),
@Cd_OP char(10),
@Item int,
@msj varchar(100) output
as
if not exists (select * from OrdPedidoDet where RucE=@RucE and Cd_OP=@Cd_OP and Item=@Item)
	Set @msj = 'No existe Orden de Pedido Detalle'
else
begin
	select  op.Item, op.Cd_OP, op.Cd_Prod, op.Cd_Srv , op.Descrip, op.PU, op.ID_UMP, op.Cant, op.PendEnt, op.Valor, op.DsctoP, op.DsctoI,
		op.BIM, op.IGV, case(isnull(op.IGV,0)) when 0 then 0 else 1 end as IncIGV, op.Total, op.Cd_Alm, op.Obs, op.CA01, op.CA02, 
		op.CA03, op.CA04, op.CA05, op.CA06, op.CA07, op.CA08, op.CA09, op.CA10
	from OrdPedidoDet op
	where op.RucE=@RucE and op.Cd_OP=@Cd_OP and op.Item = @Item

	
end
-- Leyenda --
-- JJ : 2010-08-09 : <Creacion del procedimiento almacenado>
GO
