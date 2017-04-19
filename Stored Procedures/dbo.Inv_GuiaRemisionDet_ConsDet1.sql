SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_GuiaRemisionDet_ConsDet1]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as
declare @Costo float
declare @Cd_OP char(10)

--select @Cd_OP = Cd_OP from Inventario where RucE = @RucE and Cd_GR = @Cd_GR

select dbo.CostSal(GRD.RucE,GRD.Cd_Prod,GRD.ID_UMP,GR.FecEmi) as 'CU',GRD.RucE,GRD.Item, GRD.Cd_Prod, P.Nombre1,PU.DescripAlt,GRD.Cant,GRD.ID_UMP, 
case (GRD.Cd_OP) when null then Pre.PVta else op.PU end as PVta, 
case (GRD.Cd_OP) when null then Pre.ValVta else op.Valor end as ValVta,
case (GRD.Cd_OP) when null then Pre.IB_IncIGV else case (op.IGV) when null then 0 else 1 end end as IB_IncIGV,
--null as IC_TipDscto,
case (GRD.Cd_OP) when null then 0.0 else op.DsctoP end as Dscto,
case (GRD.Cd_OP) when null then 0.0 else op.DsctoI end as DsctoI,
--convert(numeric(13,3),isnull(case Pre.IC_TipDscto when 'I' then Pre.Dscto else (pre.ValVta*Pre.Dscto)/100 end,0)) as DsctoI,
GR.Cd_CC,GR.Cd_SC,GR.Cd_SS
from Producto2 as P
left join UnidadMedida as UM
left join Prod_UM as PU on UM.Cd_UM = PU.Cd_UM on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  
left join GuiaRemisionDet as GRD on GRD.RucE = PU.RucE and GRD.Cd_Prod = PU.Cd_Prod and GRD.ID_UMP = PU.ID_UMP
left join GuiaRemision GR on GR.RucE=GRD.RucE and GR.Cd_GR=GRD.Cd_GR
left join Precio as Pre on Pre.Cd_Prod=GRD.Cd_Prod and Pre.RucE=GRD.RucE and PRE.ID_UMP=GRD.ID_UMP
left join OrdPedidoDet as op on P.RucE = op.RucE and op.Cd_OP = GRD.Cd_OP and op.Cd_Prod = P.Cd_Prod
where GRD.RucE = @RucE and GRD.Cd_GR = @Cd_GR and PRE.IB_EsPrin=1
order by GRD.Item

/*
select * from GuiaRemision where RucE  = '11111111111'
select * from GuiaRemisionDet where RucE  = '11111111111'

select * from OrdPedidoDet where RucE  = '11111111111' and cd_Op='OP00000181'
select * from inventario where RucE  = '11111111111'

exec Inv_GuiaRemisionDet_ConsDet1 '11111111111','GR00000396',''

select * from Ordpedidodet where RucE = '11111111111' and Cd_OP ='OP00000181'

select * from guiaremisiondet  where RucE = '11111111111' and Cd_GR='GR00000396' --and Cd_OP ='OP00000181'

*/
GO
