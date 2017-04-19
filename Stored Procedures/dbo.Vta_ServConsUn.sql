SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ServConsUn]
@RucE nvarchar(11),
@Cd_Srv nvarchar(7),
@msj varchar(100) output
as
if not exists (select * from Servicio where RucE=@RucE and Cd_Srv=@Cd_Srv)
	set @msj = 'Servicio no existe'
else	select a.*,b.Cd_GS,b.UsuCrea,b.UsuMdf,b.FecReg,b.FecMdf from Producto a, Servicio b where  a.RucE=@RucE and a.Cd_Pro=@Cd_Srv and b.RucE=@RucE and b.Cd_Srv=@Cd_Srv
print @msj
GO
