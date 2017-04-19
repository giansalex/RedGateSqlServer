SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TransportistaConsUn]
@RucE nvarchar(11),
@Cd_Tra char(7),
@msj varchar(100) output
as
if not exists (select * from Transportista where RucE=@RucE and Cd_Tra=@Cd_Tra)
	set @msj = 'Transportista no existe'
else	select * from Transportista where RucE=@RucE and Cd_Tra=@Cd_Tra
print @msj
GO
