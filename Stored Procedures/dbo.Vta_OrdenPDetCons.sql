SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdenPDetCons]
@RucE nvarchar(11),
@Cd_OP nvarchar(10),
@msj nvarchar(100) output
as

begin
	select
		dop.RucE, dop.Cd_OP, dop.NroReg, dop.Cd_Pro, pro.Nombre as NomPro, dop.Cant,
		dop.Cd_UM, dop.Valor, dop.DsctoP, dop.DsctoI, dop.IMP, dop.IGV, dop.Total 
	from OrdenPDet dop, Producto pro
	where dop.RucE=@RucE and dop.Cd_OP=@Cd_OP

select * from Producto
end
GO
