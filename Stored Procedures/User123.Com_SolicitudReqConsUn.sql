SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [User123].[Com_SolicitudReqConsUn]
@RucE nvarchar(11),
@Cd_SR char(10),
@msj varchar(100) output

as 
if not exists (select * from SolicitudReq where RucE=@RucE and Cd_SR=@Cd_SR)
	Set @msj = 'No existe Solicitud de Requerimientos'
else
begin
	select sco.RucE,sco.Cd_SR,sco.NroSR,Convert(varchar,sco.FecEmi,103)as FecEmi,
	      Convert(varchar,sco.FecEntR,103)as FecEntR,
	       Asunto,Cd_Area,Obs,ElaboradoPor,AutorizadoPor,
	       Convert(varchar,sco.FecReg,103)as FecReg,
	       Convert(varchar,sco.FecMdf,103)as FecMdf,
	       UsuCrea,UsuMdf,Id_EstSR,isnull(TipAut,0) as 'TipAut',Descriptip,Cd_CC,Cd_SC,Cd_SS,
	       CA01,CA02,CA03,CA04,CA05
	from 
	       SolicitudReq sco left join cfgAutorizacion aut on Cd_DMA = 'SR' and sco.TipAut = aut.tipo
	where 
               sco.RucE=@RucE and Cd_SR=@Cd_SR
end
GO
