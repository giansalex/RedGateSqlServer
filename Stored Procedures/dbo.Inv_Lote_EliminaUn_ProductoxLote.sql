SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_Lote_EliminaUn_ProductoxLote]
@RucE nvarchar(11),
@RegCtbInv char(10),
@Ejer nvarchar(4),
@msj varchar(100) output
as
if exists (select * from ProductoxLote where RucE = @RucE
and RegCtbInv = @RegCtbInv and Ejer = @Ejer)
begin
	delete from ProductoxLote where RucE = @RucE
		and RegCtbInv = @RegCtbInv and Ejer = @Ejer
end
else
begin
	set @msj='No existe el registro contable de inventario.'
end

GO
