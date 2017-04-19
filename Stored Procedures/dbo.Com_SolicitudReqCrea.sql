SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudReqCrea]--Creacion de Solicitud de Requerimiento
@RucE nvarchar(11),
@Cd_SR char(10)output,
@NroSR varchar(15),
@FecEmi datetime,
@FecEntR datetime,
/*@Cd_FPC nvarchar(2),*/
@Asunto varchar(100),
@Cd_Area nvarchar(6),
@Obs varchar(1000),
@Elaboradopor varchar(100),
@Autorizadopor varchar(100),
@UsuCrea nvarchar(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@msj varchar(100) output
as
/*
Set @Cd_OC = dbo.Cd_OC(@RucE)	
if exists (select * from OrdCompra where RucE=@RucE and Cd_OC=@Cd_OC and NroOC=@NroOC)
	Set @msj = 'Ya existe numero de orden de compra' 
*/
set @Cd_SR= user123.Cd_SR(@RucE)
if exists (select * from SolicitudReq where RucE=@RucE and Cd_SR=@Cd_SR and NroSR = @NroSR)
	set @msj = 'Ya existe la Solicitud de Requerimientos NÂ°'+' '+@NroSR
else
begin
	
	insert into SolicitudReq
	    (RucE,Cd_SR,NroSR,FecEmi,FecEntR,Asunto,Cd_Area,Obs,
	     ElaboradoPor,AutorizadoPor,FecReg,FecMdf,UsuCrea,UsuMdf,Id_EstSR,
	     Cd_CC,Cd_SC,Cd_SS,CA01,CA02,CA03,CA04,CA05)
	Values
	    (@RucE,@Cd_SR,@NroSR,@FecEmi,@FecEntR,@Asunto,@Cd_Area,@Obs,
             @Elaboradopor,@Autorizadopor,getdate(),null,@UsuCrea,null,'01',
	     @Cd_CC,@Cd_SC,@Cd_SS,@CA01,@CA02,@CA03,@CA04,@CA05)	
	if @@rowcount <= 0
	set @msj = 'Solicitud de Requerimientos no pudo ser registrado'	
end
print @msj
--J : 04-05-2010 - <Creado>
--MP: 12-10-2010 - <Modificado> Se eliminó el Cd_FPC ya que no es un campo en la tabla Requerimiento 


GO
