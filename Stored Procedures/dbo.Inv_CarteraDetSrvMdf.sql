SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraDetSrvMdf]
@RucE nvarchar(11),
@Cd_Ct char(3),
@Cd_Srv char(7),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from CarteraProdDet_S where RucE=@RucE and Cd_Ct=@Cd_Ct and Cd_Srv=@Cd_Srv)
	set @msj = 'No existe'
else
begin
	update CarteraProdDet_S set Estado=@Estado
		 where RucE=@RucE and Cd_Ct=@Cd_Ct and Cd_Srv=@Cd_Srv
	
	if @@rowcount <= 0
	set @msj = 'Detalle de Cartera de Servicios no pudo ser modificado'	
end
print @msj
-------------
--J : 29-03-2010 <creado>
GO
