SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CampoConsUn]
@RucE nvarchar(11),
@Cd_Cp nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from Campo where RucE=@RucE and Cd_Cp=@Cd_Cp)
	set @msj = 'No existe Campo'
else	select * from Campo where RucE=@RucE and Cd_Cp=@Cd_Cp
print @msj
GO
