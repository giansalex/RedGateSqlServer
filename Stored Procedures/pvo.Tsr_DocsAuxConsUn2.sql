SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Tsr_DocsAuxConsUn2]
@RucE nvarchar(11),
@Ejer nvarchar(4),  -- Se manda pero no se tiene en cuenta
--@Cd_Aux nvarchar(10),
@Cd_Clt char(10),
@Cd_Prv char(7),
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15),
--@IC_Oper nvarchar(1),
@msj varchar(100) output
--@det varchar(1000) output  --Podria agregarse un detalle de venta
as


if @NroSre=null or @NroSre is null
begin
   set @NroSre = ''
end





if (@Cd_Clt='' or @Cd_Clt is null) and (@Cd_Prv='' or @Cd_Prv is null)
begin
   set @msj = 'Debe selecionar un auxiliar'
   return
end



/*
if @Cd_Aux='' or @Cd_Aux is null
begin
   set @msj = 'Debe selecionar un auxiliar'
   return
end

*/


--declare @Flag bit
declare @count int

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
		dbo.TipCamCalc(@RucE,@Ejer,@Cd_Clt,@Cd_Prv,@Cd_TD,@NroSre,@NroDoc) as TC_Org,  --> Tipo de Cam. de la Provision o del ajuste (ES CALCULADO)
		--sum(case(IB_EsProv) when '1' then v.CamMda else 0 end) as TC_Org  --> Tipo de Cam. de la Provision
		--sum(case(IB_EsProv) when '1' then max()v.CamMda else 0 end) as TC_Org  --> Tipo de Cam. de la Provision
		Max(case(IB_EsProv) when '1' then v.Cd_CC else '' end) as Cd_CC,
		Max(case(IB_EsProv) when '1' then v.Cd_SC else '' end) as Cd_SC,
		Max(case(IB_EsProv) when '1' then v.Cd_SS else '' end) as Cd_SS 

	from Voucher v, PlanCtas p 
	where v.RucE=@RucE and /*v.Ejer=@Ejer and*/ (v.Cd_Clt=@Cd_Clt or v.Cd_Prv=@Cd_Prv)/*v.Cd_Aux=@Cd_Aux*/ and v.RucE=p.RucE and v.NroCta=p.NroCta and (p.IB_CtasXCbr<>0 or p.IB_CtasXPag<>0) and isnull(v.IB_Cndo,0)!=1 and Cd_TD=@Cd_TD and isnull(NroSre,'') = @NroSre and NroDoc=@NroDoc and p.Ejer=@Ejer

	Group by /*v.Cd_Vou,v.RegCtb,*/v.NroCta,p.NomCta,v.Cd_TD,v.NroSre,v.NroDoc --, v.Cd_CC, v.Cd_SC, v.Cd_SS   --,v.Cd_MdRg

	having Sum(v.MtoD-v.MtoH)!=0 OR Sum(v.MtoD_ME-v.MtoH_ME)!=0
	


	set @count = @@rowcount

	if @count=0 and (select count(RegCtb) from voucher where RucE=@RucE and /*Ejer=@Ejer and*/ (Cd_Clt=@Cd_Clt or Cd_Prv=@Cd_Prv)  /*Cd_Aux=@Cd_Aux*/ and Cd_TD=@Cd_TD and isnull(NroSre,'')=@NroSre and NroDoc=@NroDoc) = 1
	begin	set @msj='voucher de origen no se encontro vinculado a ninguna cta. por pagar o cobrar. Revise Plan de Ctas.'
	end		


	if @count=0 and (select count(RegCtb) from voucher where RucE=@RucE and /*Ejer=@Ejer and*/ (Cd_Clt=@Cd_Clt or Cd_Prv=@Cd_Prv)  /*Cd_Aux=@Cd_Aux*/ and Cd_TD=@Cd_TD and isnull(NroSre,'')=@NroSre and NroDoc=@NroDoc) >= 2
	begin	set @msj='Posiblemente este documento ya ha sido cancelado.'
	end	
		

	--NOTA: si no jala documento vereficar que las cuentas con que fueron regitras en la provision (Ejm 12,42) esten con el indicador IB_Ctas x Cbr o Pag segun sea el caso

	
	print @msj
	print @count

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

PRUEBAS DEMO 2
exec pvo.Tsr_DocsAuxConsUn '11111111111','2009','CLT0002','01','0001','0000039',null
exec Tsr_DocsAuxCons '11111111111','2009','CLT0002','E',null
exec Tsr_DocsAuxCons '11111111111','2009','CLT0002','I',null
select * from auxiliar where ruce='11111111111'
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0002'
select * from voucher where ruce='11111111111' and Ejer='2009' and RegCtb='VTGE_RV04-00001'

print dbo.TipCamCalc('11111111111','2009','CLT0002','01','001','0000039')

select * from PlanCtas where RucE='11111111111' and NroCta='12.1.0.01'


PRUEBAS 3 (Pruebas para cuando jala xq NroSerie es vacio '')
exec pvo.Tsr_DocsAuxConsUn2 '20110143215','2009','CLT0025','12','','300',null
exec pvo.Tsr_DocsAuxConsUn2 '20110143215','2009','CLT0025','12',null,'300',null
exec pvo.Tsr_DocsAuxConsUn2 '20110143215','2009','CLT0025','12',null,'37',null

print dbo.TipCamCalc('20110143215','2009','CLT0025','12',null,'300')
print dbo.TipCamCalc('20110143215','2009','CLT0025','12','','300')
print dbo.TipCamCalc('20110143215','2009','CLT0025','12',null,'37')
print dbo.TipCamCalc('20110143215','2009','CLT0025','12','','37')

PRUEBAS 4 (Pruebas para ver si sigue funcionando despues de quitar la referencia a auxiliar)
exec pvo.Tsr_DocsAuxConsUn2 '11111111111','2010','CLT0000002','01','0001','0000106',null

select * from voucher where Ruce= '11111111111' and (Cd_Clt is not null or Cd_Prv is not null)

update  voucher set Cd_Prv='PRV0001' where Ruce= '11111111111' and Cd_Vou='125'
update  voucher set Cd_Prv='PRV0001' where Ruce= '11111111111' and Cd_Vou='136'
update  voucher set Cd_Prv='PRV0001' where Ruce= '11111111111' and Cd_Vou='19704'

update  voucher set Cd_Clt='CLT0000002' where Ruce= '11111111111' and Cd_Vou='19675'
update  voucher set Cd_Clt='CLT0000002' where Ruce= '11111111111' and Cd_Vou='19493'
update  voucher set Cd_Clt='CLT0000002' where Ruce= '11111111111' and Cd_Vou='19558'

delete from voucher where Ruce= '11111111111' and regCtb='TSGE_CB09-00003'

exec pvo.Tsr_DocsAuxConsUn2 '11111111111','2010',null, 'PRV0222','01','005','888',null
exec pvo.Tsr_DocsAuxConsUn2 '11111111111','2010','CLT0000009', null,'01','005','888',null
*/

--PV: VIE 07/08/09 creado 
--PV: VIE 14/10/09 Mdf:  se agrego msj 'doc. cancelado'
--PV: VIE 15/10/09 Mdf:  se campos consulta --> Cd_MdRg y Glosa'
--PV: JUE 05/11/09 Mdf: creado --> Tipo consulta Tipo de Cambio
--PV: LUN 28/11/09 Mdf: se agrego isnull(NroSre,'') al where por el incoveniente al consultar cuando este campo es '' (vacio, No nulo) 
---------------------------------------------
--PV: MAR 05/01/2010 Mdf: --> Para que NO tome en cuenta el Ejer al jalar las facturas
--PV: LUN 25/01/2010 Mdf: --> se creo  variable @count por lo que no resulta poner 2 @@rowcount seguidos
--PV: VIE 29/01/2010 Mdf: --> Se modifico @msj='Posiblemente este documento ya ah sido cancelado.'
--PV & MP: JUE 16/09/2010 Mdf: --> Se quito la referencia a la tabla auxiliar y se enlazo con la tabla Cliente y Proveedor
--CM: RA01
--PV: JUE 02/12/2010 Mdf: --> se agrego Cd_Clt, Cd_Prv 
--PV: VIE 03/12/2010 Mdf: --> se agrego para que jale CCs


GO
