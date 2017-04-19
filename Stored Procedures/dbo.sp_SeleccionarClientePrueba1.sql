SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_SeleccionarClientePrueba1]
@RucE nvarchar(11),
@RSocial varchar(150)
AS
BEGIN

select NDoc from Cliente2 where RucE=@RucE and RSocial=@RSocial

END
GO
