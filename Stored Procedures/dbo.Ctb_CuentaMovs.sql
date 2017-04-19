SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_CuentaMovs]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@NroCta nvarchar(10),
@msj varchar(100) output
as
select 
	Cd_Fte,
	Sum(MtoD) as Debe,
	Sum(MtoH) as Haber,
        Sum(MtoD - MtoH) as Saldo,
	Sum(MtoD_ME) as DebeME,
	Sum(MtoH_ME) as HaberME,
        Sum(MtoD_ME - MtoH_ME) as SaldoME
from Voucher 
where RucE=@RucE and Ejer=@Ejer and Prdo between @PrdoIni and @PrdoFin and NroCta=@NroCta and IB_Anulado <> 1
Group by Cd_Fte
Order by 2 desc


select 
	'Total'Cd_Fte,
	Sum(MtoD) as Debe,
	Sum(MtoH) as Haber,
        Sum(MtoD - MtoH) as Saldo,
	Sum(MtoD_ME) as DebeME,
	Sum(MtoH_ME) as HaberME,
        Sum(MtoD_ME - MtoH_ME) as SaldoME
from Voucher 
where RucE=@RucE and Ejer=@Ejer and Prdo between @PrdoIni and @PrdoFin and NroCta=@NroCta and IB_Anulado <> 1
GO
