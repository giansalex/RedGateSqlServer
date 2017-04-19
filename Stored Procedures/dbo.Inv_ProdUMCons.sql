SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdUMCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin 
	if(@TipCons=0)
		select * from Prod_UM where  RucE=@RucE
	else
		 select Id_UMP+'  |  '+DescripAlt as Codigo, Id_UMP, DescripAlt from Prod_UM where RucE=@RucE
end
print @msj
-- Leyenda --
-- PP : 2010-02-24 : <Creacion del procedimiento almacenado>
GO
