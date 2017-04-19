SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[Fab_ComprobanteConsxFab]
@RucE nvarchar(11),
@Cd_Fab char (10),
@Ejer varchar(4),
@msj varchar(100) output
as
	if not exists (select * from FabComprobante where RucE = @RucE and Cd_Fab = @Cd_Fab)
	set @msj = 'Comprobante de Fabricacion no existe.'
else	
	select f.RucE,f.Cd_Fab,f.ID_Com,f.Ejer,f.RegCtb,f.NroCta,f.CostoAsig,f.CostoAsig_ME,
(v.MtoD-v.MtoH) as Total,(v.MtoD_ME-v.MtoH_ME)as Total_ME from FabComprobante as f 
inner join Voucher as v on v.RucE = f.RucE and v.Ejer = f.Ejer and v.RegCtb=f.RegCtb and v.NroCta=f.NroCta
where f.RucE = @RucE and f.Cd_Fab = @Cd_Fab and f.Ejer=@Ejer
	

print @msj

--Leyenda

--BG : 08/02/2013 <se creo el SP--(°)> >

	--exec Fab_ComprobanteConsxFab '11111111111','FAB0000006',''
	
	--select * from FabComprobante



--select * from Voucher where RucE = '11111111111' and Ejer = '2013' and RegCtb = 'CTGE_CB01-00001' and NroCta = '67.6.1.10'--and NroCta = '94.2.1.10'

GO
