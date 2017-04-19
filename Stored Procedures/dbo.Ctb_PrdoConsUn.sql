SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[Ctb_PrdoConsUn]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@msj varchar(100) output
as
if not exists (select * from Periodo where RucE=@RucE and Ejer=@Ejer)
	set @msj = 'Ejercicio no existe'
else	select * from Periodo where RucE=@RucE and Ejer=@Ejer
print @msj
GO
