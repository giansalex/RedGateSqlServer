SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioConsxProd]
@RucE nvarchar(11),
@Cd_Prod char(7),
@TipCons int,
@msj varchar(100) output
as
if (@TipCons=0)
	select 
		Id_Prec,
		P.Descrip, 
		Simbolo,
		PVta,
		ValVta,
		IB_IncIGV,
		IB_Exrdo,
		convert(varchar,isnull(Dscto,'.00'))+(case IC_Tipdscto when 'P' then  '%' else '' end) as Dscto, 
		convert(varchar, MrgSup)+(case IC_TipVP when 'P' then  '%' else '' end) as MrgSup, 
		convert(varchar, MrgInf)+(case IC_TipVP when 'P' then  '%' else '' end) as MrgInf, 
		convert(varchar, MrgUti)+(case IC_TipMU when 'P' then  '%' else '' end) as MrgUtil, 
		DescripAlt, 
		UM.Nombre, 
		Factor, IB_EsPrin
	from Precio as P 
		inner join Prod_UM as PUM on PUM.RucE = P.RucE and PUM.ID_UMP = P.ID_UMP and PUM.Cd_Prod = P.Cd_Prod 
		inner join UnidadMedida as UM on UM.Cd_UM = PUM.Cd_UM 
		inner join Moneda as M on M.Cd_mda =P.Cd_Mda
		where PUM.RucE= @RucE and  P.Estado= 1 and PUM.Cd_Prod=@Cd_Prod

print @msj

-- Leyenda --
-- PP : 2010-03-02		: <Creacion del procedimiento almacenado>
-- PP : 2010-03-19 11:15:10.103	: <Modificacion del procedimiento almacenado por el Id_Prec>


GO
