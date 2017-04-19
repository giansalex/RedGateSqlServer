SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudReqDetCrea3]
@RucE nvarchar(11),
@Cd_SR char(10),
@Item int,
@Cd_Prod char(7),
@Cd_Srv char(7),
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
@IB_AtSrv bit,
@msj varchar(100) output
as
if exists(select * from SolicitudReqDet where RucE=@RucE and Cd_SR=@Cd_SR and Item=@Item)--user123.Itm_SC(@RucE,@Cd_SC))
	set @msj = 'Detalle de solicitud de requerimientos ya existe'
else
begin 
	set @Item = user123.Itm_SR(@RucE,@Cd_SR)
	insert into SolicitudReqDet(RucE,Cd_SR,Item,Cd_Prod,Cd_Srv,Descrip,Id_UMP,Cant,Obs,FecMdf,UsuMdf,CA01,CA02,CA03,CA04,CA05,IB_AtSrv)
	values(@RucE,@Cd_SR,@Item,@Cd_Prod,@Cd_Srv,@Descrip,@Id_UMP,@Cant,@Obs,getdate(),@UsuMdf,@CA01,@CA02,@CA03,@CA04,@CA05,@IB_AtSrv)
	
	if @@rowcount <= 0
	begin
		set @msj = 'Detalle de Solicitud de requerimientos no pudo ser creado'
	end

end
print @msj
--	LEYENDA
/*	MM : <06/08/11 : Creacion del SP>
	
*/
GO
