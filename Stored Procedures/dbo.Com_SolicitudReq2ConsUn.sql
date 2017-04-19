SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Com_SolicitudReq2ConsUn]
@RucE nvarchar(11),
@Cd_SR char(10),
@msj varchar(100) output

as 
if not exists (select * from SolicitudReq2 where RucE=@RucE and Cd_SR=@Cd_SR)
	Set @msj = 'No existe Solicitud de Requerimientos'
else
begin
	select sco.RucE,sco.Cd_SR,sco.NroSR,Convert(varchar,sco.FecEmi,103)as FecEmi,
	      Convert(varchar,sco.FecEnt,103)as FecEnt,
	       Asunto,Cd_Area,Obs,ElaboradoPor,
	       Convert(varchar,sco.FecCrea,103)as FecCrea,
	       Convert(varchar,sco.FecMdf,103)as FecMdf,
	       UsuCrea,UsuMdf,Cd_CC,Cd_SC,Cd_SS,isnull(TipAut,0) as 'TipAut',IB_EsAut,IB_Anulado,IB_Eliminado,
	       CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,CA11,CA12,CA13,CA14,CA15,CA16,CA17,CA18,CA19,
	       CA20,CA21,CA22,CA23,CA24,CA25
	from 
	       SolicitudReq2 sco left join cfgAutorizacion aut on Cd_DMA = 'SR' and sco.TipAut = aut.tipo
	where 
               sco.RucE=@RucE and Cd_SR=@Cd_SR
end
GO
