SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_BancoConsUn_SaldoyNroChq]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Itm_BC nvarchar(10),
@FecMov smalldatetime,

@msj varchar(100) output

AS

/*
DECLARE @RucE nvarchar(11) Set @RucE='20379028455'
DECLARE @Ejer nvarchar(4) Set @Ejer='2011'
DECLARE @Itm_BC nvarchar(10) Set @Itm_BC='BC00000004'
DECLARE @FecMov smalldatetime Set @FecMov='04/04/2011'
DECLARE @msj VARCHAR(100)
*/

DECLARE @NroCta varchar(10)
Set @NroCta= (Select NroCta From Banco Where RucE=@RucE and Ejer=@Ejer and Itm_BC=@Itm_BC)
PRINT @NroCta

DECLARE @Dia int Set @Dia=day(@FecMov)
DECLARE @Mes int Set @Mes=month(@FecMov)
DECLARE @Anio int Set @Anio=year(@FecMov)


if not exists (select * from Banco where RucE=@RucE and Ejer=@Ejer and Itm_BC=@Itm_BC)
	set @msj = 'Banco no existe'
else
Begin
	select 	b.RucE,b.Itm_BC,b.Ejer,b.NroCTa,b.NCtaB,b.NCorto,b.Cd_Mda,b.Estado,b.Cd_EF,
		c.NomCta,
		a.CodSNT_,
		a.Nombre,
		isnull(Sum(Tab.SCMN),0.00) As SaldoCtb_MN,
		isnull(Sum(Tab.SCME),0.00) As SaldoCtb_ME,
		isnull(Sum(Tab.SBMN),0.00) As SaldoBco_MN,
		isnull(Sum(Tab.SBME),0.00) As SaldoBco_ME,
		dbo.NroChke(@RucE,@Ejer,@NroCta) As NroCheque
	From	Banco b
		left join (	Select	RucE,Ejer,NroCta,Sum(MtoD-MtoH) As SCMN, Sum(MtoD_ME-MtoH_ME) As SCME, 0.00 As SBMN, 0.00 As SBME
				From  	Voucher Where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta 
					--and FecMov<=@FecMov
					and year(FecMov)=@Anio and (month(FecMov)<@Mes or (month(FecMov)=@Mes and day(FecMov)<=@Dia))
					and isnull(IB_Anulado,0)=0
				Group by RucE,Ejer,NroCta
				UNION ALL
				Select	RucE,Ejer,NroCta,0.00 As SCMN, 0.00 As SCME, Sum(MtoD-MtoH) As SBMN, Sum(MtoD_ME-MtoH_ME) As SBME
				From  	Voucher Where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta 
					--and FecMov<=@FecMov 
					and year(FecMov)=@Anio and (month(FecMov)<@Mes or (month(FecMov)=@Mes and day(FecMov)<=@Dia))
					and isnull(IB_Anulado,0)=0 and isnull(IB_Conc,0)=1
				Group by RucE,Ejer,NroCta
			  ) 	As Tab ON Tab.RucE=b.RucE and Tab.Ejer=b.Ejer and Tab.NroCta=b.NroCta
		left join PlanCtas c on  b.RucE=c.RucE and b.Ejer=c.Ejer and b.NroCta=c.NroCta 
		left join EntidadFinanciera a on a.Cd_EF=b.Cd_EF
	Where
		b.RucE=@RucE and b.Ejer=@Ejer and Itm_BC=@Itm_BC 
	Group by 
		b.RucE,b.Itm_BC,b.Ejer,b.NroCTa,b.NCtaB,b.NCorto,b.Cd_Mda,b.Estado,b.Cd_EF,
		c.NomCta,
		a.CodSNT_,
		a.Nombre
end

-- Leyenda --
-- DI : 31/03/2011 <Creacion de procedimiento almacenado>


GO
