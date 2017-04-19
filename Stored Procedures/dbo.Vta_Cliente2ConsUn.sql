SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Cliente2ConsUn]
@RucE nvarchar(11),
@Cd_Clt char(10),
@msj varchar(100) output
as
if not exists (select * from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt)
	set @msj = 'Cliente no existe'
else	select a.* from Cliente2 a where a.RucE=@RucE and a.Cd_Clt=@Cd_Clt
print @msj

GO
