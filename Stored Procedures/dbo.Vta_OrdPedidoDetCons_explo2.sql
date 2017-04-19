SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Vta_OrdPedidoDetCons_explo2]
@RucE nvarchar(11),
@Cd_OP char(10),
@msj varchar(100) output
as
--case(isnull(c.Cd_Prod,'0')) when '0' then case(isnull(c.Cd_Srv,'0')) when '0' then null else c.Cd_Srv end else c.Cd_Prod end as Codigo
select 	op.Item, 
		case(isnull(op.Cd_Prod,'0')) when '0' then case(isnull(op.Cd_Srv,'0')) 
		when '0' then null else op.Cd_Srv end else op.Cd_Prod end as Cd_Prod,
		isnull(srv.CodCo,prd.CodCo1_) as CodCo,
		op.Descrip,
		op.ID_UMP,
		um.DescripAlt,
		op.PU,
		op.Cant,
		op.PendEnt, 
		op.Cd_Alm, 
		op.Valor,
		op.DsctoP, 
		op.DsctoI, 
		op.BIM, 
		op.IGV, 
		case(isnull(op.IGV,0))when 0 then 0 else 1 end as IncIGV,
		op.Total, 
		op.CA01, 
		op.CA02, 
		op.CA03, 
		op.CA04, 
		op.CA05, 
		op.CA06, 
		op.CA07, 
		op.CA08, 
		op.CA09, 
		op.CA10
from 	OrdPedidoDet op 
		left join Prod_UM um on op.RucE = um.RucE and op.ID_UMP = um.ID_UMP and op.Cd_Prod = um.Cd_Prod
		left join Servicio2 srv on srv.RucE = op.RucE and srv.Cd_Srv = op.Cd_Srv
		Left join Producto2 prd on prd.RucE= op.RucE and prd.Cd_Prod= op.Cd_Prod
	where op.RucE=@RucE and op.Cd_OP=@Cd_OP
	print @msj

--exec Com_OrdPedidoDetCons_explo '11111111111','OC00000005'
-- Leyenda --
-- JJ : 2010-08-06 : <Creacion del procedimiento almacenado>
-- JJ : 2010-08-11 : <Creacion del procedimiento almacenado>

GO
