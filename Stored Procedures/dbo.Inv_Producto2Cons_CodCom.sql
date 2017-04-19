SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_Producto2Cons_CodCom]
@RucE nvarchar(11),
@CodCom varchar(10),
@TipCod int,
@msj varchar(100) output
as
if(@TipCod = 1)
	if exists (select CodCo1_ from Producto2 where RucE = @RucE and CodCo1_ = @CodCom)
		Set @msj = 'Ya existe codigo comercial.'
if(@TipCod = 2)
	if exists (select CodCo1_ from Producto2 where RucE = @RucE and CodCo2_ = @CodCom)
		Set @msj = 'Ya existe codigo comercial 2.'
if(@TipCod = 3)
	if exists (select CodCo1_ from Producto2 where RucE = @RucE and CodCo3_ = @CodCom)
		Set @msj = 'Ya existe codigo comercial 3.'
-- Leyenda --
-- CAM : 2013-01-10 : <Creacion del procedimiento almacenado>
GO
