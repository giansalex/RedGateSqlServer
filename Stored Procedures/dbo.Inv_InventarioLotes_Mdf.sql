SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create PROC [dbo].[Inv_InventarioLotes_Mdf]
@cod nvarchar(11),
@cod_lote char(10),
@desc nvarchar(200),
@fabri DATETIME,
@caduc DATETIME,
@UsuMdf	varchar(10),
@FecMdf datetime
AS
UPDATE dbo.Lote SET Descripcion=@desc,FecFabricacion=@fabri,FecCaducidad=@caduc,
UsuModf = @UsuMdf, FecModf = @FecMdf
WHERE ruce=@cod and cd_lote=@cod_lote 

-- Leyenda
-- LEO 01/03/2013 <Creacion>
GO
