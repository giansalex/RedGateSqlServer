SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Tsr_DocsAuxCons]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Aux nvarchar(10),
@IC_Oper nvarchar(1), -- I:Ingresos, E:Egresos T:Todos
@msj varchar(100) output
as

if @Cd_Aux='' or @Cd_Aux is null
begin
   set @msj = 'Debe selecionar un auxiliar'
   return
end

if(@IC_Oper = 'I')
begin	

	select 
		sum(case(IB_EsProv) when '1' then v.Cd_Vou else 0 end) as Cd_Vou, --> Cod. Vou de la Provision
		--v.Cd_Vou,
		--v.RegCtb,
		v.NroCta,
		p.NomCta,
		v.Cd_TD as TD,
		v.NroSre as Sre,
		v.NroDoc,
		Sum(v.MtoD-v.MtoH) as SaldoS,
		Sum(v.MtoD_ME-v.MtoH_ME) as SaldoD,
		Max(case(IB_EsProv) when '1' then Case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end
				    else '' end)  as MdReg, --> Moneda de la Provision
		sum(case(IB_EsProv) when '1' then v.CamMda else 0 end) as TC_Org  --> Tipo de Cam. de la Provision

	from Voucher v, PlanCtas p 
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Aux=@Cd_Aux and p.Ejer=@Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta and p.IB_CtasXCbr<>0 and isnull(v.IB_Cndo,0)!=1
	Group by /*v.Cd_Vou,v.RegCtb,*/v.NroCta,p.NomCta,v.Cd_TD,v.NroSre,v.NroDoc--,v.Cd_MdRg

	having Sum(v.MtoD-v.MtoH)!=0
	
	select 
		'' as Cd_Vou,
		--'' as RegCtb,
		'' as NroCta,
		'' as NomCta,
		'' as TD,
		'' as Sre,
		'TOTAL>>' as NroDoc,
		Sum(v.MtoD-v.MtoH) as SaldoS,
		Sum(v.MtoD_ME-v.MtoH_ME) as SaldoD,
		'' as MdReg
	from Voucher v, PlanCtas p 
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Aux=@Cd_Aux and p.Ejer=@Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta and p.IB_CtasXCbr<>0 and isnull(v.IB_Cndo,0)!=1
	having Sum(v.MtoD-v.MtoH)!=0
end
else if(@IC_Oper = 'E')
begin

	select 
		sum(case(IB_EsProv) when '1' then v.Cd_Vou else 0 end) as Cd_Vou, --> Cod. Vou. de la Provision
		--v.Cd_Vou,
		--v.RegCtb,
		v.NroCta,
		p.NomCta,
		v.Cd_TD as TD,
		v.NroSre as Sre,
		v.NroDoc,
		Sum(v.MtoD-v.MtoH) as SaldoS,
		Sum(v.MtoD_ME-v.MtoH_ME) as SaldoD,
		--Case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end MdReg
		Max(case(IB_EsProv) when '1' then Case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end
				    else '' end)  as MdReg, --> Moneda de la Provision
		sum(case(IB_EsProv) when '1' then v.CamMda else 0 end) as TC_Org --> Tipo de Cam. de la Provision
	from Voucher v, PlanCtas p 
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Aux=@Cd_Aux and p.Ejer=@Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta and p.IB_CtasXPag<>0 and isnull(v.IB_Cndo,0)!=1
	Group by /*v.Cd_Vou,v.RegCtb,*/v.NroCta,p.NomCta,v.Cd_TD,v.NroSre,v.NroDoc--,v.Cd_MdRg --, v.Cd_Vou --case(IB_EsProv) when '1' then v.Cd_Vou else 0 end--,v.Cd_Vou
	having Sum(v.MtoD-v.MtoH)!=0


	select 
		'' as Cd_Vou,
		--'' as RegCtb,		
		'' as NroCta,
		'' as NomCta,
		'' as TD,
		'' as Sre,
		'TOTAL>>' as NroDoc,
		Sum(v.MtoD-v.MtoH) as SaldoS,
		Sum(v.MtoD_ME-v.MtoH_ME) as SaldoD,
		'' as MdReg
	from Voucher v, PlanCtas p 
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Aux=@Cd_Aux and p.Ejer=@Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta and p.IB_CtasXPag<>0 and isnull(v.IB_Cndo,0)!=1
	having Sum(v.MtoD-v.MtoH)!=0
	
end
else --if(@IC_Oper = 'T')
begin

	select 
		sum(case(IB_EsProv) when '1' then v.Cd_Vou else 0 end) as Cd_Vou, --> Cod. Vou. de la Provision
		--v.Cd_Vou,
		--v.RegCtb,
		v.NroCta,
		p.NomCta,
		v.Cd_TD as TD,
		v.NroSre as Sre,
		v.NroDoc,
		Sum(v.MtoD-v.MtoH) as SaldoS,
		Sum(v.MtoD_ME-v.MtoH_ME) as SaldoD,
		--Case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end MdReg
		Max(case(IB_EsProv) when '1' then Case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end
				    else '' end)  as MdReg, --> Moneda de la Provision
		sum(case(IB_EsProv) when '1' then v.CamMda else 0 end) as TC_Org --> Tipo de Cam. de la Provision
	from Voucher v, PlanCtas p 
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Aux=@Cd_Aux and p.Ejer=@Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta and (p.IB_CtasXCbr<>0 or p.IB_CtasXPag<>0) and isnull(v.IB_Cndo,0)!=1
	Group by /*v.Cd_Vou,v.RegCtb,*/v.NroCta,p.NomCta,v.Cd_TD,v.NroSre,v.NroDoc--,v.Cd_MdRg --, v.Cd_Vou --case(IB_EsProv) when '1' then v.Cd_Vou else 0 end--,v.Cd_Vou
	having Sum(v.MtoD-v.MtoH)!=0


	select 
		'' as Cd_Vou,
		--'' as RegCtb,		
		'' as NroCta,
		'' as NomCta,
		'' as TD,
		'' as Sre,
		'TOTAL>>' as NroDoc,
		Sum(v.MtoD-v.MtoH) as SaldoS,
		Sum(v.MtoD_ME-v.MtoH_ME) as SaldoD,
		'' as MdReg
	from Voucher v, PlanCtas p 
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Aux=@Cd_Aux and p.Ejer=@Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta and (p.IB_CtasXCbr<>0 or p.IB_CtasXPag<>0) and isnull(v.IB_Cndo,0)!=1
	having Sum(v.MtoD-v.MtoH)!=0
	
end


/*
select * from auxiliar where ndoc='20481952027'

select * from voucher where RucE='11111111111' and Ejer='2009' and cd_aux='CLT0230'
select * from voucher where RucE='11111111111' and Ejer='2009' and RegCtb='CTGE_RC06-00006'

PRUEBAS:
 
exec Tsr_DocsAuxCons '11111111111','2009','CLT0230','E',null

select * from auxiliar where ruce='11111111111' order by cd_aux

select * from voucher where ruce='11111111111' and cd_aux='AUX0006'
select * from voucher where ruce='11111111111' and nroDoc='1002'
select * from voucher where ruce='11111111111' and regctb='TSGE_CB06-00003'



exec Tsr_DocsAuxCons '11111111111','2009','','E',null

select * from voucher where ruce='11111111111' and cd_aux=''


select * from voucher where ruce='11111111111' and cd_aux='CLT0032'--'20110231181'
select * from auxiliar where ndoc='20110231181' 

exec Tsr_DocsAuxCons '11111111111','2009','CLT0032','E',null
exec Tsr_DocsAuxCons '11111111111','2009','CLT0030','I',null
exec Tsr_DocsAuxCons '11111111111','2009','CLT0001','T',null

NOTA: si los cd_vou aparecen con 0 puede ser xq las proviciones no tienen el check IB_EsProv

*/

------CODIGO DE MODIFICACION--------
--CM=MG01

--PV: JUE 11/06/09 Mdf --> no debe ir columna RegCtb
--PV: JUE 09/07/09 Mdf --> para jalar solo moneda y TipCam de la provision
--PV: JUE 07/08/09 Mdf --> para jalar Todos (Ingreso y Egreso)
GO
