SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [pvo].[Ctb_AjustaSaldoDocUn]
@RucE	nvarchar(11),
@Ejer	nvarchar(4),
@FecMov	smalldatetime,
@RegCtb	nvarchar(15),
@NroCta	nvarchar(10),
@Cd_Clt	char(10),
@Cd_Prv	char(7),
@Cd_TD	nvarchar(2),
@NroSre	nvarchar(4),
@NroDoc	nvarchar(15),
@UsuCrea nvarchar(10),
@TC_Aj   numeric(6,3), 
@Cd_Area nvarchar(6),
@Cd_MR	 nvarchar(2),
@Cd_CC	nvarchar(8),
@Cd_SC	nvarchar(8),
@Cd_SS	nvarchar(8),
@msj 	varchar(100) output
as


declare

@Prdo	nvarchar(2) = right('0' + convert(varchar,(month(@FecMov))),2),
@Cd_Fte	varchar(2) = left(right(@RegCtb,10),2),
@FecCbr	smalldatetime,
@FecED	smalldatetime,
@FecVD	smalldatetime,
@Glosa		varchar(200) = 'Ajuste de Saldo',
@MtoOr	numeric(13,2),
@MtoD		numeric(13,2),
@MtoH		numeric(13,2),
@Cd_MdOr 	nvarchar(2),
@Cd_MdRg 	nvarchar(2),
@NroChke 	varchar(30),
@Cd_TG	nvarchar(2)  = '01',
@IC_CtrMd	varchar(1),
@IC_TipAfec 	varchar(1),
@TipOper 	varchar(4),
@Grdo	 	varchar(100),
@IB_EsProv	bit, 
@IC_Gen		varchar(1)  = 'A', 
@DR_FecED	smalldatetime,
@DR_CdTD	nvarchar(2),
@DR_NSre	nvarchar(4),
@DR_NDoc	nvarchar(15),
@SaldoMN numeric(13,2), 
@SaldoME numeric(13,2) ,
@Mto numeric(13,2), 
@MtoAjuste numeric(13,2),
@TipMov	varchar(1) = 'M'

if @NroSre=null or @NroSre is null
   set @NroSre = ''

select  @FecCbr=FecCbr, @FecED=FecED, @FecVD=FecVD, @MtoOr=isnull(MtoOr,0), @NroChke=NroChke, @Cd_TG=Cd_TG, @IC_TipAfec=IC_TipAfec, @TipOper=TipOper, @Grdo=Grdo, @DR_FecED=DR_FecED, @DR_CdTD=DR_CdTD, @DR_NSre=DR_NSre, @DR_NDoc=DR_NDoc
	from voucher where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta and (Cd_Clt=@Cd_Clt or Cd_Prv=@Cd_Prv) and isnull(Cd_TD,'')=isnull(@Cd_TD,'') and isnull(NroSre,'')=isnull(@NroSre,'') and isnull(NroDoc,'')=isnull(@NroDoc,'') and IB_EsProv=1 and IB_Anulado!=1

print 'Mto origen: ' + convert(varchar,@MtoOr)

if (@Cd_Clt is null or @Cd_Clt='') and (@Cd_Prv is null or @Cd_Prv='')
	select @SaldoMN=sum(MtoD-MtoH), @SaldoME=sum(MtoD_ME-MtoH_ME) from voucher where ruce=@ruce and Ejer=@Ejer and NroCta=@NroCta and FecMov<=dateadd(day,1,convert(datetime,convert(varchar, @FecMov,103))) and IB_Anulado!=1
else 
	select @SaldoMN=sum(MtoD-MtoH), @SaldoME=sum(MtoD_ME-MtoH_ME) from voucher where ruce=@ruce and Ejer=@Ejer and NroCta=@NroCta and (Cd_Clt=@Cd_Clt or Cd_Prv=@Cd_Prv)  and isnull(Cd_TD,'')=isnull(@Cd_TD,'') and isnull(NroSre,'')=isnull(@NroSre,'') and isnull(NroDoc,'')=isnull(@NroDoc,'') and FecMov<= dateadd(day,1,convert(datetime,convert(varchar, @FecMov,103))) and IB_Anulado!=1 and (Prdo != '13' and Prdo != '14' )

select @Cd_MdRg=Cd_Mda from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta= @NroCta 

if @Cd_MdRg is null
	set @Cd_MdRg = '01'

if @Cd_MdOr is null
	set @Cd_MdOr = @Cd_MdRg

if @Cd_CC is null
begin
	set @Cd_CC = '01010101'
	set @Cd_SC = '01010101'
	set @Cd_SS = '01010101'
end

print 'Mda: ' + @Cd_MdRg + ', SaldoMN: ' + convert(varchar,@SaldoMN) + ', SaldoME: ' + convert(varchar,@SaldoME)

if(@Cd_MdRg='01')
begin
	if(@TC_Aj!=0)
		set @Mto = @SaldoMN/@TC_Aj
	else set @Mto = 0
	print 'Mto(Sldo) que deberia ser en U$$: ' + convert(varchar,@Mto) + ' al TC: '+ convert(varchar,@TC_Aj)

	set @MtoAjuste = @SaldoME-@Mto
	set @IC_CtrMd = '$'  --Ajuste se hara solo en Dolares
	set @Cd_MdRg='02' --Decimos que el monto ingresado sera en Dolares
end
else --if(@Cd_MdRg='02')
begin
	set @Mto = @SaldoME*@TC_Aj
	print 'Mto(Sldo) que deberia ser en S/.: ' + convert(varchar,@Mto) + ' al TC: '+ convert(varchar,@TC_Aj)

	set @MtoAjuste = @SaldoMN-@Mto
	set @IC_CtrMd = 's'  --Ajuste se hara solo en Soles
	set @Cd_MdRg='01' --Decimos que el monto ingresado sera en Soles
end

print 'Mto Ajustado: ' + convert(varchar,@MtoAjuste)
if @MtoAjuste<0
begin
	set @MtoD = abs(@MtoAjuste)
	set @MtoH = 0
end
else if @MtoAjuste>0
begin
	set @MtoD = 0
	set @MtoH = @MtoAjuste
end
else
	return

if(@MtoOr is null)
 set @MtoOr = 0

exec pvo.Ctb_VoucherInsert6_conCtaDest1
			   @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, /*@Cd_Aux,*/@Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre,
			   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, @TC_Aj, @Cd_CC,
			   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
			   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc, 
			   @TipMov, @msj output

---------------------------------------------------
/*
exec pvo.Tsr_DocsAuxConsUn '11111111111','2009','CLT0006','01','001','2527',null
exec Tsr_DocsAuxCons '11111111111','2009','CLT0006','E',null
exec Tsr_DocsAuxCons '11111111111','2009','CLT0006','I',null
select * from auxiliar where ruce='11111111111'
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0006'
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0006' and RegCtb='CTGE_LD11-00001'
delete voucher where ruce='11111111111' and Cd_Aux='CLT0006' and RegCtb='CTGE_LD11-00001'





Modificaciones Necesarias
select * from voucher where ruce='11111111111' and IB_EsProv=1
select * from voucher where IB_EsProv=1

update voucher set IC_Gen='A' where ruce='11111111111' and IB_EsProv=1
update voucher set IC_Gen='A' where IB_EsProv=1




exec pvo.Ctb_AjustaSaldoDocUn '11111111111','2009','01/11/2009','42.1.0.02','CLT0006','01','001','2527','admin',5.00,null
exec pvo.Ctb_AjustaSaldoDocUn '11111111111','2009','01/11/2009','42.1.0.02','CLT0006','01','001','2527','admin',4.00,null

*/




/* Probar estos datos:
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0006'
exec Tsr_DocsAuxCons '11111111111','2009','CLT0006','E',null
exec Tsr_DocsAuxCons2 '11111111111','2009','CLT0006','E',null
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0006' and Cd_TD='01' and nrosre='001'  and nroDoc='2527'
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0001' and Cd_TD='01' and nrosre='001'  and nroDoc='5050'
select * from voucher where ruce='11111111111' and Cd_Aux='CLT0001' and Cd_TD='01' and nrosre='001'  and nroDoc='5051'
*/



/*
ultimas pruebas CASO: AJUSTE DE CUENTAS SIN AUXILIAR/DOC
select * from voucher where ruce='11111111111' and Ejer='2009' and NroCta='10.1.0.02'-- Cd_Aux='AUX0001' and Cd_TD='01' and nrosre='001'  and nroDoc='2020'
select * from voucher where ruce='11111111111' and Ejer='2009' and RegCtb='CTGN_LD11-00001'
delete voucher where ruce='11111111111' and Ejer='2009' and RegCtb='CTGN_LD11-00001'

exec pvo.Ctb_AjustaSaldoDocUn '11111111111','2009','01/11/2009','10.1.0.02',null,null,null,null,'admin',5.00,null
exec pvo.Ctb_AjustaSaldoDocUn '11111111111','2009','01/11/2009', 'CTGN_LD11-00001', '10.1.0.02',null,null,null,null,'admin',5.00, '010101', '03', null



select * from voucher where ruce='11111111111' and Cd_Aux='CLT0006' and Cd_TD='01' and nrosre='001'  and nroDoc='2527'
select * from voucher where ruce='11111111111' and RegCtb='CTGE_CB11-00001' and Cd_Aux='CLT0006' and Cd_TD='01' and nrosre='001'  and nroDoc='2527'
delete voucher where ruce='11111111111' and RegCtb='CTGE_LD11-00006' and Cd_Aux='CLT0006' and Cd_TD='01' and nrosre='001'  and nroDoc='2527'
delete voucher where ruce='11111111111' and RegCtb='CTGE_LD11-00005' and Cd_Aux='CLT0006' and Cd_TD='01' and nrosre='001'  and nroDoc='2527'
select * from voucher where ruce='11111111111' and RegCtb='CTGE_RC10-00007' and Cd_Aux='CLT0006' and Cd_TD='01' and nrosre='001'  and nroDoc='2527'

update voucher set Cd_MdRg='01' where ruce='11111111111' and RegCtb='CTGE_RC10-00007' and Cd_Aux='CLT0006' and Cd_TD='01' and nrosre='001'  and nroDoc='2527'



exec pvo.Ctb_AjustaSaldoDocUn '11111111111','2009','01/11/2009','42.1.0.02','CLT0006','01','001','2527','admin',5.00,null



11111111111	14420	2009	10	CTGE_RC10-00007	RC	2009-10-02 00:00:00	2009-10-02 00:00:00	42.1.0.02	CLT0006	01	001	2527	2009-10-02 00:00:00	NULL	NULL	.00	.00	300.00	.00	100.00	02	02	3.000	01010101	01010101	01010101	0001	03	01	a	NULL	NULL	NULL	NULL	NULL	NULL	1	2009-11-02 17:52:30.023	NULL	admin	NULL	0	NULL	NULL	NULL	NULL	NULL	A
11111111111	14424	2009	10	CTGE_CB10-00003	CB	2008-10-30 00:00:00	2008-10-30 00:00:00	42.1.0.02	CLT0006	01	001	2527	2008-10-30 00:00:00	NULL	NULL	.00	150.00	.00	50.00	.00	02	02	3.000	01010101	01010101	01010101	0001	03	01	a	NULL	NULL	NULL	NULL	NULL	NULL	0	2009-11-02 17:57:37.980	NULL	admin	NULL	0	NULL	NULL	NULL	NULL	NULL	NULL
11111111111	14445	2009	11	CTGE_LD11-00001	LD	2009-11-01 00:00:00	2009-10-02 00:00:00	42.1.0.02	CLT0006	01	001	2527	2009-10-02 00:00:00	NULL	NULL	.00	.00	100.00	.00	.00	02	01	5.000	01010101	01010101	01010101	0001	03	01	s	NULL	NULL	NULL	NULL	NULL	NULL	NULL	2009-11-09 14:23:51.270	NULL	admin	NULL	0	NULL	NULL	NULL	NULL	NULL	NULL
11111111111	14446	2009	11	CTGE_LD11-00002	LD	2009-11-01 00:00:00	2009-10-02 00:00:00	42.1.0.02	CLT0006	01	001	2527	2009-10-02 00:00:00	NULL	NULL	.00	50.00	.00	.00	.00	02	01	4.000	01010101	01010101	01010101	0001	03	01	s	NULL	NULL	NULL	NULL	NULL	NULL	NULL	2009-11-09 14:25:45.253	NULL	admin	NULL	0	NULL	NULL	NULL	NULL	NULL	NULL
11111111111	14447	2009	11	CTGE_LD11-00003	LD	2009-11-09 00:00:00	2009-11-09 00:00:00	42.1.0.02	CLT0006	01	001	2527	2009-11-09 00:00:00	NULL	NULL	.00	200.00	.00	.00	.00	01	01	2.900	01010101	01010101	01010101	0001	03	01	s	NULL	NULL	NULL	NULL	NULL	NULL	0	2009-11-09 14:29:50.273	NULL	admin	NULL	0	NULL	NULL	NULL	NULL	NULL	NULL
11111111111	14451	2009	11	CTGE_LD11-00004	LD	2009-11-01 00:00:00	2009-10-02 00:00:00	42.1.0.02	CLT0006	01	001	2527	2009-10-02 00:00:00	NULL	NULL	.00	.00	200.00	.00	.00	02	01	4.000	01010101	01010101	01010101	0001	03	01	s	NULL	NULL	NULL	NULL	NULL	NULL	NULL	2009-11-09 14:39:11.867	NULL	admin	NULL	0	NULL	NULL	NULL	NULL	NULL	NULL
11111111111	14452	2009	11	CTGE_LD11-00005	LD	2009-11-09 00:00:00	2009-11-09 00:00:00	42.1.0.02	CLT0006	01	001	2527	2009-11-09 00:00:00	NULL	NULL	.00	.00	.00	50.00	.00	02	02	2.900	01010101	01010101	01010101	0001	03	01	$	NULL	NULL	NULL	NULL	NULL	NULL	0	2009-11-09 14:41:41.313	NULL	admin	NULL	0	NULL	NULL	NULL	NULL	NULL	NULL
11111111111	14460	2009	11	CTGE_CB11-00001	CB	2009-11-09 00:00:00	2009-11-09 00:00:00	42.1.0.02	CLT0006	01	001	2527	2009-11-09 00:00:00	NULL	NULL	.00	200.00	.00	.00	.00	01	01	.000	01010101	01010101	01010101	0001	03	01	a	NULL	NULL	NULL	NULL	NULL	NULL	0	2009-11-09 15:25:30.637	NULL	admin	NULL	0	NULL	NULL	NULL	NULL	NULL	NULL

*/


--PV: LUN 02/11/09 creado 
--PV: JUE 10/12/09 --> Mdf: Terminado
--PV: LUN 21/12/09 --> Mdf: que llame a sp Insertar6_conCtaDest
--PV: MIE 11/08/10 --> Mdf: se modifico para que reconosca documentos con series NULL o ''
--PV: MAR 10/05/2011 --> Mdf: se agregó tema @Cd_Clt, @Cd_Prv
--PV: LUN 17/09/2012 --> Mdf: se excluyo lo anulados

---------------------- NO TOCAR ESTE SP -------------------- (PV)



GO
