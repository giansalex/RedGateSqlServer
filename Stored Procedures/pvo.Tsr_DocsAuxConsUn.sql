SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Tsr_DocsAuxConsUn]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Aux nvarchar(10),
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15),
--@IC_Oper nvarchar(1),
@msj varchar(100) output
as

if @Cd_Aux='' or @Cd_Aux is null
begin
   set @msj = 'Debe selecionar un auxiliar'
   return
end

--declare @Flag bit




	select 
		sum(case(IB_EsProv) when '1' then v.Cd_Vou else 0 end) as Cd_Vou, --> Cod. Vou de la Provision
		--v.Cd_Vou,
		--v.RegCtb,
		v.NroCta,
		p.NomCta,
		v.Cd_TD as TD,
		v.NroSre as Sre,
		v.NroDoc,
		Max(case(IB_EsProv) when '1' then v.Glosa else '' end)  as Glosa, --> Glosa de la Provision
		Sum(v.MtoD-v.MtoH) as SaldoS,
		Sum(v.MtoD_ME-v.MtoH_ME) as SaldoD,
		Max(case(IB_EsProv) when '1' then v.Cd_MdRg else '' end)  as Cd_MdRg, --> Moneda de la Provision
		Max(case(IB_EsProv) when '1' then Case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end
				    else '' end)  as MdReg, --> Moneda de la Provision
		sum(case(IB_EsProv) when '1' then v.CamMda else 0 end) as TC_Org  --> Tipo de Cam. de la Provision
		--sum(case(IB_EsProv) when '1' then max()v.CamMda else 0 end) as TC_Org  --> Tipo de Cam. de la Provision

	from Voucher v, PlanCtas p 
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Aux=@Cd_Aux and v.RucE=p.RucE and v.NroCta=p.NroCta and (p.IB_CtasXCbr<>0 or p.IB_CtasXPag<>0) and isnull(v.IB_Cndo,0)!=1 and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc and p.Ejer=@Ejer

	Group by /*v.Cd_Vou,v.RegCtb,*/v.NroCta,p.NomCta,v.Cd_TD,v.NroSre,v.NroDoc--,v.Cd_MdRg

	having Sum(v.MtoD-v.MtoH)!=0 OR Sum(v.MtoD_ME-v.MtoH_ME)!=0
	



	if @@rowcount=0 and (select count(RegCtb) from voucher where RucE=@RucE and Ejer=@Ejer and Cd_Aux=@Cd_Aux and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc) >= 2
	begin	set @msj='Posiblemente este documento ya ah sido cancelado.'
	end		

	--NOTA: si no jala documento vereficar que las cuentas con que fueron regitras en la provision (Ejm 12,42) esten con el indicador IB_Ctas x Cbr o Pag segun sea el caso

	
	print @msj

/*
PRUEBAS:
exec Tsr_DocsAuxCons '11111111111','2009','CLT0230','E',null
exec Tsr_DocsAuxCons '11111111111','2009','CLT0030','I',null

exec dbo.Tsr_DocsAuxCons '20502036549','2009','AUX0095','I',null
exec dbo.Tsr_DocsAuxCons '20502036549','2009','AUX0095','E',null
exec pvo.Tsr_DocsAuxConsUn '20502036549','2009','AUX0095','02','001','53',null

PRUEBAS PARA CHANCA:
select * from voucher where ruce='20452574528' and Cd_Fte='RC' and NroDoc is not null and nrodoc != ''
select * from voucher where ruce='20452574528' and Cd_Aux='AUX0130' and Cd_TD='02' and nrosre='001'  and nroDoc='398'
exec pvo.Tsr_DocsAuxConsUn '20452574528','2009','AUX0130','02','001','398',null

PRUEBAS DEMO
exec pvo.Tsr_DocsAuxConsUn '11111111111','2009','CLT0006','01','001','2527',null
exec Tsr_DocsAuxCons '11111111111','2009','CLT0006','E',null
exec Tsr_DocsAuxCons '11111111111','2009','CLT0006','I',null
select * from auxiliar where ruce='11111111111'
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0006'


*/
------CODIGO DE MODIFICACION--------
--CM=MG01

--PV: VIE 07/08/09 creado 
--PV: VIE 14/10/09 Mdf:  se agrego msj 'doc. cancelado'
--PV: VIE 15/10/09 Mdf:  se campos consulta --> Cd_MdRg y Glosa'
GO
