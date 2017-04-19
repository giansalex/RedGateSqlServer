SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Com_SolicitudReqConsOrd]
@RucE nvarchar(11),
@Colum nvarchar(15),
@EstaAut bit,
@msj varchar(100) output
as
BEGIN
declare @consulta varchar(8000)
IF(@EstaAut=1)
BEGIN
set @consulta= 'select sr.Cd_SR,sr.NroSR, Convert(varchar,sr.FecEmi,103) as FecEmi, Convert(varchar,sr.FecEntR,103) as FecEntR, sr.Asunto ,est.Descrip
from SolicitudReq sr 
Left Join EstadoSR est on est.Id_EstSR = sr.Id_EstSR
Where sr.IB_Aut=1 and sr.RucE='''+@RucE+''' and sr.Id_EstSR in (''04'',''05'') 
order by '+@Colum+' desc'
print @consulta
exec (@consulta)
END
ELSE IF(@EstaAut=0)
BEGIN
set @consulta= 'select sr.Cd_SR,sr.NroSR, Convert(varchar,sr.FecEmi,103) as FecEmi, Convert(varchar,sr.FecEntR,103) as FecEntR, sr.Asunto ,est.Descrip
from SolicitudReq sr 
Left Join EstadoSR est on est.Id_EstSR = sr.Id_EstSR
Where sr.RucE='''+@RucE+''' and sr.Id_EstSR in (''04'',''05'') 
order by '+@Colum+' desc'
print @consulta
exec (@consulta)
END

END
print @msj
-- Leyenda --
-- FL : 19-04-2011 : <Creacion del procedimiento almacenado>
--exec dbo.Com_SolicitudReqConsOrd '11111111111','FecEmi',0,null







GO
