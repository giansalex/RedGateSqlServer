SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[FabComprobanteListFab]
@RucE nvarchar(11),
@Ejer char(4),
@RegCtb nvarchar(30),
@NroCta nvarchar(20),
--@Estado bit,
@msj varchar(100) output
as
	if not exists (select * from FabComprobante where RucE = @RucE)
	set @msj = 'Comprobante de Fabricacion no existe.'
else	
	select f.RucE,f.Cd_Fab, f.Id_Com, f.Ejer, f.RegCtb, f.NroCta, f.CostoAsig,f.CostoAsig_ME,
	v.MtoD-v.MtoH as TotalV, v.MtoD_ME-v.MtoH_ME as TotalV_ME
	from FabComprobante f
	inner join voucher v on v.RucE=f.RucE and v.Ejer=f.Ejer and v.RegCtb=f.RegCtb and v.nroCta=f.NroCta
	where f.RucE=@RucE and f.Ejer=@Ejer and f.RegCtb=@RegCtb and f.NroCta=@NroCta
print @msj

--Leyenda

--CE : 14/02/2013 <se creo el SP>

	--exec FabComprobanteListFab '11111111111','2013','CPGE_RC02-00001','94.2.1.10',null
GO
