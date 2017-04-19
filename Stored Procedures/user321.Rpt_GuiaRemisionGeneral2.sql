SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Rpt_GuiaRemisionGeneral2]
@RucE nvarchar(11),
@Cd_GR char(10),
@NroSre varchar(5),
@NroGR varchar(15),
@Cd_TD nvarchar(2),
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
if not exists(select top 1 * from Guiaremision where RucE = @RucE and Cd_GR = @Cd_GR )
set @msj = 'Guia Remision no existe'
else 
begin
/******************GUIA REMISION DATOS*************************************/
Select gr.Cd_CC, gr.Cd_SC, gr.Cd_SS,gr.RucE, gr.Cd_GR, gr.FecEmi, gr.FecIniTras, gr.NroSre as NoSerie, gr.NroGR as NumeroGuia,
                gr.AutorizadoPor, gr.PtoPartida, grl.PuntoLlegada, tr.RucT as RucTransp, tr.LicCond, tr.NroPlaca, tr.McaVeh as MarcaVehiculo,
                case(isnull(len(gr.Cd_Tra),0)) when 0 then gr.DescripTra else tr.Sres end as NombTransportista, TipoOP.Nombre as TipoOperacion,
                GR.CA01,GR.CA02,GR.CA03,GR.CA04,GR.CA05,GR.CA06,GR.CA07,GR.CA08,GR.CA09,GR.CA10,Venta.Cd_Td, Venta.NroDoc, Venta.NroSre,GR.Obs
from      VGuiaRemision as gr Left join VGuiaRemisionLLegada as GRL on GRL.RucE=GR.RucE and GRL.Cd_GR=GR.Cd_GR
          Left join VTransportistaGRemision as TR on tr.Cd_Tra=GR.Cd_Tra and tr.RucE=GR.RucE
          Left join TipoOperacion TipoOP on TipoOP.Cd_TO=GR.Cd_TO
          left join GuiaXVenta on GuiaXVenta.Cd_GR = GR.Cd_GR and GuiaXVenta.RucE = GR.RucE
          left join Venta on Venta.RucE = GuiaXVenta.RucE and Venta.Cd_Vta = GuiaXVenta.Cd_Vta
Where GR.Cd_GR =@Cd_GR and GR.RucE = @RucE and GR.Cd_Td = @Cd_TD



/********************DETALLE GUIA****************************/

/*select	GRD.Item, GRD.Cd_Prod as Codigo, GRD.PesoCantKg as Kilos, GRD.Cant as Cantidad, GRD.ID_UMP as UMedida,UM.NCorto ,isnull(P2.NCorto,'') as NCorto, P2.NOmbre1 as Detalle
	from GuiaRemisionDet GRD inner join Producto2 P2 on P2.Cd_Prod=GRD.Cd_Prod and P2.RucE=GRD.RucE
				inner join Prod_UM PM on PM.Id_UMP = GRD.Id_UMP
				inner join UnidadMedida UM on UM.CD_UM=PM.CD_UM
	where GRD.Cd_GR=@Cd_GR and GRD.RucE=@RucE*/

select    GRD.Item, GRD.Cd_Prod as Codigo,GRD.PesoCantKg as Kilos, GRD.Cant as Cantidad, GRD.ID_UMP as UMedida
                ,UM.NCorto as NCortoUM,isnull(P2.NCorto,'') as NCortoProd, P2.Nombre1 as Detalle
from      GuiaRemisionDet GRD inner join Producto2 P2 on P2.RucE=GRD.RucE and P2.Cd_Prod=GRD.Cd_Prod
                inner join Prod_UM PM on PM.Cd_Prod=GRD.Cd_Prod and PM.RucE=GRD.RucE and PM.ID_UMP=GRD.ID_UMP
                inner join UnidadMedida UM on UM.Cd_UM=PM.Cd_UM
where GRD.Cd_GR=@Cd_GR and GRD.RucE=@RucE


/********************DESTINATARIO*******************************/
declare @Cd_CltAux char(10)
set @Cd_CltAux= (select Cd_clt from guiaremision where Ruce=@RucE and Cd_GR=@Cd_GR)


if(@Cd_CltAux is null)
begin 
select 	top 1 @Cd_CltAux=Vta.Cd_Clt from Venta vta
	inner join guiaremisiondet GRD on GRD.RucE=vta.RucE and GRD.Cd_Vta= vta.Cd_Vta
	where GRD.Ruce=@RucE and GRD.Cd_GR=@Cd_GR 

end
/***************************************Muestra Destinatario***********************/
select case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat +' '+ cl.ApMat +','+ cl.Nom else cl.RSocial end as Destinario, cl.Ndoc RucD, tipd.NCorto, cl.NDoc
from cliente2 cl
inner join TipDoc tipd on tipd.Cd_TD=cl.Cd_TDI
where cl.Cd_Clt=@Cd_CltAux and RucE=@RucE

--select *from cliente2 cl where ruce= '20538349730'

/*
ejemplo
exec Rpt_GuiaRemisionGeneral2 '20538349730','GR00000001','0001','0000001',null
--GMC
exec Rpt_GuiaRemisionGeneral2 '20504743561','GR00000004','001','00090','09',null
select *from VGuiaRemision where RucE='20504743561' and Cd_GR='GR00000004' and NroSre='001' and NroGr='00090'
*/
/********Creado por Javier A.*********************************/
/************************************************************/

end
GO
