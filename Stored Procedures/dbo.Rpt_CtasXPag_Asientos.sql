SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Rpt_CtasXPag_Asientos]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
@RegCtb varchar(8000)
as

declare @Consulta11 varchar(4000)
declare @Consulta12 varchar(4000)

set @Consulta11='
select 	
	v.RegCtb, 
	v.NroCta,
	p.NomCta,
	case('''+@Cd_Mda+''') when ''01'' then v.MtoD else v.MtoD_ME end as Debe,
	case('''+@Cd_Mda+''') when ''01'' then v.MtoH else v.MtoH_ME end as Haber,
	Case(isnull(Len(v.IC_TipAfec),0)) when 0 then ''X'' else isnull(UPPER(v.IC_TipAfec),'''') end as IC_TipAfec
from 
	Voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
Where 	
	v.RucE='''+@RucE+''' and 
	v.Ejer='''+@Ejer+''' and
	v.RegCtb in ('
set @Consulta12=
	') and
	Isnull(v.IB_Anulado,0)=0
'

Print @Consulta11
Print @RegCtb
Print @Consulta12

Exec (
	@Consulta11+
	@RegCtb+
	@Consulta12
     )

-- Leyenda --
--JJ: 30/03/2011 : <Creacion del Procedimiento Almacenado>
--exec Rpt_CtasXCbr_Detallada '11111111111','2010','','31/12/2010','01',0
--exec Rpt_CtasXCbr_Asientos '11111111111','2010','01','CTGE_RV10-00001'
--exec Rpt_CtasXCbr_Producto '11111111111','2010','''CTGE_RV10-00001'''



GO
