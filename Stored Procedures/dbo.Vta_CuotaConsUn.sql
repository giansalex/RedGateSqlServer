SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Vta_CuotaConsUn]
@RucE nvarchar(11),
@Cd_EC int,
@Cd_Cuo int,
@msj varchar(100) output
as

if not exists (select * from Cuota where RucE = @RucE and Cd_EC=@Cd_EC and Cd_Cuo=@Cd_Cuo)
	set @msj = 'Cuota no existe'
else	
	select * from Cuota where RucE = @RucE and Cd_EC= @Cd_EC and Cd_Cuo = @Cd_Cuo
print @msj


--MP : 27/05/2011 : <Creacion del procedimiento almacenado>

GO
