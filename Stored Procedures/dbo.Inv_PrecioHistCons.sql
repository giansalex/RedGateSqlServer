SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioHistCons]
@RucE nvarchar(11),
@TipCons int,
@Cd_Prod char(7),
@msj varchar(100) output
as
if (@TipCons=0)
	select convert(varchar,Fecha,103) as Fecha, Simbolo,PH.PVta,PH.ValVta,PH.IB_IncIGV,PH.IB_Exrdo, convert(varchar,isnull(PH.Dscto,'.00'))+(case PH.IC_Tipdscto when 'P' then  '%' else '' end) as Dscto
		from PrecioHist as PH inner join Precio as P on PH.ID_Prec = P.ID_Prec inner join Prod_UM as PUM on PUM.ID_UMP = P.ID_UMP and PUM.Cd_Prod = P.Cd_Prod inner join UnidadMedida as UM on UM.Cd_UM = PUM.Cd_UM inner join Moneda as M on M.Cd_mda =P.Cd_Mda
			and P.Estado= 1 and PUM.RucE= @RucE and PUM.Cd_Prod = @Cd_Prod 
				order by Fecha desc

print @msj

-- Leyenda --
-- PP : 2010-03-20 16:20:46.533	: <Creacion del procedimiento almacenado>
GO
