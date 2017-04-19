SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudComDetMdf]
@RucE nvarchar(11),
@Cd_SC char(10),
@Item int,
@Descrip varchar(200),
@Obs varchar(200),
--@FecMdf datetime,
@UsuMdf nvarchar(10),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@msj varchar(100) output
as
if not exists(select * from SolicitudComDet where RucE=@RucE and Cd_SC=@Cd_SC and Item=@Item)
	set @msj = 'Detalle de solicitud de compra no existe'
else
begin 
	update SolicitudComDet set Descrip=@Descrip,Obs=@Obs,FecMdf=getdate(),
	UsuMdf=@UsuMdf,CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05
	where RucE=@RucE and Cd_SC=@Cd_SC and Item=@Item	


	if @@rowcount <= 0
	begin
		set @msj = 'Detalle de Solicitud de compra no pudo ser modificado'
	end

end
print @msj
--J -> 05-05-2010 <Creacion del procedimiento almacenado>
GO
