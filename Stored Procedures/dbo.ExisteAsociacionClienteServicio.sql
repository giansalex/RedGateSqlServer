SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[ExisteAsociacionClienteServicio](
@RucE nvarchar(11),
@Cd_Srv char(7),
@Cd_Clt char(10),
@Existe bit output
)
As
if exists(select * From ServCliente Where RucE = @RucE And Cd_Srv = @Cd_Srv And Cd_Clt = @Cd_Clt)
begin
	Set @Existe = 1
end
Else
bEGIN
	Set @Existe = 0
End
GO
