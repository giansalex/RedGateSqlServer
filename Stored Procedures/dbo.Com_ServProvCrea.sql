SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_ServProvCrea] -- <Procedimiento que registra ServProv>
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_Srv char(7),
@CodigoAlt varchar(15),
@DescripAlt varchar(100),
@Obs varchar(200),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@msj varchar(100) output
as
if exists (select * from ServProv where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_Srv=@Cd_Srv)
	set @msj = 'Este proveedor ya tiene registrado este servicio'
else
begin
	insert into ServProv(RucE,Cd_Prv,Cd_Srv,CodigoAlt,DescripAlt,Obs,CA01,CA02,CA03)
	values(@RucE,@Cd_Prv,@Cd_Srv,@CodigoAlt,@DescripAlt,@Obs,@CA01,@CA02,@CA03)	
	
	if @@rowcount <= 0
	set @msj = 'Servicio pudo ser registrado'	
end
-- Leyenda --
-- FL : 2010-08-26 : <Creacion del procedimiento almacenado>
print @msj

GO
