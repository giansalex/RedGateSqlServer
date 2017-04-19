SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_VoucherConsXFab]
@RucE nvarchar(11),
@Cd_Fab nvarchar(10),
@msj varchar(100) output
as

select fc.*, vou.MtoD, vou.MtoH, vou.MtoD_ME,vou.MtoH_ME
		from voucher vou  
		inner join FabComprobante fc on vou.RucE=fc.RucE and vou.RegCtb = fc.RegCtb and vou.NroCta= fc.NroCta
		where fc.RucE= @RucE and fc.Cd_Fab=@Cd_Fab
			
print @msj

--Leyenda
--CE : 22/02/2013 <Creacion del SP>

-- exec Fab_VoucherConsXFab '11111111111','FAB0000006',null
GO
