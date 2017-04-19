SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[Fab_ComprobanteConsFab]
@RucE nvarchar(11),
@Cd_Fab char (10),
--@Estado bit,
@msj varchar(100) output
as	
	select Ruce,cd_Fab,ID_Com,Ejer,RegCtb,NroCta,CostoAsig,CostoAsig_ME--,sum(CostoAsig) as Total
 from FabComprobante where RucE= @RucE and Cd_Fab = @Cd_Fab
	

print @msj

--Leyenda

--BG : 18/02/2013 <se creo el SP--(°)> >
	--exec Fab_ComprobanteConsFab '11111111111','FAB0000012',''
	--select * from FabComprobante
--select * from Voucher where RucE = '11111111111' and Ejer = '2013' and RegCtb = 'CTGE_CB01-00001' and NroCta = '67.6.1.10'--and NroCta = '94.2.1.10'

GO
