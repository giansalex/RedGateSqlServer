SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraDetSrvElim]
@RucE nvarchar(11),
@Cd_Ct char(3),
@Cd_Srv char(7),
@msj varchar(100) output
as
if not exists (select * from CarteraProdDet_S where RucE=@RucE and Cd_Ct=@Cd_Ct and Cd_Srv=@Cd_Srv)
	set @msj = 'No existe Detalle de cartera de servicios'
else
begin
	delete from CarteraProdDet_S
	where RucE=@RucE and Cd_Ct=@Cd_Ct and Cd_Srv=@Cd_Srv
	
	if @@rowcount <= 0
	set @msj = 'Detalle de cartera de servicios no pudo ser modificado'
end
print @msj
-------------
--J : 29-03-2010 <creado>
GO
