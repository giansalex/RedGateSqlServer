SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnSplit](
    @sParametroList VARCHAR(MAX) -- Cadena de datos a separar
  , @cDelimitador VARCHAR(8000) = ',' -- Separador de Datos
) RETURNS @ListaTemporal TABLE (item VARCHAR(MAX))

BEGIN
	DECLARE @sItem VARCHAR(8000)
	WHILE CHARINDEX(@cDelimitador,@sParametroList,0) <> 0
	 BEGIN
 		SELECT
			@sItem=RTRIM(LTRIM(SUBSTRING(@sParametroList,1,CHARINDEX(@cDelimitador,@sParametroList,0)-1))),
			@sParametroList=RTRIM(LTRIM(SUBSTRING(@sParametroList,CHARINDEX(@cDelimitador,@sParametroList,0)+LEN(@cDelimitador),LEN(@sParametroList))))
		IF LEN(@sItem) > 0
			INSERT INTO @ListaTemporal SELECT @sItem
	END
	IF LEN(@sParametroList) > 0
		INSERT INTO @ListaTemporal SELECT @sParametroList -- Coloca luego del último elemento
	RETURN
END
GO
