SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioHistConsxPrecio]
@RucE nvarchar(11),
@Id_Prec int,
@TipCons int,
@msj varchar(100) output
as
if (@TipCons=0)
	select 	convert(varchar,Fecha,103) as Fecha, Simbolo, PH.PVta, PH.ValVta, PH.IB_IncIGV, PH.IB_Exrdo, 
		convert(varchar,isnull(PH.Dscto,'.00'))+(case PH.IC_Tipdscto when 'P' then  '%' else '' end) as Dscto
		from PrecioHist as PH 
		inner join Precio as P on PH.RucE = P.RucE and PH.ID_Prec = P.ID_Prec
		inner join Moneda as M on M.Cd_mda =P.Cd_Mda 
		where P.Estado= 1 and PH.Id_Prec =@Id_Prec and P.RucE = @RucE
		order by Fecha desc

print @msj

-- Leyenda --
-- PP : 2010-03-20 16:20:46.533	: <Creacion del procedimiento almacenado>

GO
