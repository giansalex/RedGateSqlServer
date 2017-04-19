SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ServProvModf] --<Procedimiento que modifica los datos de servicios por proveedor>
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
if not exists(select * from ServProv where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_Srv=@Cd_Srv)
	set @msj = 'Error en la seleccion del Servicio'
else
begin
	update ServProv set CodigoAlt=@CodigoAlt,DescripAlt=@DescripAlt,Obs=@Obs,CA01=@CA01,
			    CA02=@CA02,CA03=@CA03
	where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_Srv=@Cd_Srv

	if @@rowcount <= 0
	set @msj = 'Servicio No Pudo Ser Actualizado'	
end
------------
--FL : 08-02-2011 - <creacion del procedimiento almacenado>


GO
