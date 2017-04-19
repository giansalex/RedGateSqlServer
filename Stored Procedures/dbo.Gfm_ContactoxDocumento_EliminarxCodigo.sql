SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gfm_ContactoxDocumento_EliminarxCodigo] 
@RucE nvarchar(11),
@Codigo nvarchar(10),
@msj varchar(100) output
AS 
if exists (select * from ContactoxDocumento where RucE = @RucE and Codigo = @Codigo)
begin
		delete from ContactoxDocumento where RucE = @RucE and Codigo = @Codigo
end


GO
