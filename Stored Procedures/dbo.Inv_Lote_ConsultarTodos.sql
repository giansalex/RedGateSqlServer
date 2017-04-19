SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_Lote_ConsultarTodos]
@RucE nvarchar(11),
----------------------
@msj varchar(100) output
as

select distinct(NroLote), Descripcion  from Lote where RucE = @RucE

-- LEYENDA
-- CAM
-- exec Inv_Lote_ConsultarTodos '11111111111',''
GO
