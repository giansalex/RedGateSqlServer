SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudReqMdf] --Modificacion de Solicitud de Requerimientos
@RucE nvarchar(11),
@Cd_SR char(10),
@NroSR varchar(15),
@FecEmi datetime,
@FecEntR datetime,
@Asunto varchar(100),
@Cd_Area nvarchar(6),
@Obs varchar(1000),
@Elaboradopor varchar(100),
@Autorizadopor varchar(100),
@FecMdf datetime,
@UsuMdf nvarchar(10),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@msj varchar(100) output
as
if not exists (select * from SolicitudReq where RucE=@RucE and Cd_SR=@Cd_SR and NroSR = @NroSR)
	set @msj = 'Ya existe la Solicitud de Requerimientos NÂ°'+' '+@NroSR
else
begin
	--set @Cd_SR= user123.Cd_SR(@RucE)
	Update SolicitudReq set FecEmi=@FecEmi,FecEntR=@FecEntR,Asunto=@Asunto,Cd_Area=@Cd_Area,
		     Obs=@Obs,ElaboradoPor=@Elaboradopor,AutorizadoPor=@Autorizadopor,
			FecMdf=@FecMdf,UsuMdf=@UsuMdf,Cd_CC=@Cd_CC,Cd_SR=@Cd_SR,
			Cd_SS = @Cd_SS,CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05
		Where RucE=@RucE and Cd_SR=@Cd_SR and NroSR = @NroSR

	if @@rowcount <= 0
	set @msj = 'Solicitud de Requerimientos no pudo ser modificado'	
end
print @msj
--J : 09-09-2010 - <Creacion del Procedimiento Almacenado>
--MP: 12-10-2010 - <Modificacion> Se generaba un codigo nuevo en vez de usar el que se enviaba por parametros

GO
