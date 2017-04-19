SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudComConsUn]
@RucE nvarchar(11),
@Cd_SCo char(10),
@msj varchar(100) output

as 
if not exists (select * from SolicitudCom where RucE=@RucE and Cd_SCo=@Cd_SCo)
	Set @msj = 'No existe Solicitud de Compra'
else
begin
	select sco.RucE,sco.Cd_SCo,sco.NroSC,Convert(varchar,sco.FecEmi,103)as FecEmi,Convert(varchar,sco.FecEntR,103)as FecEntR,
	Cd_FPC,Asunto,Cd_Area,Obs,ElaboradoPor,AutorizadoPor,Convert(varchar,sco.FecReg,103)as FecReg,Convert(varchar,sco.FecMdf,103)as FecMdf,
	UsuCrea,UsuMdf,Id_EstSC,Cd_CC,Cd_SC,Cd_SS,CA01,CA02,CA03,CA04,CA05, TipAut,  IB_Aut
	from SolicitudCom sco
	where RucE=@RucE and Cd_SCo=@Cd_SCo
end
print @msj
-- Leyenda --
-- J : 2010-08-09 : <Creacion del procedimiento almacenado>
-- Ejemplo
-- exec Com_SolicitudComConsUn '11111111111','SC00000001',null
-- select * from SolicitudCom
GO
