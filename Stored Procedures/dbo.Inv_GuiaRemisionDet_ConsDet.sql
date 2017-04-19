SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_GuiaRemisionDet_ConsDet]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as
declare @Costo float

select dbo.CostSal(GRD.RucE,GRD.Cd_Prod,GRD.ID_UMP,GR.FecEmi) as 'CU',GRD.RucE,GRD.Item, GRD.Cd_Prod, P.Nombre1,PU.DescripAlt,GRD.Cant,GRD.ID_UMP
,Pre.PVta, Pre.ValVta ,Pre.IB_IncIGV,pre.IC_TipDscto,pre.Dscto,convert(numeric(13,3),isnull(case Pre.IC_TipDscto when 'I' then Pre.Dscto else (pre.ValVta*Pre.Dscto)/100 end,0)) as DsctoI
,GR.Cd_CC,GR.Cd_SC,GR.Cd_SS
from Producto2 as P
left join UnidadMedida as UM
left join Prod_UM as PU on UM.Cd_UM = PU.Cd_UM on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  
left join GuiaRemisionDet as GRD on GRD.RucE = PU.RucE and GRD.Cd_Prod = PU.Cd_Prod and GRD.ID_UMP = PU.ID_UMP
left join GuiaRemision GR on GR.RucE=GRD.RucE and GR.Cd_GR=GRD.Cd_GR
left join Precio as Pre on Pre.Cd_Prod=GRD.Cd_Prod and Pre.RucE=GRD.RucE and PRE.ID_UMP=GRD.ID_UMP
where GRD.RucE = @RucE and GRD.Cd_GR = @Cd_GR and PRE.IB_EsPrin=1
order by GRD.Item
--select * from precio where ruce='11111111111'
--precio
		
		
GO
