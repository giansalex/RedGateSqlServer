SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Com_SolicitudReq2Crea]
@RucE nvarchar(11),
@Cd_SR char(10)output,
@NroSR varchar(15),
@FecEmi smalldatetime,
@FecEnt smalldatetime,
@Asunto varchar(200),
@Cd_Area nvarchar(6),
@Obs varchar(4000),
@Elaboradopor varchar(100),
@UsuCrea nvarchar(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@TipAut int,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@CA06 varchar(100),
@CA07 varchar(100),
@CA08 varchar(100),
@CA09 varchar(100),
@CA10 varchar(100),
@CA11 varchar(500),
@CA12 varchar(500),
@CA13 varchar(500),
@CA14 varchar(500),
@CA15 varchar(500),
@CA16 varchar(1000),
@CA17 varchar(1000),
@CA18 varchar(1000),
@CA19 varchar(1000),
@CA20 varchar(1000),
@CA21 varchar(4000),
@CA22 varchar(4000),
@CA23 varchar(4000),
@CA24 varchar(4000),
@CA25 varchar(4000),
@msj varchar(100) output
as
set @Cd_SR= user123.Cd_SR2(@RucE)
if exists (select * from SolicitudReq where RucE=@RucE and Cd_SR=@Cd_SR and NroSR = @NroSR)
	set @msj = 'Ya existe la Solicitud de Requerimientos NÃ‚Â°'+' '+@NroSR
else
begin
	insert into SolicitudReq2
	  ([RucE]
      ,[Cd_SR]
      ,[NroSR]
      ,[FecEmi]
      ,[FecEnt]
      ,[Asunto]
      ,[Cd_Area]
      ,[Obs]
      ,[ElaboradoPor]
      ,[FecCrea]
      ,[FecMdf]
      ,[UsuCrea]
      ,[UsuMdf]
      ,[Cd_CC]
      ,[Cd_SC]
      ,[Cd_SS]
      ,[TipAut]
      ,[IB_EsAut]
      ,[IB_Anulado]
      ,[IB_Eliminado]
      ,[CA01]
      ,[CA02]
      ,[CA03]
      ,[CA04]
      ,[CA05]
      ,[CA06]
      ,[CA07]
      ,[CA08]
      ,[CA09]
      ,[CA10]
      ,[CA11]
      ,[CA12]
      ,[CA13]
      ,[CA14]
      ,[CA15]
      ,[CA16]
      ,[CA17]
      ,[CA18]
      ,[CA19]
      ,[CA20]
      ,[CA21]
      ,[CA22]
      ,[CA23]
      ,[CA24]
      ,[CA25])
	Values
	    (@RucE,@Cd_SR,@NroSR,@FecEmi,@FecEnt,@Asunto,@Cd_Area,@Obs,
             @Elaboradopor,getdate(),null,@UsuCrea,null,@Cd_CC,@Cd_SC,@Cd_SS,
             isnull(@TipAut,0),0,0,0,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,
             @CA11,@CA12,@CA13,@CA14,@CA15,@CA16,@CA17,@CA18,@CA19,@CA20,@CA21,@CA22,@CA23,@CA24,@CA25)
	if @@rowcount <= 0
	set @msj = 'Solicitud de Requerimientos no pudo ser registrado'	
end
print @msj
GO
