SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OrdPedidoDetXOrdPedido]
@RucE nvarchar(11),
@Cd_OP varchar(8000),
@msj varchar(100) output
as
declare @var varchar(8000)
set @var = 
'select 
op.NroOP,
op.Cd_Vdr,
c.NDoc as NroDocCliente,
opd.Item ,case(isnull(opd.Cd_Prod,''0'')) 
when ''0'' then case(isnull(opd.Cd_Srv,''0'')) when ''0'' 
then null else opd.Cd_Srv end else opd.Cd_Prod end as Cd_Prod
	, opd.Descrip, opd.ID_UMP, um.DescripAlt, opd.PU, opd.Cant ,opd.PendEnt ,opd.Cd_Alm , opd.Valor, opd.DsctoP, opd.DsctoI, opd.BIM, opd.IGV , opd.Total
	, opd.Cd_CC, opd.Cd_SC, opd.Cd_SS, opd.Obs, opd.CA01, opd.CA02, opd.CA03, opd.CA04, opd.CA05, opd.CA06, opd.CA07, opd.CA08, opd.CA09, opd.CA10 
from OrdPedidoDet opd left join Prod_UM um on opd.RucE=um.RucE and opd.ID_UMP = um.ID_UMP and opd.Cd_Prod = um.Cd_Prod
	left join Almacen Alm on Alm.Cd_Alm=opd.Cd_Alm and Alm.RucE=opd.RucE
	left join OrdPedido op on op.RucE = opd.RucE and op.Cd_OP = opd.Cd_OP
	Left join cliente2 c on c.RucE=opd.RucE and c.Cd_Clt=op.Cd_Clt
where opd.RucE='''+@RucE+''' and opd.Cd_OP in ('+@Cd_OP+')'

print @var
exec(@var)
if @@rowcount = 0 set @msj = 'No hay item a consultar'
GO
