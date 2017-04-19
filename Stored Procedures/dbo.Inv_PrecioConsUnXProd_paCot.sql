SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioConsUnXProd_paCot]
@RucE nvarchar(11),
@Cd_Cot char(10),
@ID_CtD int,
@msj varchar(100) output

as

Declare @ID_Prec int
Declare @Cd_Prod char(7)
Declare @Factor decimal(13,3)

select @Cd_Prod=c.Cd_Prod,@ID_Prec=c.ID_Prec,@Factor=u.Factor 
from CotizacionDet c
 left join Prod_UM u On u.RucE=c.RucE and u.Cd_Prod=c.Cd_Prod and u.ID_UMP=c.ID_UMP
where c.RucE=@RucE and c.Cd_Cot=@Cd_Cot and c.ID_CtD = @ID_CtD

select 
	ID_Prec,Cd_Prod,ID_UMP,Cd_Mda,ValVta,IC_TipDscto,Dscto,
	IB_IncIGV,PVta,IC_TipVP,MrgInf,MrgSup,IC_TipMU,MrgUti,@Factor As Factor
from Precio where RucE=@RucE and Cd_Prod=@Cd_Prod and ID_Prec=@ID_Prec

-- LEYENDA --
-- DI : 08/04/2010 <Creacion del procedimiento almacenado>
GO
