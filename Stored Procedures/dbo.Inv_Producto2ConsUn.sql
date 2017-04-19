SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2ConsUn]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output,
@Grupo bit output
as


if not exists (select * from Producto2 where Cd_Prod=@Cd_Prod and RucE = @RucE)
	set @msj = 'Producto no existe'
else
begin
	select *  from Producto2 where Cd_Prod=@Cd_Prod and RucE = @RucE
	set @Grupo  = (select Case(Count(Cd_ProdB)) when 0 then 0 else 1 end from ProdCombo where RucE = @RucE and Cd_ProdB=@Cd_Prod)
end
print @msj

-- Leyenda --
-- PP : 2010-02-23 : <Creacion del procedimiento almacenado>
GO
