SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Vendedor2ConsUn]
@RucE nvarchar(11),
@Cd_Vdr char(7),
@msj varchar(100) output
as
if not exists (select * from Vendedor2 where RucE=@RucE and Cd_Vdr=@Cd_Vdr)
	set @msj = 'Vendedor no existe'
else		
	select * from Vendedor2 Where RucE=@RucE and Cd_Vdr=@Cd_Vdr
print @msj
-- J 12/03/10 -> creacion
GO
