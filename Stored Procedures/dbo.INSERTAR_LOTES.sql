SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[INSERTAR_LOTES]
@usucrea varchar(10),
@descrip NVARCHAR(11),
@feccaduc datetime,
@fecreg DATETIME,
@fecfabri DATETIME  
AS
INSERT INTO LOTE (UsuCrea,Descripcion,FecCaducidad,FecReg,FecFabricacion)
VALUES (@usucrea,@descrip,@feccaduc,@fecreg,@fecfabri)
GO
