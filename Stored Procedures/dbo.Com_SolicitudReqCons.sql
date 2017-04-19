SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Com_SolicitudReqCons]
@RucE nvarchar(11),
@EstaAut bit,
@msj varchar(100) output
as
BEGIN

IF(@EstaAut=1)
BEGIN
select top 30 sr.Cd_SR,sr.NroSR, Convert(varchar,sr.FecEmi,103) as FecEmi, Convert(varchar,sr.FecEntR,103) as FecEntR, sr.Asunto ,est.Descrip
from SolicitudReq sr 
Left Join EstadoSR est on est.Id_EstSR = sr.Id_EstSR
Where sr.IB_Aut=1 and sr.RucE=@RucE and sr.Id_EstSR in ('04','05','01','02')
order by Cd_SR desc
END
ELSE IF(@EstaAut=0)
BEGIN
select top 30 sr.Cd_SR,sr.NroSR, Convert(varchar,sr.FecEmi,103) as FecEmi, Convert(varchar,sr.FecEntR,103) as FecEntR, sr.Asunto ,est.Descrip
from SolicitudReq sr 
Left Join EstadoSR est on est.Id_EstSR = sr.Id_EstSR
Where sr.RucE=@RucE --and sr.Id_EstSR in ('04','05','01','02')
order by Cd_SR desc
END
END
print @msj
-- Leyenda --
-- J : 13-12-2010 : <Creacion del procedimiento almacenado>
--Ja : 22/09/2011 : <Modificacion del procedimiento> comente la linea de Id_EstSR
--exec dbo.Com_SolicitudReqCons '20528206931',0,null

GO
