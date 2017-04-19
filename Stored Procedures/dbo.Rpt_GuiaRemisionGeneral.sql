SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_GuiaRemisionGeneral]
@RucE nvarchar(11),
@Cd_GR char(10),
@NroSre varchar(5),
@NroGR varchar(15),
@msj varchar(100) output
as
--guiarem x venta
--guiarem x compra

--nrosre nrogr
if(@Cd_GR='' or @Cd_GR is null)
begin
--print 'aa'
if not exists (select top 1 *from guiaremision where NroSre=@NroSre and NroGR=@NroGR)
set @msj='Guia remision no existe'
else
	begin
declare @CdGRAux char(10)
set @CdGRAux = (select Cd_GR from GuiaRemision where NroSre=@NroSre and NroGR=@NroGR and RucE=@RucE)
--print @CdGRAux

		select 	GR.RucE, GR.Cd_GR, GR.FecEmi, GR.FecIniTras, GR.NroSre, GR.NroGR, GR.AutorizadoPor, GR.PtoPartida,GRL.PtoLlegada,
			tr.RucT,tr.LicCond,tr.NroPlaca,tr.McaVeh,case(isnull(len(GR.Cd_Tra),0)) when 0 then GR.DescripTra else tr.Sres end as Sres,
			GR.Cd_TO,tp.Nombre as TipoOperacion
		from 	(select GR.RucE, GR.Cd_GR, convert(nvarchar,GR.FecEmi,103) as FecEmi , convert(nvarchar,GR.FecIniTras,103) as FecIniTras,
	 		GR.NroSre,GR.NroGR, GR.AutorizadoPor, GR.PtoPartida,GR.Cd_Tra,GR.DescripTra,GR.Cd_TO from GuiaRemision GR  where Cd_GR=@CdGRAux and RucE=@RucE)as GR
			left join (select top 1 RucE,Cd_GR, Direc as PtoLlegada from GRPtoLlegada where Cd_GR=@CdGRAux and RucE=@RucE) as GRL
	 		on GRL.RucE=GR.RucE and GRL.Cd_GR=GR.Cd_GR
			left join (select tr.RucE, tr.Cd_Tra, tr.NDoc as RucT,tr.LicCond,tr.NroPlaca,tr.McaVeh,
	 		case(isnull(len(tr.RSocial),0)) when 0 then tr.ApPat + ' ' + tr.ApMat + ', ' + tr.Nom else tr.RSocial end as Sres
		from 	transportista tr where RucE=@RucE) as tr on tr.Cd_Tra=GR.Cd_Tra and tr.RucE=GR.RucE
			left join TipoOperacion tp on tp.Cd_TO=GR.Cd_TO

--detalle guia remision
		select GRD.Item, GRD.Cd_Prod as Codigo, GRD.PesoCantKg as Kilos, GRD.Cant as Cantidad, GRD.ID_UMP as UMedida ,isnull(P2.NCorto,'') as NCorto, P2.NOmbre1 as Detalle
		from GuiaRemisionDet GRD inner join Producto2 P2 on P2.Cd_Prod=GRD.Cd_Prod and P2.RucE=GRD.RucE
		where GRD.Cd_GR=@CdGRAux and GRD.RucE=@RucE
	end
end
else
begin
--datos guia remision
select 	GR.RucE, GR.Cd_GR, GR.FecEmi, GR.FecIniTras, GR.NroSre, GR.NroGR, GR.AutorizadoPor, GR.PtoPartida,GRL.PtoLlegada,
	tr.RucT,tr.LicCond,tr.NroPlaca,tr.McaVeh,case(isnull(len(GR.Cd_Tra),0)) when 0 then GR.DescripTra else tr.Sres end as Sres,
	GR.Cd_TO,tp.Nombre as TipoOperacion
from 	(select GR.RucE, GR.Cd_GR, convert(nvarchar,GR.FecEmi,103) as FecEmi , convert(nvarchar,GR.FecIniTras,103) as FecIniTras,
	 GR.NroSre,GR.NroGR, GR.AutorizadoPor, GR.PtoPartida,GR.Cd_Tra,GR.DescripTra,GR.Cd_TO from GuiaRemision GR  where Cd_GR=@Cd_GR and RucE=@RucE)as GR
	left join (select top 1 RucE,Cd_GR, Direc as PtoLlegada from GRPtoLlegada where Cd_GR=@Cd_GR and RucE=@RucE) as GRL
	 on GRL.RucE=GR.RucE and GRL.Cd_GR=GR.Cd_GR
	left join (select tr.RucE, tr.Cd_Tra, tr.NDoc as RucT,tr.LicCond,tr.NroPlaca,tr.McaVeh,
	 case(isnull(len(tr.RSocial),0)) when 0 then tr.ApPat + ' ' + tr.ApMat + ', ' + tr.Nom else tr.RSocial end as Sres
from 	transportista tr where RucE=@RucE) as tr on tr.Cd_Tra=GR.Cd_Tra and tr.RucE=GR.RucE
	left join TipoOperacion tp on tp.Cd_TO=GR.Cd_TO

--detalle guia remision
select GRD.Item, GRD.Cd_Prod as Codigo, GRD.PesoCantKg as Kilos, GRD.Cant as Cantidad, GRD.ID_UMP as UMedida ,isnull(P2.NCorto,'') as NCorto, P2.NOmbre1 as Detalle
from GuiaRemisionDet GRD inner join Producto2 P2 on P2.Cd_Prod=GRD.Cd_Prod and P2.RucE=GRD.RucE
where GRD.Cd_GR=@Cd_GR and GRD.RucE=@RucE
--Destinario
declare @Cd_CltAux char(10)
set @Cd_CltAux= (select Cd_clt from guiaremision where Ruce=@RucE and Cd_GR=@Cd_GR)
if(@Cd_CltAux is null) 
begin select top 1 @Cd_CltAux=Vta.Cd_Clt from Venta vta
inner join guiaremisiondet GRD on GRD.RucE=vta.RucE and GRD.Cd_Vta= vta.Cd_Vta
where GRD.Ruce=@RucE and GRD.Cd_GR=@Cd_GR end
--print @Cd_CltAux
select case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat +' '+ cl.ApMat +','+ cl.Nom else cl.RSocial end as Destinario, cl.RucE, tipd.NCorto, cl.NDoc
from cliente2 cl
inner join TipDoc tipd on tipd.Cd_TD=cl.Cd_TDI
where cl.Cd_Clt=@Cd_CltAux and RucE=@RucE
end

--exec Rpt_GuiaRemisionGeneral '11111111111',null,'0001','0000000002',null
--exec Rpt_GuiaRemisionGeneral '11111111111','GR00000002',null,null,null
--select *from producto2 where RucE='11111111111'
--declare @Cd_Cte nvarchar(7)
--select *from guiaxCompra
--set @Cd_Cte=( select *from guiaxVenta gv inner join Venta v on v.Cd_Vta=gv.Cd_Vta and v.RucE=gv.RucE where gv.Cd_GR='GR00000001')
--print @Cd_Cte
--select *from cliente where Cd_Clt=@Cd_Cte and rucE='11111111111'
--select *from venta where rucE='11111111111'

--Leyenda --
-- JJ 2010-08-17:	<creacion del procedimiento almacenado>

--exec Rpt_GuiaRemisionGeneral '11111111111','GR00000003','0001','0000001',null

GO
