SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_Lote_EliminarProductoxLote]
@RucE nvarchar(11),
@RegCtbInv nvarchar(15),
@Ejer nvarchar(4),
@msj varchar(100) output
as
	delete from ProductoxLote where RucE = @RucE
	and RegCtbInv = @RegCtbInv and Ejer = @Ejer
-- leyenda
-- cam 19/12/2012 creacion
GO
