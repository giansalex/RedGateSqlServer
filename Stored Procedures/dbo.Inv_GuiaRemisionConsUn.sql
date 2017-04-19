SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionConsUn]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as
if not exists (select * from GuiaRemision where Cd_GR=@Cd_GR and RucE = @RucE)
	set @msj = 'Guia Remision no existe'
else	select * from GuiaRemision where Cd_GR=@Cd_GR and RucE = @RucE
print @msj

GO
