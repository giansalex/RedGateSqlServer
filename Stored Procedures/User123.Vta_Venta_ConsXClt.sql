SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [User123].[Vta_Venta_ConsXClt]
@RucE nvarchar(11),
@Cd_Clt char(10),
@Ejer nvarchar(4),
@msj varchar(100) output
as

select  convert(Nvarchar,  ve.FecMov,103) as FecMov,ve.RegCtb, ve.Cd_TD,ve.NroSre,ve.NroDoc,case(ve.Cd_Mda) when '01' then ve.Total else convert(numeric(13,2),ve.Total*ve.CamMda) end  as Soles ,
case(ve.Cd_Mda) when '01' then convert(numeric(13,2), ve.Total/ve.CamMda) else ve.Total end as Dolares ,
case(ve.Cd_Mda) when '01' then 'S/.' else '$' end as Mda,ve.CamMda,ve.Cd_Vta as CodMov, convert(Nvarchar,ve.FecED,103) as FecED from Venta ve
inner join Cliente2 ce on ve.RucE = ce.RucE and ve.Cd_Cte = ce.Cd_Aux
where ve.RucE = @RucE 
and ce.Cd_Clt = @Cd_Clt 
and IB_Anulado = 0
print @msj
--exec Vta_Venta_ConsXClt '11111111111','CLT0000003','2010', null
-- Leyenda --
-- JU : 2010-08-26 : <Creacion del procedimiento almacenado>
GO
