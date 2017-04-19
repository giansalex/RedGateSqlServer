SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_UniMedConsUn]
@Cd_UM nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from UnidadMedidad where Cd_UM=@Cd_UM)
	set @msj = 'Unidad de Medidad no existe'
else    select * from UnidadMedida where Cd_UM=@Cd_UM
print @msj
GO
