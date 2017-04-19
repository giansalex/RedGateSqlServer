SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Rpt_GuiaRemisionGeneral5]
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
                GR.CA01,GR.CA02,GR.CA03,GR.CA04,GR.CA05,GR.CA06,GR.CA07,GR.CA08,GR.CA09,GR.CA10,Venta.Cd_Td, Venta.NroDoc as NroDocFacturaRelacionada, Venta.NroSre as NroSerieFacturaRealcionada,GR.Obs
		,Venta.CA03 as OC_Cliente, Venta.FecED as FechaEdicionFactura
from      VGuiaRemision as gr Left join VGuiaRemisionLLegada as GRL on GRL.RucE=GR.RucE and GRL.Cd_GR=GR.Cd_GR
          Left join VTransportistaGRemision as TR on tr.Cd_Tra=GR.Cd_Tra and tr.RucE=GR.RucE
          Left join TipoOperacion TipoOP on TipoOP.Cd_TO=GR.Cd_TO
          left join GuiaXVenta on GuiaXVenta.Cd_GR = GR.Cd_GR and GuiaXVenta.RucE = GR.RucE
          left join Venta on Venta.RucE = GuiaXVenta.RucE and Venta.Cd_Vta = GuiaXVenta.Cd_Vta
Where GR.Cd_GR in ('+@Cd_GR+') and GR.RucE = '''+@RucE+''''



/********************DETALLE GUIA****************************/
set @SqlDetalle = 
'
select    GRD.Item, GRD.Cd_Prod as Codigo,GRD.PesoCantKg as Kilos, GRD.Cant as Cantidad, GRD.ID_UMP as UMedida
                ,UM.NCorto as NCortoUM,isnull(P2.NCorto,'''') as NCortoProd, P2.Nombre1 as Detalle
		,GRD.CA01 as CA01Det,GRD.CA02 as CA02Det,GRD.CA03 as CA03Det,GRD.CA04 as CA04Det,GRD.CA05 as CA05Det,GRD.Cd_GR
from      GuiaRemisionDet GRD inner join Producto2 P2 on P2.RucE=GRD.RucE and P2.Cd_Prod=GRD.Cd_Prod
                inner join Prod_UM PM on PM.Cd_Prod=GRD.Cd_Prod and PM.RucE=GRD.RucE and PM.ID_UMP=GRD.ID_UMP
                inner join UnidadMedida UM on UM.Cd_UM=PM.Cd_UM
where GRD.Cd_GR in ('+@Cd_GR+') and GRD.RucE='''+@RucE+'''
'

/********************DESTINATARIO*******************************/
set @SqlDestinatario = 
'
declare @table table(Cd_Clt nchar(11),Cd_GR char(10))
insert into @table(Cd_Clt,Cd_GR) select Cd_clt,cd_gr from guiaremision where Ruce='''+@RucE+''' and Cd_GR in ('+@Cd_GR+')


if not exists(select * from @table )
begin
insert into @table(Cd_Clt,Cd_GR)
select Vta.Cd_Clt,GRD.Cd_GR from Venta vta
	inner join guiaremisiondet GRD on GRD.RucE=vta.RucE and GRD.Cd_Vta= vta.Cd_Vta
	where GRD.Ruce= '''+@RucE+''' and GRD.Cd_GR in ('+@Cd_GR+') 
	group by vta.RegCtb,Vta.Cd_Clt,GRD.Cd_GR
end

/***************************************Muestra Destinatario***********************/
select case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat +'' ''+ cl.ApMat +'',''+ cl.Nom else cl.RSocial end as Destinario, cl.Ndoc RucD, tipd.NCorto, cl.NDoc, t.Cd_GR
from cliente2 cl
inner join TipDoc tipd on tipd.Cd_TD=cl.Cd_TDI
inner join @table t on t.Cd_Clt = cl.Cd_Clt  
where cl.Cd_Clt in (select Cd_Clt from @table) and RucE='''+@RucE+''''

exec (@SqlValida+@SqlCabecera+@SqlDetalle+@SqlDestinatario)

print @SqlValida
print @SqlCabecera
print @SqlDetalle
print @SqlDestinatario
--select *from cliente2 cl where ruce= '20538349730'

/*

--Microtint
exec Rpt_GuiaRemisionGeneral3 '20536756541','GR00000002','001','0000557','09',null
exec Rpt_GuiaRemisionGeneral5 '20536756541','''GR00000007'',''GR00000002'',''GR00000001''',null,null
select *from VGuiaRemision where RucE='20504743561' and Cd_GR='GR00000004' and NroSre='001' and NroGr='00090'
*/
/********Creado por Javier A.*********************************/
/**01/04/2011**/
/************************************************************/







GO
