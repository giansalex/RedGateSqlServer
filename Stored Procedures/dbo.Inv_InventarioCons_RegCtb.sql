SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons_RegCtb]
@RucE nvarchar(11),
@RegCtb nvarchar(15),
@msj varchar(100) output
as

select I.*, [TO].Nombre as Nom_TO, MIS.Descrip as Nom_MIS, 
P.Cd_TDI as TDI_Prv, P.NDoc as NDoc_Prv, case(isnull(len(P.RSocial),0)) when 0 then P.ApPat+ ' ' + P.ApMat+ ' ' +P.Nom else P.RSocial end Nom_Prv,
C.Cd_TDI as TDI_Clt, C.NDoc as NDoc_Clt, case(isnull(len(C.RSocial),0)) when 0 then C.ApPat+ ' ' + C.ApMat+ ' ' +C.Nom else C.RSocial end Nom_Clt, PD.Nombre1 as NomProd, PUM.DescripAlt as NomUMP,
PUM.Factor as Factor
from Inventario as I
left join TipoOperacion as [TO] on [TO].Cd_TO = I.Cd_TO
left join MtvoIngSal as MIS on MIS.RucE = I.RucE and MIS.Cd_MIS =I.Cd_MIS
left join Proveedor2 as P on  P.RucE = I.RucE and P.Cd_Prv = I.Cd_Prv
left join Cliente2 as C on C.RucE = I.RucE and C.Cd_Clt = I.Cd_Clt
inner join Producto2 as Pd on I.RucE  = Pd.RucE and  I.Cd_Prod = Pd.Cd_Prod
inner join Prod_UM  as PUM on PUM.RucE=Pd.RucE and PUM.Cd_Prod = I.Cd_Prod and PUM.Id_UMP = I.ID_UMP
where I.RucE = @RucE and I.RegCtb = @RegCtb
print @msj

-- Leyenda --
--select * from Prod_UM

-- PP : 2010-08-16 13:34:14.830	: <Creacion del procedimiento almacenado>

--exec [Inv_InventarioCons_RegCtb] '11111111111','INGE_LD05-00112',''
GO
