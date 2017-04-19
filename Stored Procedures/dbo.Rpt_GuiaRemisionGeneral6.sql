SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_GuiaRemisionGeneral6]
@RucE nvarchar(11),
@Cd_GR varchar(4000),
@NroSre varchar(5),
@msj varchar (100) output
as
/*set @RucE = '11111111111'
set @Cd_GR = 'GR00000003'
set @NroSre = '0001'
set @NroGR = '0000001'
*/
--select * from GuiaRemision where CD_GR = @CD_GR
--Select * from GuiaRemision where Cd_GR = 'GR00000059'
--select * from venta
--exec [user321].[Rpt_GuiaRemisionGeneral6] '11111111111','GR00000003','','0000001'
/*select * from GuiaXVEnta
left join Venta on Venta.Cd_vta = Guiaxventa.Cd_vta and Venta.Ruce = guiaxventa.ruce
left join GuiaRemision on Guiaremision.ruce = guiaxventa.ruce and guiaxventa.cd_gr = guiaremision.cd_gr
*/

/*Select GuiaRemision.Cd_GR,Venta.Cd_Td, Venta.NroDoc as FacturaNro, Venta. from GuiaRemision
	left join GuiaXVenta on GuiaXVenta.Cd_GR = GuiaRemision.Cd_GR and GuiaXVenta.RucE = GuiaRemision.RucE
	left join Venta on Venta.RucE = GuiaXVenta.RucE and Venta.Cd_Vta = GuiaXVenta.Cd_Vta
where GuiaRemision.CD_GR = @Cd_GR and GuiaRemision.RucE = @Ruce
*/
Declare @SqlValida varchar(1000)
declare @SqlCabecera varchar(8000)
declare @SqlDetalle varchar(8000)
declare @SqlDestinatario varchar(8000)
declare @SqlDocumentosRelacionados varchar(4000)


set @SqlValida = 
'
if not exists(select top 1 * from Guiaremision where RucE = '''+@RucE+''' and Cd_GR in('+ @Cd_GR +'))
set '''+@msj+''' = ''Guia Remision no existe''
else 
begin
'

/******************GUIA REMISION CABECERA *************************************/
set @SqlCabecera = 
'
Select gr.Cd_CC, gr.Cd_SC, gr.Cd_SS,gr.RucE, gr.Cd_GR, gr.FecEmi, gr.FecIniTras, gr.NroSre as NoSerie, gr.NroGR as NumeroGuia,
                gr.AutorizadoPor, gr.PtoPartida, grl.PuntoLlegada, tr.RucT as RucTransp, tr.LicCond, tr.NroPlaca, tr.McaVeh as MarcaVehiculo,
                case(isnull(len(gr.Cd_Tra),0)) when 0 then gr.DescripTra else tr.Sres end as NombTransportista, TipoOP.Nombre as TipoOperacion,
                GR.CA01,GR.CA02,GR.CA03,GR.CA04,GR.CA05,GR.CA06,GR.CA07,GR.CA08,GR.CA09,GR.CA10,GR.Obs
                ,e.RSocial
                ,tr.Direc as DirecTransportista
                ,gr.FecFinTras
                ,gr.UsuCrea
                ,gr.FechaIniTras,tr.CA01 as TRCA01 , 
                tr.CA02 as TRCA02 ,tr.CA03 as TRCA03 , 
                tr.CA04 as TRCA04 ,tr.CA05 as TRCA05 ,
                
              (select udep.Nombre+''-''+upr.Nombre+''-''+ud.Nombre from Empresa e 
			left join UDist ud on ud.Cd_UDt = e.Ubigeo
			left join UProv upr on upr.Cd_UPv = LEFT(ud.Cd_UDt,4)
			left join UDepa udep on udep.Cd_UDp = LEFT(ud.Cd_UDt,2)
			where e.Ruc = '''+@RucE+''') as UbigeoEmpresa
		
from      user321.VGuiaRemision as gr Left join user321.VGuiaRemisionLLegada as GRL on GRL.RucE=GR.RucE and GRL.Cd_GR=GR.Cd_GR
          Left join user321.VTransportistaGRemision as TR on tr.Cd_Tra=GR.Cd_Tra and tr.RucE=GR.RucE
          Left join TipoOperacion TipoOP on TipoOP.Cd_TO=GR.Cd_TO
          left join Empresa e on e.Ruc = gr.RucE
          --left join UProv upr on upr.Cd_UPv  
         -- left join UDist ud on ud.Cd_UDt
         -- left join UDepa udep on udep.Cd_UDp        
Where GR.Cd_GR in ('+@Cd_GR+') and GR.RucE = '''+@RucE+''''

--select * from user321.VTransportistaGRemision
/********************DETALLE GUIA****************************/
set @SqlDetalle = 
'
select    GRD.Item, 
			P2.CodCo1_ as Codigo--grd.Cd_Com
			,GRD.PesoCantKg as Kilos, GRD.Cant as Cantidad, PM.DescripAlt UMedida --GRD.ID_UMP as UMedida
                ,UM.NCorto as NCortoUM,isnull(P2.NCorto,'''') as NCortoProd, P2.Nombre1 as Detalle
		,GRD.CA01 as CA01Det,GRD.CA02 as CA02Det,GRD.CA03 as CA03Det,GRD.CA04 as CA04Det,GRD.CA05 as CA05Det,GRD.Cd_GR,P2.CodCo1_,P2.CA01 AS PRCA01, P2.CA02 AS PRCA02,
		P2.CA03 AS PRCA03,P2.CA04 AS PRCA04,P2.CA05 AS PRCA05,P2.CA06 AS PRCA06,P2.CA07 AS PRCA07,P2.CA08 AS PRCA08,P2.CA09 AS PRCA09,P2.CA10 AS PRCA10
from      GuiaRemisionDet GRD inner join Producto2 P2 on P2.RucE=GRD.RucE and P2.Cd_Prod=GRD.Cd_Prod
                inner join Prod_UM PM on PM.Cd_Prod=GRD.Cd_Prod and PM.RucE=GRD.RucE and PM.ID_UMP=GRD.ID_UMP
                inner join UnidadMedida UM on UM.Cd_UM=PM.Cd_UM
where GRD.Cd_GR in ('+@Cd_GR+') and GRD.RucE='''+@RucE+'''
'

/********************DESTINATARIO*******************************/
set @SqlDestinatario = 
'
declare @table table(Cd_Clt nchar(11), Cd_Prv char(7), Cd_GR char(10))
insert into @table(Cd_Clt,Cd_Prv,Cd_GR) select Cd_Clt, Cd_prv,Cd_GR from guiaremision where Ruce='''+@RucE+''' and Cd_GR in ('+@Cd_GR+')

select 
     
      Case When Isnull(Len(t.Cd_Clt),0) = 0 then Case when Isnull(Len(pr.RSocial),0) = 0 then Isnull(pr.ApPat,'''')+'' ''+ Isnull(pr.ApMat,'''')+'' ''+Isnull(pr.Nom,'''') else Isnull(pr.RSocial,'''') end
      else Case when Isnull(Len(cl.RSocial),0) = 0 then Isnull(cl.ApPat,'''')+'' ''+ Isnull(cl.ApMat,'''')+'' ''+Isnull(cl.Nom,'''') else Isnull(cl.RSocial,'''') end end as Destinario,
      
      Case When Isnull(Len(t.Cd_Clt),0) = 0 then pr.Ndoc else cl.Ndoc end as RucD,
      Case When Isnull(Len(tipd.NCorto),0) = 0 then tipP.NCorto else tipd.NCorto end as NCorto,
     Case When Isnull(Len(pr.NDoc),0) = 0 then pr.NDoc else pr.NDoc end as NDoc,
      Case When Isnull(Len(t.Cd_Clt),0) = 0 then pr.Direc else cl.Direc end as Direc,
      Case When Isnull(Len(t.Cd_Clt),0) = 0 then pr.telf1 else cl.telf1 end as telf1,
      Case When Isnull(Len(t.Cd_Clt),0) = 0 then pr.telf2 else cl.telf2 end as telf2,
      Case When Isnull(Len(t.Cd_Clt),0) = 0 then pr.Fax else cl.Fax end as Fax--,
      ,isnull(cl.CA01,isnull(pr.CA01,'''')) as CA01
      ,isnull(cl.CA02,isnull(pr.CA02,'''')) as CA02
      ,isnull(cl.CA03,isnull(pr.CA03,'''')) as CA03
      ,isnull(cl.CA04,isnull(pr.CA04,'''')) as CA04
      ,isnull(cl.CA05,isnull(pr.CA05,'''')) as CA05
      ,t.Cd_GR
      --,
      --*
from 
      @table t
      left join Cliente2 cl on cl.Cd_Clt=t.Cd_Clt and cl.RucE='''+@RucE+'''
      left join Proveedor2 pr on pr.Cd_Prv=t.Cd_Prv and pr.RucE='''+@RucE+'''
      left join TipDoc tipd on tipd.Cd_TD=cl.Cd_TDI
      left join TipDoc tipP on tipd.Cd_TD=pr.Cd_TDI
'

--declare @table table(Cd_Clt nchar(11),Cd_GR char(10))
--insert into @table(Cd_Clt,Cd_GR) select Cd_clt,cd_gr from guiaremision where Ruce='''+@RucE+''' and Cd_GR in ('+@Cd_GR+')


--if not exists(select * from @table )
--begin
--insert into @table(Cd_Clt,Cd_GR)
--select Vta.Cd_Clt,GRD.Cd_GR from Venta vta
--	inner join guiaremisiondet GRD on GRD.RucE=vta.RucE and GRD.Cd_Vta= vta.Cd_Vta
--	where GRD.Ruce= '''+@RucE+''' and GRD.Cd_GR in ('+@Cd_GR+') 
--	group by vta.RegCtb,Vta.Cd_Clt,GRD.Cd_GR
--end
--select * from producto2
--/***************************************Muestra Destinatario***********************/
--select case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat +'' ''+ cl.ApMat +'',''+ cl.Nom else cl.RSocial end as Destinario, cl.Ndoc RucD, tipd.NCorto, cl.NDoc, t.Cd_GR, cl.Direc,cl.telf1,cl.telf2, cl.Fax
--from cliente2 cl
--inner join TipDoc tipd on tipd.Cd_TD=cl.Cd_TDI
--inner join @table t on t.Cd_Clt = cl.Cd_Clt  
--where cl.Cd_Clt in (select Cd_Clt from @table) and RucE='''+@RucE+''''




set @SqlDocumentosRelacionados = 
'
Select Venta.NroDoc +''-''+ Venta.NroSre as DocRelacionado, gr.cd_gr, Venta.Cd_Td, Venta.NroDoc as NroDocFacturaRelacionada, Venta.NroSre as NroSerieFacturaRealcionada
		,Venta.CA03 as OC_Cliente, Venta.FecED as FechaEdicionFactura
		,Venta.CA01 as CA01Vta,Venta.CA02 as CA02Vta,Venta.CA03 as CA03Vta,
		Venta.CA04 as CA04Vta,Venta.CA05 as CA05Vta,Venta.CA06 as CA06Vta,
		Venta.CA07 as CA07Vta ,Venta.CA08 as CA08Vta,Venta.CA09 as CA09Vta,
		Venta.CA10 as CA10Vta,Venta.CA11 as CA11Vta,Venta.CA12 as CA12Vta,
		Venta.CA13 as CA13Vta,Venta.CA14 as CA14Vta,Venta.CA15 as CA15Vta
from      user321.VGuiaRemision as gr Left join user321.VGuiaRemisionLLegada as GRL on GRL.RucE=GR.RucE and GRL.Cd_GR=GR.Cd_GR
          Left join user321.VTransportistaGRemision as TR on tr.Cd_Tra=GR.Cd_Tra and tr.RucE=GR.RucE
          Left join TipoOperacion TipoOP on TipoOP.Cd_TO=GR.Cd_TO
          left join GuiaXVenta on GuiaXVenta.Cd_GR = GR.Cd_GR and GuiaXVenta.RucE = GR.RucE
          left join Venta on Venta.RucE = GuiaXVenta.RucE and Venta.Cd_Vta = GuiaXVenta.Cd_Vta
Where GR.Cd_GR in ('+@Cd_GR+')  and GR.RucE = '''+@RucE+''' AND GR.IC_ES=''S''
'

exec (@SqlValida+@SqlCabecera+@SqlDetalle+@SqlDestinatario+@SqlDocumentosRelacionados )

print @SqlValida
print @SqlCabecera
print @SqlDetalle
print @SqlDestinatario
print @SqlDocumentosRelacionados
--select *from cliente2 cl where ruce= '20538349730'

/*

--Microtint
exec Rpt_GuiaRemisionGeneral3 '20536756541','GR00000002','001','0000557','09',null
exec user321.Rpt_GuiaRemisionGeneral6 '20512635026','''GR00000002''',null,null
exec [user321].Rpt_GuiaRemisionGeneral6 '20522276236','''GR00000595''',null,null
select *from VGuiaRemision where RucE='20504743561' and Cd_GR='GR00000004' and NroSre='001' and NroGr='00090'
*/
/********Creado por Javier A.*********************************/
/**01/04/2011**/
/************************************************************/
--select * from empresa








GO
