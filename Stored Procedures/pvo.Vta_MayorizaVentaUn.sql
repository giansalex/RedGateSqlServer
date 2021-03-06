SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Vta_MayorizaVentaUn]
@RucE nvarchar(11),
@Ejer nvarchar(4), 
@RegCtb nvarchar(15),
@Ind_OK varchar(10) output,
@msj varchar(100) output
as


SET CONCAT_NULL_YIELDS_NULL OFF -- PARA CONCATENAR NULLS


--select * from Venta

if not exists (select * from Venta where RucE=@RucE and Eje=@Ejer and RegCtb=@RegCtb)
begin	set @msj = 'No existe venta con Reg. contable: '+@RegCtb
	print @msj
	return
end

if exists (select * from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
	set @msj = 'IMPOSIBLE MAYORIZAR. Ya exite voucher con el mismo Reg. Contable, elimine venta y vuelva a registrar'
	
else
begin
/*	if (select opc.EnLinea from Config where RucE=@RucE) = 0
	    return
	else
*/




--alter procedure pvo.Ctb_VoucherCrea7 --Modificacion: 7C
declare 
---> @RucE	nvarchar(11),
--@Cd_Vou	int,
---> @Ejer	nvarchar(4),
@Prdo		nvarchar(2),
---> @RegCtb	nvarchar(15),
@Cd_Fte	varchar(2),
@FecMov	smalldatetime,
@FecCbr	smalldatetime,
@NroCta	nvarchar(12),
@CtaAsoc nvarchar(12),  --> cta definida en Clientes/Proveedores
@Cd_Aux	nvarchar(7),
@Cd_TD	nvarchar(2),
@NroSre	nvarchar(4),
@NroDoc	nvarchar(15),
@FecED	smalldatetime,
@FecVD	smalldatetime,
@Glosa		varchar(200),
@MtoOr	numeric(13,2),
@MtoD		numeric(13,2),
@MtoH		numeric(13,2),
@Cd_MdOr 	nvarchar(2),
@Cd_MdRg 	nvarchar(2),
@CamMda 	numeric(6,3),
@Cd_CC	nvarchar(8),
@Cd_SC	nvarchar(8),
@Cd_SS	nvarchar(8),
@Cd_Area 	nvarchar(6),
@Cd_MR	nvarchar(2),
@NroChke 	varchar(30),
@Cd_TG	nvarchar(2),
@IC_CtrMd	varchar(1),
--FecReg 	datetime,
--FecMdf 	datetime,
@UsuCrea 	nvarchar(10),
--UsuModf 	nvarchar(10),
--@IB_Anulado 	bit
@SaldoMN	decimal(13,2), --->output,
@SaldoME	decimal(13,2), --->output,
@TipMov		varchar(1), --> M: Manual, A: Automatico
------------------------------
@IC_TipAfec 	varchar(1),
@TipOper 	varchar(4), -- Tipo Operacion de cancelacion
@Grdo	 	varchar(100),
@RegOrg		nvarchar(15),  --> Para saber que provicion estamos cancelando
------------------------------
@IC_Crea	varchar(1), --> I:Inicio, T:Transicion, F:Fin  <-- Indicador del estado de creacion
@IB_PgTot	bit, --> 0:Parcial, 1:Total  <-- Indicador Pago Total
@IB_EsProv	bit --> Indicador Es Provicion
---> @msj varchar(100) output

--with encryption
--as

	declare @Cd_Vta nvarchar(10), @Cd_Sr nvarchar(4)



--select * from venta where RucE='11111111111' and Eje='2009' and RegCtb='VTGE_RV07-00020'

	--Cojemos los campos posibles de la Venta
	select  
	@Cd_Vta=Cd_Vta, @Prdo=Prdo, @FecMov=FecMov, @FecCbr=FecCbr,  @Cd_Aux=Cd_Cte, @Cd_TD=Cd_TD, @Cd_Sr=Cd_Sr, @NroDoc=NroDoc,
	@FecED=FecED, @FecVD=FecVD, @MtoOr=Total,  @Cd_MdRg=Cd_Mda, @CamMda=CamMda,  @Cd_Area=Cd_Area,
	@UsuCrea=UsuCrea
	from venta where RucE=@RucE and Eje=@Ejer and RegCtb=@RegCtb
	
	if @FecED is null
	   set @FecED = @FecMov


	if @CamMda<= 0 
	begin
		set @CamMda = 0.00
		Print '**** ERROR ****** No se encontro Tip. Camb. en Registro de venta.'
		Print '**** Se tomo tipo de cambio de la Fecha de Mov.'
		set @CamMda = (select TCVta from TipCam where convert(varchar,FecTC,103) = convert(varchar,@FecMov,103) )
		Print @FecMov
		if (@CamMda is null)
			set @CamMda = 1.00
		print 'Tipo Cambio: ' + convert(varchar,@CamMda)
	end

	--Completamos los campos obios
	set @Cd_Fte ='RV'
	set @Cd_MdOr = '01'
	set @Glosa = 'Por el cobro del documento: ' + @NroDoc
	set @Cd_MR='01'
	set @TipMov='A' --> M: Manual, A: Automatico
	set @IC_CtrMd = 'a' -- ambas	
	set @Cd_TG = '01' -- No especificado
	set @NroChke = null -- solo para CB
	set @TipOper = null -- solo para CB
	set @RegOrg = null -- solo para CB	

	set @IC_Crea = 'I'
	set @IB_PgTot = 1
	set @IB_EsProv = 1
	set @Grdo = null -- solo para CB

	--Analizamos para completar campos
	--->set @NroCta, (ok)
	--->set @CtaAsoc, (ok)
	--->set @NroSre  (ok)
	--->set @MtoD, 
	--->set @MtoH, 
	--->@Cd_CC, @Cd_SC, @Cd_SS,
	--->@SaldoMN output, @SaldoME output,
	------------------------------
	--->@IC_TipAfec,  
	------------------------------
	--@msj output



--VTGE_RV07-00020	RV	9999999999	0,00	100,00	S/.	0,00	33,00	07	14/07/2009	Por la venta de servicios	14/07/2009	06	10003276614	CLT0001	ESPINOZA DIOSES DE COVEÑAS LILIANA YANET	01	FAC	003	0000422	14/07/2009		3,030	01010101	01010101	01010101	0001	GE	MODULO VENTA		No especificado	admin	24/07/2009	13:45:19	False	
--VTGE_RV07-00020	RV	40.1.0.01	0,00	19,00	S/.	0,00	6,27	07	14/07/2009	Por la venta de servicios	14/07/2009									14/07/2009		3,030	01010101	01010101	01010101	0001	GE	MODULO VENTA		No especificado	admin	24/07/2009	13:45:19	False	
--VTGE_RV07-00020	RV	12.1.0.01	119,00	0,00	S/.	39,27	0,00	07	14/07/2009	Por la venta de servicios	14/07/2009	06	10003276614	CLT0001	ESPINOZA DIOSES DE COVEÑAS LILIANA YANET	01	FAC	003	0000422	14/07/2009		3,030	01010101	01010101	01010101	0001	GE	MODULO VENTA		No especificado	admin	24/07/2009	13:45:19	False	


	--declare @NroCta	nvarchar(12), @CtaAsoc nvarchar(12), @NroSre nvarchar(4), @Glosa varchar(200), @MtoD numeric(13,2)

	set @NroCta=''
	set @NroCta = (select case @Cd_MdRg when '01' then DC_MN else DC_ME end from PlanCtasDef where RucE=@RucE and Ejer=@Ejer)
	if @NroCta='' or @NroCta is null
	begin
		set @msj = 'Venta no pudo ser registrada en linea por no tener una cuenta definida en Documentos por Cobrar'
		Print '/n/rNOTA : /n/rRegistre una cuenta valida en el menu Definir Cuentas  --> Documentos por cobrar. Luego elimine venta y vuelva a registrar'
		return
	end
	print 'Cta. Def. en Doc. X Cobrar :' + @NroCta


	set @CtaAsoc=''
	set @CtaAsoc = (select c.Cta from Auxiliar a inner join Cliente c on a.RucE=c.RucE and a.Cd_Aux = c.Cd_Aux where a.RucE=@RucE and a.Cd_Aux = @Cd_Aux)
	--set @CtaAsoc = (select c.Cta from Auxiliar a inner join Cliente c on a.RucE=c.RucE and a.Cd_Aux = c.Cd_Aux where a.RucE='11111111111' and a.Cd_Aux = 'CLT0047')
	print 'Cta Asociada: ' + @CtaAsoc


	set @NroSre = ( select NroSerie from Serie where RucE=@RucE and Cd_Sr=@Cd_Sr )
	print 'NroSerie: ' + @NroSre

	set @Glosa = 'Por la venta de servicios'
	print 'Glosa: ' + @Glosa




	--select top 50 * from venta
	--select * from venta where INF>0 or EXO>0



	declare @Tot numeric(13,2), @IGV numeric(13,2), @EXO numeric(13,2), @INF numeric(13,2)
	set @Tot = 0.00
	select @Tot=Total, @IGV=IGV, @EXO=EXO, @INF=INF from Venta where RucE=@RucE and Cd_Vta = @Cd_Vta

	if @Cd_TD='07'
	begin	
		set @MtoD = 0.00
		set @MtoH = @Tot
	end
	else
	begin	
		set @MtoD = @Tot
		set @MtoH = 0.00
	end

	
	print 'Debe: ' + str(@MtoD)
	print 'Haber: ' + str(@MtoH)


	--TENER EN CUENTA:
	--"S  - B.I. Operacion Gravada",
        --"V  - Valor de Exportación",
        --"E  - Exonerado",
        --"I   - Inafecto",
        --"X  - Operacion SIN REGISTRO en libro RC/RV"

	
	if @IGV>0
	   set @IC_TipAfec = 'S' --> debe mandar segun igv > 0
	else if @INF>0
		set @IC_TipAfec = 'I'
	     else if @EXO>0
			set @IC_TipAfec = 'E'
		  else set @IC_TipAfec = null

	

	set @Cd_CC = '01010101'
	set @Cd_SC = '01010101'
	set @Cd_SS = '01010101'

	



	print 'Cod. Venta: ' + @Cd_Vta
	print 'Llamando a creacion de voucher'
	exec pvo.Ctb_VoucherCrea7 --Modificacion: 7C
	@RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, @CtaAsoc, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc,
	@FecED, @FecVD,	@Glosa,	@MtoOr,	@MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS, @Cd_Area,
	@Cd_MR,	@NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, @SaldoMN output, @SaldoME output,
	@TipMov, --> M: Manual, A: Automatico
	------------------------------
	@IC_TipAfec, @TipOper, @Grdo, @RegOrg,
	------------------------------
	@IC_Crea, @IB_PgTot, @IB_EsProv, @msj output
		--with encryption
	--as



/*
	exec pvo.Ctb_VoucherCrea3
	@RucE, @Eje, @Prdo, @RegCtb, 'RV', @FecMov, @FecCbr, @NroCta, @CtaAsoc, @Cd_Cte,
	@Cd_TD,	@NroSre, @NroDoc, @FecED, @FecVD,
	@Glosa,
	0.00,	--> @MtoOr  numeric(13,2),
	@MtoD,
	0.00,   --> @MtoH  numeric(13,2),
	'01',  --> @Cd_MdOr  nvarchar(2),
	@Cd_Mda, --> @Cd_MdRg 	nvarchar(2),
	@CamMda,
	@Cd_CC,
	@Cd_SC,
	@Cd_SS,
	@Cd_Area,
	@Cd_MR,
	null, --> @NroChke varchar(30),
	'01', -->	@Cd_TG	nvarchar(2),
	'a', --> @IC_CtrMd varchar(1),
	--FecReg 	datetime,
	--FecMdf 	datetime,
	@UsuCrea,
	--UsuModf 	nvarchar(10),
	--@IB_Anulado 	bit
	null, --> @SaldoMN	decimal(13,2) output,
	null, --> @SaldoME	decimal(13,2) output,
	'A', --> @TipMov varchar(1), --> M: Manual, A: Automatico
	------------------------------
	null, --> @IC_TipAfec 	varchar(1),
	null, --> @TipOper varchar(4),
	null, --> @Grdo	varchar(100),
	null, --> @RegOrg  nvarchar(15),  --> Para saber que provicion estamos cancelando
	------------------------------
	'I',  --> @IC_Crea  varchar(1), --> I:Inicio, T:Transicion, F:Fin  <-- Indicador del estado de creacion

	@msj output
*/

set @Ind_OK = 'OK'

end

print @msj

-- PRUEBAS ---------------
/*
exec pvo.Vta_VentaCrea_EnLinea '111111111111','20/03/2009',null,'01','0001111','S001',null,null,'CLT0047'
,null,'010101','01','obs','01','3.147','admin',0,'VT00000126','VTLM_RV03-00007','2009','03','01','01010101','01010101','01010101',null

select * from voucher where RegCtb='VTLM_RV03-00007'
delete voucher where RegCtb='VTLM_RV03-00007'
*/
------------------------

/*
exec pvo.Vta_MayorizaVentaUn '11111111111','2009','VTGE_RV07-00021',null,null

select * from venta where rucE='11111111111' and regctb='VTGE_RV07-00021'
select * from voucher where rucE='11111111111' and regctb='VTGE_RV07-00021'
delete voucher where rucE='11111111111' and regctb='VTGE_RV07-00021'

11111111111	13821	2009	07	VTGE_RV07-00021	RV	2009-07-30 00:00:00	2009-07-30 00:00:00	9999999999	CLT0002	01	003	0000424	2009-07-30 00:00:00	NULL	Por la venta de servicios	.00	.00	1000.00	.00	333.56	01	01	2.998	01010101	01010101	01010101	0001	01	01	a	NULL	NULL	NULL	NULL	NULL	NULL	NULL	2009-07-30 12:25:22.540	NULL	admin	NULL	0
11111111111	13822	2009	07	VTGE_RV07-00021	RV	2009-07-30 00:00:00	2009-07-30 00:00:00	40.1.0.01	NULL	NULL	NULL	NULL	2009-07-30 00:00:00	NULL	Por la venta de servicios	.00	.00	190.00	.00	63.38	01	01	2.998	01010101	01010101	01010101	0001	01	01	a	NULL	NULL	NULL	NULL	NULL	NULL	NULL	2009-07-30 12:25:22.760	NULL	admin	NULL	0
11111111111	13823	2009	07	VTGE_RV07-00021	RV	2009-07-30 00:00:00	2009-07-30 00:00:00	12.1.0.01	CLT0002	01	003	0000424	2009-07-30 00:00:00	NULL	Por la venta de servicios	.00	1190.00	.00	396.93	.00	01	01	2.998	01010101	01010101	01010101	0001	01	01	a	NULL	NULL	NULL	NULL	NULL	NULL	NULL	2009-07-30 12:25:22.777	NULL	admin	NULL	0

11111111111	13821	2009	07	VTGE_RV07-00021	RV	2009-07-30 12:30:00		NULL		9999999999	CLT0002	01	003	0000424		NULL		NULL	Por la venta de servicios	1190.00	.00	1000.00	.00	333.56	01	01	2.998	01010101	01010101	01010101	0001	01	01	a	S	NULL	NULL	NULL	NULL	NULL	1	2009-07-30 12:49:41.050	NULL	admin	NULL	0
11111111111	13822	2009	07	VTGE_RV07-00021	RV	2009-07-30 12:30:00		NULL		40.1.0.01	NULL	NULL	NULL	NULL		NULL		NULL	Por la venta de servicios	1190.00	.00	190.00	.00	63.38	01	01	2.998	01010101	01010101	01010101	0001	01	01	a	NULL	NULL	NULL	NULL	NULL	NULL	NULL	2009-07-30 12:49:41.067	NULL	admin	NULL	0
11111111111	13823	2009	07	VTGE_RV07-00021	RV	2009-07-30 12:30:00		NULL		12.1.0.01	CLT0002	01	003	0000424		NULL		NULL	Por la venta de servicios	1190.00	1190.00	.00	396.93	.00	01	01	2.998	01010101	01010101	01010101	0001	01	01	a	NULL	NULL	NULL	NULL	NULL	NULL	1	2009-07-30 12:49:41.080	NULL	admin	NULL	0

*/

------------------------


--PV: VIE 24/03/09  --> Creado
GO
