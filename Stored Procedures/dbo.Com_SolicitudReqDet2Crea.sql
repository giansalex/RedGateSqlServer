SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Com_SolicitudReqDet2Crea]
@RucE nvarchar(11),
@Cd_SR char(10),
@Item int,
@Cd_Prod char(7),
@Id_UMP int,
@Cd_Srv char(7),
@Descrip varchar(200),
@Cant numeric(20,10),
@Obs varchar(4000),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@CA06 varchar(100),
@CA07 varchar(100),
@CA08 varchar(500),
@CA09 varchar(500),
@CA10 varchar(1000),
@msj varchar(100) output
as
if exists(select * from SolicitudReqDet2 where RucE=@RucE and Cd_SR=@Cd_SR and Item=@Item)
	set @msj = 'Detalle de solicitud de requerimientos ya existe'
else
begin 
	set @Item = dbo.Itm_SR2(@RucE,@Cd_SR)
	insert into SolicitudReqDet2
	  ([RucE]
      ,[Cd_SR]
      ,[Item]
      ,[Cd_Prod]
      ,[ID_UMP]
      ,[Cd_Srv]
      ,[Descrip]
      ,[Cant]
      ,[Obs]
      ,[FecCrea]
      ,[FecMdf]
      ,[Cd_CC]
      ,[Cd_SC]
      ,[Cd_SS]
      ,[IC_EstadoPS]
      ,[IC_EstadoInv]
      ,[CA01]
      ,[CA02]
      ,[CA03]
      ,[CA04]
      ,[CA05]
      ,[CA06]
      ,[CA07]
      ,[CA08]
      ,[CA09]
      ,[CA10])
	values(@RucE,@Cd_SR,@Item,@Cd_Prod,@Id_UMP,@Cd_Srv,@Descrip,@Cant,@Obs,getdate(),null,@Cd_CC,@Cd_SC,@Cd_SS,0,0,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10)
	
	if @@rowcount <= 0
	begin
		set @msj = 'Detalle de Solicitud de requerimientos no pudo ser creado'
	end
end
print @msj
GO
