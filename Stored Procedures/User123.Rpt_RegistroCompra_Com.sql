SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [User123].[Rpt_RegistroCompra_Com]
@RucE nvarchar (11),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Ejer nvarchar(4),

@msj varchar(100)
as
if not exists (select top 1 * from compra where RucE=@RucE)
	set @msj = 'No se encontro Cliente'

--Encabezado Informe
	select top 1 Ejer,RucE,@PrdoD as PrdoD,@PrdoH as PrdoH 
	from Compra where RucE=@RucE and Ejer=@Ejer 
	and (Prdo between @PrdoD and @PrdoH)

--Detalle Informe
select 	co.RegCtb, convert(nvarchar,co.FecED,103) as FechaEmision, Convert(nvarchar,co.FecVD,103) as FechaVcmto,
	co.Cd_TD as Tipo,co.NroSre,' ' as EmisDua, co.NroDoc, p2.Cd_TDI as TipoProv,p2.NDoc as NroProv,
	case(isnull(len(p2.RSocial),0)) when 0 then p2.ApPat + ' ' +p2.ApMat + ', ' + p2.Nom else p2.RSocial end as Proveedor,
	co.BIM_S,co.IGV_S,co.BIM_E,co.IGV_E,co.BIM_C,co.IGV_C,co.Imp_N, case when co.Imp_O is not null then co.Imp_O else '0.00' end as Imp_O,co.Total,co.DR_NCND,co.DR_NroDet,
	convert(nvarchar,co.DR_FecDet,103) as DR_FecDet,convert(nvarchar,co.DR_FecED,103) as DR_FecED,co.DR_CdTD,co.DR_NSre,co.DR_NDoc
from 	compra co left join Proveedor2 p2 on p2.Cd_Prv=co.Cd_Prv and p2.RucE=co.RucE where co.RucE=@RucE and co.Ejer=@Ejer 
	and (co.Prdo between @PrdoD and @PrdoH)

-- Leyenda --
-- JJ:  2010-08-25:	<Creacion del Procedimiento Almacenado>
GO
