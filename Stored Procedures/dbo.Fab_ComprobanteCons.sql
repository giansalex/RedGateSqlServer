SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_ComprobanteCons]
@RucE nvarchar(11),
@Ejer char(4),
--@Estado bit,
@msj varchar(100) output
as
	if not exists (select * from FabComprobante where RucE = @RucE)
	set @msj = 'Comprobante de Fabricacion no existe.'
else	
	select f.RucE,f.Ejer, f.RegCtb, f.NroCta,
	v.MtoD-v.MtoH as TotalVoucher,
	sum(f.CostoAsig) as CostoAsigTotal , 
	(v.MtoD-v.MtoH)-sum(f.CostoAsig) as MaxAsig,	
	v.MtoD_ME-v.MtoH_ME as TotalVoucher_ME,
	sum(f.CostoAsig_ME) as CostoAsigTotal_ME , 
	(v.MtoD_ME-v.MtoH_ME)-sum(f.CostoAsig_ME) as MaxAsig_ME
	from FabComprobante f 
	inner join Voucher v on v.RucE=f.RucE and v.RegCtb=f.RegCtb and v.NroCta=f.NroCta
	where f.RucE=@RucE and f.Ejer=@Ejer
	group by f.RegCtb, f.NroCta, f.RucE, v.MtoD, v.MtoH,v.MtoD_ME, v.MtoH_ME, f.Ejer
print @msj

--Leyenda

--BG : 08/02/2013 <se creo el SP--(°)> >

	--exec Fab_ComprobanteCons '11111111111','2013',null
GO
