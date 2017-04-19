SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[Com_SolicitudComCrea_1]--Creacion de Solicitud de Compras
@RucE nvarchar(11),
@Cd_SCo char(10)output,
@NroSC varchar(15),
@FecEmi datetime,
@FecEntR datetime,
@Cd_FPC nvarchar(2),
@Asunto varchar(100),
@Cd_Area nvarchar(6),
@Obs varchar(1000),
@Elaboradopor varchar(100),
@Autorizadopor varchar(100),
@Cd_SR char(10),
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
set @Cd_SCo= user123.Cd_SC(@RucE)
if exists (select * from SolicitudCom where RucE=@RucE and Cd_SCo=@Cd_SCo) --and NroSC = @NroSC)
	set @msj = 'Ya existe la Solicitud de Compra N°'+' '+@Cd_SCo
else
begin
	
	insert into SolicitudCom
		    (RucE,Cd_SCo,NroSC,FecEmi,FecEntR,Cd_FPC,Asunto,Cd_Area,Obs,
		     ElaboradoPor,AutorizadoPor,Cd_SR,FecReg,FecMdf,UsuCrea,UsuMdf,Id_EstSC,
		Cd_CC,Cd_SC,Cd_SS,CA01,CA02,CA03,CA04,CA05)
	       Values
		    (@RucE,@Cd_SCo,@NroSC,@FecEmi,@FecEntR,@Cd_FPC,@Asunto,@Cd_Area,@Obs,
                     @Elaboradopor,@Autorizadopor,@Cd_SR,getdate(),null,@UsuCrea,null,'01',
		@Cd_CC,@Cd_SC,@Cd_SS,@CA01,@CA02,@CA03,@CA04,@CA05)	
	if @@rowcount <= 0
	set @msj = 'Solicitud de Compra no pudo ser registrado'	
end
print @msj
--J : 04-05-2010 - <Creado>
--J : 04-10-2010 - <Modificado-Se agrego el campo Cd_SR>
GO
