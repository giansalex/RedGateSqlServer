SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons_RegCtb2]
@RucE nvarchar(11),
@RegCtb nvarchar(15),
@Ejer nvarchar(4),
@msj varchar(100) output
as
if(@RucE = '20546110720')
begin
		select I.*, [TO].Nombre as Nom_TO, MIS.Descrip as Nom_MIS, 
		P.Cd_TDI as TDI_Prv, P.NDoc as NDoc_Prv, case(isnull(len(P.RSocial),0)) when 0 then P.ApPat+ ' ' + P.ApMat+ ' ' +P.Nom else P.RSocial end Nom_Prv,
		C.Cd_TDI as TDI_Clt, C.NDoc as NDoc_Clt, case(isnull(len(C.RSocial),0)) when 0 then C.ApPat+ ' ' + C.ApMat+ ' ' +C.Nom else C.RSocial end Nom_Clt, PD.Nombre1 as NomProd, PUM.DescripAlt as NomUMP,
		PUM.Factor as Factor,
		Pd.CodCo1_ as CodCom, cc.Descrip as NomCC,s.Descrip as NomSC,ss.Descrip as NomSS
		from Inventario as I
		left join TipoOperacion as [TO] on [TO].Cd_TO = I.Cd_TO
		left join MtvoIngSal as MIS on MIS.RucE = I.RucE and MIS.Cd_MIS =I.Cd_MIS
		left join Proveedor2 as P on  P.RucE = I.RucE and P.Cd_Prv = I.Cd_Prv
		left join Cliente2 as C on C.RucE = I.RucE and C.Cd_Clt = I.Cd_Clt
		inner join Producto2 as Pd on I.RucE  = Pd.RucE and  I.Cd_Prod = Pd.Cd_Prod
		inner join Prod_UM  as PUM on PUM.RucE=Pd.RucE and PUM.Cd_Prod = I.Cd_Prod and PUM.Id_UMP = I.ID_UMP
			left join CCostos cc on cc.RucE = I.RucE and cc.Cd_CC = I.Cd_CC
			left join CCSub s on cc.RucE = s.RucE and cc.Cd_CC = s.Cd_CC and s.Cd_SC = I.Cd_SC
			left join CCSubSub ss on cc.RucE = ss.RucE and cc.Cd_CC = ss.Cd_CC and s.Cd_SC = ss.Cd_SC and ss.Cd_SS = I.Cd_SS
		where I.RucE = @RucE and I.RegCtb = @RegCtb and I.Ejer = @Ejer and I.IC_ES = 'E'
		print @msj
end
else
begin
		select I.*, [TO].Nombre as Nom_TO, MIS.Descrip as Nom_MIS, 
		P.Cd_TDI as TDI_Prv, P.NDoc as NDoc_Prv, case(isnull(len(P.RSocial),0)) when 0 then P.ApPat+ ' ' + P.ApMat+ ' ' +P.Nom else P.RSocial end Nom_Prv,
		C.Cd_TDI as TDI_Clt, C.NDoc as NDoc_Clt, case(isnull(len(C.RSocial),0)) when 0 then C.ApPat+ ' ' + C.ApMat+ ' ' +C.Nom else C.RSocial end Nom_Clt, PD.Nombre1 as NomProd, PUM.DescripAlt as NomUMP,
		PUM.Factor as Factor,
		Pd.CodCo1_ as CodCom, cc.Descrip as NomCC,s.Descrip as NomSC,ss.Descrip as NomSS,
		a.Nombre as NomAlmacen
		from Inventario as I
		left join TipoOperacion as [TO] on [TO].Cd_TO = I.Cd_TO
		left join MtvoIngSal as MIS on MIS.RucE = I.RucE and MIS.Cd_MIS =I.Cd_MIS
		left join Proveedor2 as P on  P.RucE = I.RucE and P.Cd_Prv = I.Cd_Prv
		left join Cliente2 as C on C.RucE = I.RucE and C.Cd_Clt = I.Cd_Clt
		inner join Producto2 as Pd on I.RucE  = Pd.RucE and  I.Cd_Prod = Pd.Cd_Prod
		inner join Prod_UM  as PUM on PUM.RucE=Pd.RucE and PUM.Cd_Prod = I.Cd_Prod and PUM.Id_UMP = I.ID_UMP
		left join CCostos cc on cc.RucE = I.RucE and cc.Cd_CC = I.Cd_CC
		left join CCSub s on cc.RucE = s.RucE and cc.Cd_CC = s.Cd_CC and s.Cd_SC = I.Cd_SC
		left join CCSubSub ss on cc.RucE = ss.RucE and cc.Cd_CC = ss.Cd_CC and s.Cd_SC = ss.Cd_SC and ss.Cd_SS = I.Cd_SS
		left join Almacen as a on a.RucE = I.RucE and i.Cd_Alm = a.Cd_Alm
		where I.RucE = @RucE and I.RegCtb = @RegCtb and I.Ejer = @Ejer
		print @msj
end
-- Leyenda --
--select * from Prod_UM

-- PP : 2010-08-16 13:34:14.830	: <Creacion del procedimiento almacenado>
--CAM : 2012-02-15 13:34:14.830	: <MOdf del procedimiento almacenado> agregue CC y nombres
--CAM : 2012-06-19 09:20 <mdf para norsur. solo se mostraran los que sean de entrada en las ediciones de trasnferencia entre almacenes>
--exec [Inv_InventarioCons_RegCtb2] '11111111111','INGN_LD03-00227','2012',''

--select * from Inventario where RucE = '11111111111' and RegCtb = 'INGE_LD09-00002' and Ejer = '2012'
GO
