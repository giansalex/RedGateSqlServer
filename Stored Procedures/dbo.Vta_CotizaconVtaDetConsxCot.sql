SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Vta_CotizaconVtaDetConsxCot]
@RucE nvarchar(11),
@Cd_Cot char(10),
@msj varchar(100) output
as
--VALIDACION

if not exists (select * from Cotizacion where RucE = @RucE and Cd_Cot = @Cd_Cot)
begin
	set @msj = 'No existe la solicitud de compra con el codigo : ' + @Cd_Cot	
	return
end

--OBTENCION DEL DETALLE CON LOS SALDOS
declare @tabla table
(
	Cd_Prod char (7),
	Cd_Srv char (7),
	ID_UMP int,
	CantTotal numeric(13,3),
	Saldo numeric(13,3)
	
)
insert into @tabla
select * from (
	--select Cd_Prod, Cd_Srv, ID_UMP, sum(case when (Cant<0) then 0 else Cant end) as 'Total', sum(Cant) as 'Saldo'
	select Cd_Prod, Cd_Srv, ID_UMP, sum(case when (Cant<0) then 0 else Cant end) as 'CantTotal', sum(Cant) as 'Saldo'
	from(				
			select RucE, Cd_Prod, isnull(Cant,0) as Cant, ID_UMP, Cd_Srv , 'Cotizacion detalle' Tabla
			from CotizacionDet where RucE = @RucE and Cd_Cot = @Cd_Cot
			union all
			select opd.RucE, Cd_Prod, isnull(-Cant,0) as Cant, ID_UMP, Cd_Srv, 'Orden pedido Detalle' Tabla
			from OrdPedidoDet opd  inner join OrdPedido op
			on op.Cd_OP=opd.Cd_OP
			where opd.RucE = @RucE and op.Cd_Cot = @Cd_Cot
	) as t1
	group by RucE, Cd_Prod, ID_UMP, Cd_Srv
) as t2
--select * from @tabla
select cdet.RucE, cdet.Cd_SC, cdet.Cd_SC,
	   cdet.Cd_Prod,
	   cdet.Cd_SRV, ISNULL(pr.Nombre1, 
	   ISNULL(sr.Nombre,'')) as 'Nombre',
	   ISNULL(t1.CantTotal, t2.CantTotal) as 'Cant', 
	   cdet.Descrip, ISNULL(cdet.ID_UMP, 0) as UMP,
	   isnull(pum.DescripAlt, '------') as 'UnidadMedida',
	   isnull(t1.Saldo, t2.Saldo) as 'Saldo', case when (cdet.Cd_SRV is not null) then 1 else 0 end as 'EsServicio',        
	   cdet.Obs, cdet.CA01, cdet.CA02, cdet.CA03,
	   cdet.CA04, cdet.CA05
from CotizacionDet cdet
left join @tabla as t1 on cdet.Cd_Prod = t1.Cd_Prod 
left join @tabla as t2 on cdet.Cd_SRV = t2.Cd_Srv 
left join Producto2 pr on pr.RucE = @RucE and pr.Cd_Prod = cdet.Cd_Prod
left join Servicio2 sr on sr.RucE = @RucE and sr.Cd_Srv = cdet.Cd_SRV
left join Prod_UM pum on pum.RucE = @RucE and pum.Cd_Prod = cdet.Cd_Prod and pum.ID_UMP = cdet.ID_UMP
where cdet.RucE = @RucE and cdet.Cd_Cot = @Cd_Cot

--	LEYENDA
/*	MM : <11/08/11 : Creacion del SP>
	
*/
--	PRUEBAS
/*	exec Com_SolicitudComDetConsxSC2 '20160000001','SC00000007',null
	
*/
GO
