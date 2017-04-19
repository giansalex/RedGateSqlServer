SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_DocsAuxCons3_NCrd] -- Tiene en cuenta las Notas de Credito
@RucE nvarchar(11),
@Ejer nvarchar(4), -- Se manda pero no se tiene en cuenta
@Cd_Aux nvarchar(10),
@IC_Oper nvarchar(1), -- I:Ingresos, E:Egresos T:Todos
@msj varchar(100) output
as



declare 
@Cd_Clt char(10),
@Cd_Prv char(7)

if (left(@Cd_Aux,1)='C') -- Hacemos esto  temporalmente para no agregar @Cd_Clt y @Cd_Prv en los parametros de entrada
	set @Cd_Clt = @Cd_Aux
else set @Cd_Prv = @Cd_Aux



if @Cd_Aux='' or @Cd_Aux is null
begin
   set @msj = 'Debe selecionar un auxiliar'
   return
end

if(@IC_Oper = 'I')
begin	


/*
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
		dbo.TipCamCalc(@RucE,@Ejer,@Cd_Clt,@Cd_Prv,v.Cd_TD,v.NroSre,v.NroDoc) as TC_Org  --> Tipo de Cam. de la Provision o del ajuste (ES CALCULADO)
		--sum(case(IB_EsProv) when '1' then v.CamMda else 0 end) as TC_Org  --> Tipo de Cam. de la Provision
		
	from Voucher v, PlanCtas p 
*/
--	where v.RucE=@RucE /* and v.Ejer=@Ejer  */  and (v.Cd_Clt=@Cd_Aux /* or v.Cd_Prv=@Cd_Aux*/) /*v.Cd_Aux=@Cd_Aux  */  and p.Ejer=@Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta and p.IB_CtasXCbr<>0 and isnull(v.IB_Cndo,0)!=1
--	Group by /*v.Cd_Vou,v.RegCtb, */  v.NroCta,p.NomCta,v.Cd_TD,v.NroSre,v.NroDoc--,v.Cd_MdRg
--	having Sum(v.MtoD-v.MtoH)!=0


-------------
	select 		
			max(Cd_Vou) as Cd_Vou, NroCta, max(NomCta) as NomCta,TD, Sre, NroDoc,
			sum(SaldoS) as SaldoS, sum(SaldoD) as SaldoD, max(MdReg) as MdReg, max(TC_Org) as TC_Org
	from 
	(
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
			dbo.TipCamCalc('11111111111','2010',null,@Cd_Aux,v.Cd_TD,v.NroSre,v.NroDoc) as TC_Org  --> Tipo de Cam. de la Provision o del ajuste (ES CALCULADO)
			--sum(case(IB_EsProv) when '1' then v.CamMda else 0 end) as TC_Org  --> Tipo de Cam. de la Provision
			--DR_NDoc 		
	
		from Voucher v, PlanCtas p 
		where v.RucE='11111111111' /*and v.Ejer=@Ejer*/ and (/*v.Cd_Clt='CLT0000048'  or*/ v.Cd_Prv=@Cd_Aux) /*v.Cd_Aux=@Cd_Aux*/ and p.Ejer=@Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta and p.IB_CtasXCbr<>0 and isnull(v.IB_Cndo,0)!=1 and isnull(len(DR_NDoc),0)=0  
		Group by /*v.Cd_Vou,v.RegCtb,*/v.NroCta,p.NomCta,v.Cd_TD,v.NroSre,v.NroDoc /*,v.Cd_MdRg*/-- DR_NDoc
		--having Sum(v.MtoD-v.MtoH)!=0
	
		union
	
		select 	'' as Cd_Vou, v.NroCta,	'' as NomCta, v.DR_CdTD as TD, v.DR_NSre as Sre, v.DR_NDoc, 
			(v.MtoD-v.MtoH) as SaldoS, (v.MtoD_ME-v.MtoH_ME) as SaldoD, '' as MdReg, 0 as TC_Org 
		from Voucher v 
		where v.RucE='11111111111' and v.Ejer=@Ejer and v.Cd_Prv=@Cd_Prv and  isnull(v.IB_Cndo,0)!=1 and DR_NDoc is not null
	
	) as DocsAux
	
	Group by /*v.Cd_Vou,v.RegCtb,*/NroCta,TD,Sre,NroDoc 
	having Sum(SaldoS)!=0
-------------


	
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
	where v.RucE=@RucE /*and v.Ejer=@Ejer*/ and (v.Cd_Clt=@Cd_Aux /*or v.Cd_Prv=@Cd_Aux*/) /*v.Cd_Aux=@Cd_Aux*/ and p.Ejer=@Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta and p.IB_CtasXCbr<>0 and isnull(v.IB_Cndo,0)!=1
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
		Sum(v.MtoD-v.MtoH)*-1 as SaldoS,
		Sum(v.MtoD_ME-v.MtoH_ME)*-1 as SaldoD,
		--Case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end MdReg
		Max(case(IB_EsProv) when '1' then Case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end
				    else '' end)  as MdReg, --> Moneda de la Provision
		dbo.TipCamCalc(@RucE,@Ejer,@Cd_Clt,@Cd_Prv,v.Cd_TD,v.NroSre,v.NroDoc) as TC_Org  --> Tipo de Cam. de la Provision o del ajuste (ES CALCULADO)
		--sum(case(IB_EsProv) when '1' then v.CamMda else 0 end) as TC_Org --> Tipo de Cam. de la Provision

	from Voucher v, PlanCtas p 
	where v.RucE=@RucE/* and v.Ejer=@Ejer*/ and (/*v.Cd_Clt=@Cd_Aux or*/ v.Cd_Prv=@Cd_Aux) /*v.Cd_Aux=@Cd_Aux*/and p.Ejer=@Ejer and  v.RucE=p.RucE and v.NroCta=p.NroCta and p.IB_CtasXPag<>0 and isnull(v.IB_Cndo,0)!=1
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
	where v.RucE=@RucE /*and v.Ejer=@Ejer*/ and (/*v.Cd_Clt=@Cd_Aux or*/ v.Cd_Prv=@Cd_Aux) /*v.Cd_Aux=@Cd_Aux*/ and p.Ejer=@Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta and p.IB_CtasXPag<>0 and isnull(v.IB_Cndo,0)!=1
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
		dbo.TipCamCalc(@RucE,@Ejer,@Cd_Clt,@Cd_Prv,v.Cd_TD,v.NroSre,v.NroDoc) as TC_Org  --> Tipo de Cam. de la Provision o del ajuste (ES CALCULADO)
		--sum(case(IB_EsProv) when '1' then v.CamMda else 0 end) as TC_Org --> Tipo de Cam. de la Provision
	from Voucher v, PlanCtas p 
	where v.RucE=@RucE/* and v.Ejer=@Ejer*/ and (v.Cd_Clt=@Cd_Aux or v.Cd_Prv=@Cd_Aux) /*v.Cd_Aux=@Cd_Aux*/and p.Ejer=@Ejer  and v.RucE=p.RucE and v.NroCta=p.NroCta and (p.IB_CtasXCbr<>0 or p.IB_CtasXPag<>0) and isnull(v.IB_Cndo,0)!=1
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
	where v.RucE=@RucE /*and v.Ejer=@Ejer*/ and (v.Cd_Clt=@Cd_Aux or v.Cd_Prv=@Cd_Aux) /*v.Cd_Aux=@Cd_Aux*/and p.Ejer=@Ejer and v.RucE=p.RucE and v.NroCta=p.NroCta and (p.IB_CtasXCbr<>0 or p.IB_CtasXPag<>0) and isnull(v.IB_Cndo,0)!=1
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

/*
exec Tsr_DocsAuxCons '11111111111','2009','CLT0006','E',null
exec Tsr_DocsAuxCons '11111111111','2009','CLT0006','I',null
exec Tsr_DocsAuxCons '11111111111','2009','CLT0006','T',null

exec Tsr_DocsAuxCons2 '11111111111','2009','CLT0006','E',null
exec Tsr_DocsAuxCons2 '11111111111','2009','CLT0006','I',null
exec Tsr_DocsAuxCons2 '11111111111','2009','CLT0006','T',null
*/

--Prueba: Este metodo falla cuando la diferencia de saldos entre monedas es muy corta (no  calcula el TC exacto)
/* Probar estos datos:
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0001'
exec Tsr_DocsAuxCons '11111111111','2009','CLT0001','E',null
exec Tsr_DocsAuxCons2 '11111111111','2009','CLT0001','E',null
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0006' and Cd_TD='01' and nrosre='001'  and nroDoc='2527'
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0001' and Cd_TD='01' and nrosre='001'  and nroDoc='5050'
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0001' and Cd_TD='01' and nrosre='001'  and nroDoc='5051'
*/

--USAR ESTE PARA PRUEBAS - FL
--exec Tsr_DocsAuxCons2 '11111111111','2010','CLT0000002','T',null


--PV: JUE 11/06/09 Mdf --> no debe ir columna RegCtb
--PV: JUE 09/07/09 Mdf --> para jalar solo moneda y TipCam de la provision
--PV: JUE 07/08/09 Mdf --> para jalar Todos (Ingreso y Egreso)
--PV: JUE 05/11/09 Mdf: creado --> Tipo consulta Tipo de Cambio
--PV: MAR 05/01/2010 Mdf: --> Para que NO tome en cuenta el Ejer al jalar las facturas
--MP: JUE 16/09/2010 Mdf: --> Se quito las referencias a la tabla Auxiliar y se relaciono con Cliente y Proveedor
--CM: RA01
--PV: VIE 03/12/2010 Mdf: --> que mande Cd_Clt y Cd_Prv en funcion TipCamCalc()
--PV: JUE 31/03/2011 Mdf: --> se multiplico * -1 Para que jale CtasxPag en positivo.
--PV: MIE 13/04/2011 Mdf: Creado --> Para que tome en cuenta las notas de credito y debito (falta completar)

	





GO
