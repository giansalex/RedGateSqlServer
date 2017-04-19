SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  procedure [user321].[Rpt_GuiaRemisionImpresionMasiva]
@CodigoGuias varchar(2000),
@RucE nvarchar(11),
@NroSre varchar(5),
@NroGR varchar(15)
as
/*
declare @CodigoGuias varchar(2000)
declare @RucE nvarchar(11)
declare @NroSre varchar(5)
declare @NroGR varchar(15)

set @CodigoGuias = 'GR00000003,GR00000024,GR00000029'
set @RucE = '11111111111'
set @NroSre = '0001'
*/
--select Cd_clt from guiaremision where Ruce='11111111111'/*@RucE*/ and (Cd_GR in (select n from #temp ))

---creamos un  arreglo de todos los codigos
--DECLARE @Rucs varchar(8000)
--SET @Rucs = 'GR00000003,GR00000024,GR00000029'

DECLARE @xml varchar(4000)
SET @xml = '<ns><n>' + REPLACE(@CodigoGuias, ',', '</n><n>') + '</n></ns>'

DECLARE @xmlDoc int
EXEC sp_xml_preparedocument @xmlDoc OUT, @xml
--creamos un temporal con los codigos
SELECT n into #temp
FROM OPENXML (@xmlDoc, '/ns/n') WITH (n varchar(12) '.')

EXEC sp_xml_removedocument @xmlDoc

-----------------------------------------------------

--datos guia remision
select 	GR.RucE, GR.Cd_GR, GR.FecEmi, GR.FecIniTras, GR.NroSre, GR.NroGR, GR.AutorizadoPor, GR.PtoPartida,GRL.PtoLlegada,
	tr.RucT,tr.LicCond,tr.NroPlaca,tr.McaVeh,case(isnull(len(GR.Cd_Tra),0)) when 0 then GR.DescripTra else tr.Sres end as Sres,
	GR.Cd_TO,tp.Nombre as TipoOperacion

from 	(select GR.RucE, GR.Cd_GR, convert(nvarchar,GR.FecEmi,103) as FecEmi , convert(nvarchar,GR.FecIniTras,103) as FecIniTras,
	 GR.NroSre,GR.NroGR, GR.AutorizadoPor, GR.PtoPartida,GR.Cd_Tra,GR.DescripTra,GR.Cd_TO from GuiaRemision GR  where (Cd_GR in (select n from #temp )) and RucE=@RucE)as GR
	left join (select top 1 RucE,Cd_GR, Obs as Obs, Direc as PtoLlegada from GRPtoLlegada where (Cd_GR in (select n from #temp )) and RucE=@RucE) as GRL
	 on GRL.RucE=GR.RucE and GRL.Cd_GR=GR.Cd_GR
	left join (select tr.RucE, tr.Cd_Tra, tr.NDoc as RucT,tr.LicCond,tr.NroPlaca,tr.McaVeh,
	 case(isnull(len(tr.RSocial),0)) when 0 then tr.ApPat + ' ' + tr.ApMat + ', ' + tr.Nom else tr.RSocial end as Sres
from 	transportista tr where RucE=@RucE) as tr on tr.Cd_Tra=GR.Cd_Tra and tr.RucE=GR.RucE
	left join TipoOperacion tp on tp.Cd_TO=GR.Cd_TO
 



--detalle guia remision
select GRD.RucE,GRD.Cd_GR,GRD.Item, GRD.Cd_Prod as Codigo, GRD.PesoCantKg as Kilos, GRD.Cant as Cantidad, GRD.ID_UMP as UMedida ,isnull(P2.NCorto,'') as NCorto, P2.NOmbre1 as Detalle
from GuiaRemisionDet GRD inner join Producto2 P2 on P2.Cd_Prod=GRD.Cd_Prod and P2.RucE=GRD.RucE
where (GRD.Cd_GR in (select n from #temp )) and GRD.RucE=@RucE


--Destinario
declare @Cd_CltAux char(10)
set @Cd_CltAux= (select Cd_clt from guiaremision where Ruce=@RucE and (Cd_GR in (select n from #temp ))) /*=@Cd_GR*/
if(@Cd_CltAux is null) 
begin select top 1 @Cd_CltAux=Vta.Cd_Clt from Venta vta
inner join guiaremisiondet GRD on GRD.RucE=vta.RucE and GRD.Cd_Vta= vta.Cd_Vta
where GRD.Ruce=@RucE and (GRD.Cd_GR in (select n from #temp)) end

print @Cd_CltAux

select case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat +' '+ cl.ApMat +','+ cl.Nom else cl.RSocial end as Destinario, cl.RucE, tipd.NCorto, cl.NDoc
from cliente2 cl
inner join TipDoc tipd on tipd.Cd_TD=cl.Cd_TDI
where cl.Cd_Clt=@Cd_CltAux and RucE=@RucE

drop table #temp


GO
