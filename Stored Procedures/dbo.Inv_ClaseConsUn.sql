SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ClaseConsUn]
@RucE nvarchar(11),
@Cd_CL nvarchar(8),
@msj varchar(100) output
as
if not exists (select * from Clase where RucE=@RucE and Cd_CL=@Cd_CL)
	set @msj = 'Clase no existe'
else	select * from Clase where RucE=@RucE and Cd_CL=@Cd_CL
print @msj
GO
