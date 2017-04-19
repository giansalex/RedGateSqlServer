SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Producto2_ConsUn_Foto]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output
as

if not exists (select * from Producto2 where Cd_Prod=@Cd_Prod and RucE = @RucE)
	set @msj = 'Producto no existe.'
else
begin
	select p.RucE, p.Cd_Prod, p.Nombre1, p.Descrip, p.PagWeb, p.Img
	from Producto2 p
	where p.Cd_Prod=@Cd_Prod and p.RucE = @RucE
end
print @msj

-- Leyenda --
-- PV: Creado 2017-04-07 : <Creacion del procedimiento almacenado>

--Pruebas
--exec [Vta_Producto2_ConsUn_Foto] '20160000001', 'PD0020',null










GO
