SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CampoTConsUn]
@Cd_TC nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from CampoT where Cd_TC=@Cd_TC)
	set @msj = 'Campo Tipo no existe'
else	select * from CampoT where Cd_TC=@Cd_TC
print @msj
GO
