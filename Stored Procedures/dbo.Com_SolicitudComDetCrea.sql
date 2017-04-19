SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudComDetCrea]
@RucE nvarchar(11),
@Cd_SC char(10),
@Item int,
@Cd_Prod char(7),
@Descrip varchar(200),
@Id_UMP int,
@Cant decimal(13,3),
@Obs varchar(200),
@UsuMdf nvarchar(10),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@msj varchar(100) output
as
if exists(select * from SolicitudComDet where RucE=@RucE and Cd_SC=@Cd_SC and Item=@Item)--user123.Itm_SC(@RucE,@Cd_SC))
	set @msj = 'Detalle de solicitud de compra ya existe'
else
begin 
	set @Item = user123.Itm_SC(@RucE,@Cd_SC)
	insert into SolicitudComDet(RucE,Cd_SC,Item,Cd_Prod,Descrip,Id_UMP,Cant,Obs,FecMdf,UsuMdf,CA01,CA02,CA03,CA04,CA05)
	values(@RucE,@Cd_SC,@Item,@Cd_Prod,@Descrip,@Id_UMP,@Cant,@Obs,getdate(),@UsuMdf,@CA01,@CA02,@CA03,@CA04,@CA05)
	
	if @@rowcount <= 0
	begin
		set @msj = 'Detalle de Solicitud de compra no pudo ser creado'
	end

end
print @msj
--J -> 05-05-2010 <Creacion del procedimiento almacenado>
GO
