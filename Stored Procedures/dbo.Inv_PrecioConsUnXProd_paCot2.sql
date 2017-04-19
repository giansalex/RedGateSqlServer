SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioConsUnXProd_paCot2]
@RucE nvarchar(11),
@Cd_Prod varchar(10),
@ID_Prec int,
@msj varchar(100) output

as

select 
	p.ID_Prec,p.Cd_Prod,p.ID_UMP,p.Cd_Mda,p.ValVta,p.IC_TipDscto,p.Dscto,
	p.IB_IncIGV,p.PVta,p.IC_TipVP,p.MrgInf,p.MrgSup,p.IC_TipMU,p.MrgUti,u.Factor As Factor
from Precio p
	Left Join Prod_UM u ON u.RucE=p.RucE and u.Cd_Prod=p.Cd_Prod and u.ID_UMP=p.ID_UMP
where p.RucE=@RucE and p.Cd_Prod=@Cd_Prod and p.ID_Prec=@ID_Prec

-- LEYENDA --
-- DI : 12/05/2011 <Creacion del procedimiento almacenado>
GO
