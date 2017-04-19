SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipCamConsUn]
@FecTC varchar(10),
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

--select FecTC, TCCom, TCVta, TCPro From TipCam
if not exists (select * from TipCam where FecTC=@FecTC and Cd_Mda=@Cd_Mda)
   set @msj = 'No se ha encontrado un Tipo de Cambio para esta fecha. ¿Desea utilizar el último T.C. ingresado?' --GC2016 PV: Mdf 02/05/2016
   --set @msj = 'No se ha encontrado un tipo de cambio para esta fecha. ¿Desea utilizar el tipo de cambio de hoy?'
else select * from TipCam where FecTC=@FecTC and Cd_Mda=@Cd_Mda
print @msj
--PV Vie07-11
--DI Mie04-02-2009
--AC JUE 24-01-2013
GO
