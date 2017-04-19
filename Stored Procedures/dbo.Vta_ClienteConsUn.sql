SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ClienteConsUn]
@RucE nvarchar(11),
@Cd_Aux nvarchar(7),
@msj varchar(100) output
as
if not exists (select * from Auxiliar where RucE=@RucE and Cd_Aux=@Cd_Aux)
	set @msj = 'Auxiliar no existe'
else	select a.*,b.Cta from Auxiliar a, Cliente b where a.RucE=@RucE and a.Cd_Aux=@Cd_Aux and a.RucE=b.RucE and a.Cd_Aux=b.Cd_Aux
print @msj
GO
