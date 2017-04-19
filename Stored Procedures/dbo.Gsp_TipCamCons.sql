SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipCamCons]
@msj varchar(100) output
as
--select FecTC, TCCom, TCVta, TCPro From TipCam
if not exists (select top 1 * from TipCam)
   set @msj = 'No se encontro Tipo de Cambio'
else select * from TipCam Order by year(FecTC) desc ,month(FecTC) desc,day(FecTC) desc
print @msj
GO
