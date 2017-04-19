SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Com_SolicitudReq2Mdf]
@RucE nvarchar(11),
@Cd_SR char(10),
@NroSR varchar(15),
@FecEmi smalldatetime,
@FecEnt smalldatetime,
@Asunto varchar(200),
@Cd_Area nvarchar(6),
@Obs varchar(4000),
@Elaboradopor varchar(100),
@UsuMdf nvarchar(10),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
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
if not exists (select * from SolicitudReq2 where RucE=@RucE and Cd_SR=@Cd_SR and NroSR = @NroSR)
	set @msj = 'Ya existe la Solicitud de Requerimientos NÂ°'+' '+@NroSR
else
begin
	Update SolicitudReq2 set FecEmi=@FecEmi,FecEnt=@FecEnt,Asunto=@Asunto,Cd_Area=@Cd_Area,
		     Obs=@Obs,ElaboradoPor=@Elaboradopor,FecMdf=GETDATE(),UsuMdf=@UsuMdf,Cd_CC=@Cd_CC,Cd_SR=@Cd_SR,
			Cd_SS = @Cd_SS,TipAut = isnull(@TipAut,0),CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05,
			CA06=@CA06,CA07=@CA07,CA08=@CA08,CA09=@CA09,CA10=@CA10,CA11=@CA11,CA12=@CA12,CA13=@CA13,CA14=@CA14,
			CA15=@CA15,CA16=@CA16,CA17=@CA17,CA18=@CA18,CA19=@CA19,CA20=@CA20,CA21=@CA21,CA22=@CA22,CA23=@CA23,
			CA24=@CA24,CA25=@CA25
		Where RucE=@RucE and Cd_SR=@Cd_SR and NroSR = @NroSR

	if @@rowcount <= 0
	set @msj = 'Solicitud de Requerimientos no pudo ser modificado'	
end
print @msj
GO
