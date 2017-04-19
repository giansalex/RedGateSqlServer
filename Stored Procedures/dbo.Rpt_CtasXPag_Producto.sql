SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXPag_Producto]
@RucE nvarchar(11),
@Ejer varchar(4),
@RegCtb varchar(8000)
as
declare @Consulta1 varchar(4000)
declare @Consulta2 varchar(3)

set @Consulta1='
select 
	v.RegCtb, 
	Case(isnull(len(vd.Cd_Prod),0)) when 0 then vd.Cd_Srv else vd.Cd_Prod end as Cd_ProdServ,
	Case(isnull(len(vd.Cd_Prod),0)) when 0 then s2.Nombre else p2.Nombre1 end as NomProdServ,
	isnull(vd.PU,0.00) PU,
	isnull(vd.Cant,0.00) Cant,
	isnull(vd.IMP,0.00) IMP,
	isnull(vd.IGV,0.00) IGV,
	isnull(vd.Total,0.00) Total
from 
	compra v 
	inner join CompraDet vd on vd.RucE=v.RucE and vd.Cd_Com=v.Cd_Com
	left join Producto2 p2 on p2.RucE=vd.RucE and p2.Cd_Prod=vd.Cd_Prod
	left join servicio2 s2 on s2.RucE=vd.RucE and s2.Cd_Srv=vd.Cd_Srv
where 
	v.RucE='''+@RucE+''' and
	v.Ejer='''+@Ejer+''' and
	v.RegCtb in('
set @Consulta2=')'
exec 	(
	 @Consulta1+
	 @RegCtb+
	 @Consulta2
	)

-- Leyenda --
--JJ: 31/03/2011 : <Creacion del Procedimiento Almacenado>
--exec Rpt_CtasXCbr_Detallada '11111111111','2010','','31/12/2010','01',0
--exec Rpt_CtasXCbr_Asientos '11111111111','2010','01','''CTGE_RV10-00001'''
--exec Rpt_CtasXCbr_Producto '11111111111','2010','''CTGE_RV10-00001'''








GO
