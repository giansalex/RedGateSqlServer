SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_Inventario_consultalote]
@RucE nvarchar(11),
@RegCtb nvarchar(15),
@Ejer nvarchar(4),
@msj varchar(100) output
as
if exists (select * from ProductoxLote where RucE = @RucE and RegCtbInv = @RegCtb and Ejer = @Ejer)
begin
	select * from ProductoxLote where RucE = @RucE and RegCtbInv = @RegCtb and Ejer = @Ejer
end
else
begin
	set @msj = 'No existe informacíon de lote para el inventario seleccionado'
end

-- LEYENDA
-- CAM 12/03/2013 creacion
-- exec Inv_Inventario_consultalote '20102028687','INLP_LD08-00005','2012',''
GO
