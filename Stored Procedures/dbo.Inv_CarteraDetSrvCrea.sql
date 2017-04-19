SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraDetSrvCrea]
@RucE nvarchar(11),
@Cd_Ct char(3),
@Cd_Srv char(7),
@msj varchar(100) output
as
if exists (select * from CarteraProdDet_S where RucE=@RucE and Cd_Ct=@Cd_Ct and Cd_Srv=@Cd_Srv)
	set @msj = 'Cartera ' + @Cd_Ct + 'ya tiene un detalle'
else
begin
	insert into CarteraProdDet_S(RucE,Cd_Ct,Cd_Srv,Estado)
		   Values(@RucE,@Cd_Ct,@Cd_Srv,1)
	
	if @@rowcount <= 0
	set @msj = 'Detalle de Cartera de Servicios no pudo ser registrado'	
end
print @msj
-------------
--J : 29-03-2010 <creado>
GO
