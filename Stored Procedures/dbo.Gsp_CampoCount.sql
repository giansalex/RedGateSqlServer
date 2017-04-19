SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CampoCount]
@RucE nvarchar(11),
@NroCA int output,
@msj varchar(100) output
as
set @NroCA=0
if exists ( select top 1 * from Campo where RucE=@RucE)
	set @NroCA = (select count(Cd_Cp) as Total from Campo where RucE=@RucE)
else set @msj = 'No se encontraron campos adicionales'
print @msj
print @NroCA

GO
