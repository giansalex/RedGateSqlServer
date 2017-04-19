SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_ComprobanteConsUn]
@RucE nvarchar(11),
@Cd_Fab char(10),
@msj varchar(100) output
as
if not exists (select  Cd_Fab from FabComprobante where Cd_Fab=@Cd_Fab and RucE = @RucE)
	set @msj = 'Comprobante de Fabricación no existe'
else	
	select RucE,Cd_Fab,ID_Com,Ejer,RegCtb,NroCta,CostoAsig from FabComprobante
	where Cd_Fab=@Cd_Fab and RucE = @RucE 
	
print @msj

--Leyenda
--BG : 08/02/2013 <se creo el SP--/(.)(.)\>

--exec Fab_ComprobanteConsUn '11111111111','FAB0000001',''
GO
