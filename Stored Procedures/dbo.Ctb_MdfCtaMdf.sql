SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Ctb_MdfCtaMdf]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta nvarchar(10),
@Cadena varchar(max),
@msj nvarchar(100) output
AS
BEGIN
	SET NOCOUNT ON;
	exec ('update voucher
	Set NroCta = '''+@NroCta+'''
	where ruce='''+@ruce+''' and ejer='''+@ejer+''' and cd_vou in ('+@cadena+')')
END
GO
