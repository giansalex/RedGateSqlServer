SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReporteFinancieroCons_CodREF]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@msj varchar(100) output

AS

DECLARE @Cod_REF TABLE
(	codigo nvarchar(5) not null )
DECLARE @c int SET @c=10
DECLARE @i int SET @i=1
DECLARE @val nvarchar(5)
WHILE(@i<=@c)
BEGIN
	SET @val = 'REF'+right('00'+ltrim(@i),2)
	INSERT INTO @Cod_REF VALUES(@val)
	SET @i=@i+1
END

SELECT codigo FROM @Cod_REF 
WHERE codigo not in (Select Cd_REF From ReporteFinanciero Where RucE=@RucE and Ejer=@Ejer)
ORDER BY 1

-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>

GO
