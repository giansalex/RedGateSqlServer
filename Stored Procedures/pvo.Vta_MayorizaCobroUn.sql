SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Vta_MayorizaCobroUn]
@RucE nvarchar(11),
@Ejer nvarchar(4), 
@ItmCo int,--@Cd_Vta nvarchar(10), --@RegCtb nvarchar(15),
@RegCtbGen nvarchar(15) output,
@msj varchar(100) output
as


SET CONCAT_NULL_YIELDS_NULL OFF -- PARA CONCATENAR NULLS

declare @Cd_Vta nvarchar(10)

if not exists (select * from Cobro where RucE=@RucE and ItmCo=@ItmCo)
begin	set @msj = 'No existe cobro ' + @ItmCo
	print @msj
	return
end
else
begin
	set @Cd_Vta=''
	set @Cd_Vta = (select Cd_Vta from Cobro where RucE=@RucE and ItmCo=@ItmCo)
end



if not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
begin	set @msj = 'No existe provision venta '+ @Cd_Vta
	print @msj
	return
end


--if exists (select * from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
--	set @msj = 'IMPOSIBLE MAYORIZAR. Ya exite voucher con el mismo Reg. Contable, elimine venta y vuelva a registrar'
	
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
@NroCta nvarchar(12),
--@CtaAsoc nvarchar(12),  --> cta definida en Clientes/Proveedores
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
@Cd_MdRg_Prov 	nvarchar(2), --> la usamos para saber la MdaReg de la prov --> saber la cuenta 12 con que se debe registrar el cobro
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

	declare @RegCtb nvarchar(15), @RegCtbOrg nvarchar(15), /*@Cd_Vta nvarchar(10),*/ @Cd_Sr nvarchar(4) 
	declare @TC_Pvs numeric(6,3), @Itm_BC nvarchar(10), @NroCtaBco nvarchar(12)


	select  
	@RegCtbOrg=RegCtb, @FecMov=FecMov, @FecCbr=FecCbr,  @Cd_Aux=Cd_Cte, @Cd_TD=Cd_TD, @Cd_Sr=Cd_Sr, @NroDoc=NroDoc,
	@FecED=FecED, @FecVD=FecVD, @Cd_Area=Cd_Area, 
	@UsuCrea=UsuCrea, @TC_Pvs=CamMda,
	@Cd_MdRg_Prov = Cd_Mda  	
	from venta where RucE=@RucE and Eje=@Ejer and Cd_Vta=@Cd_Vta--and RegCtb=@RegCtb




	print 'Tipo cambio Provision'
	print @TC_Pvs
 	print 'Aux: ' + @Cd_Aux



	select @Itm_BC = Itm_BC, @MtoOr=Monto,  @Cd_MdRg=Cd_Mda, @CamMda=CamMda, @FecMov=FecPag, @Prdo = right('00'+ltrim(str(month(FecPag))), 2) from Cobro where RucE=@RucE and ItmCo=@ItmCo

	print 'Tipo cambio Cobro'
	print @CamMda
	print @Itm_BC
	
	if @FecED is null
	   set @FecED = @FecMov

	--Completamos los campos obios
	set @Cd_Fte ='CB'
	set @Cd_MdOr = '01'
	set @Glosa = 'Por el cobro del documento: ' + @NroDoc
	set @Cd_MR='01'
	set @TipMov='M' --> M: Manual, A: Automatico
	set @IC_CtrMd = 'a' -- ambas	
	set @Cd_TG = '01' -- No especificado
	set @NroChke = null -- solo para CB
	set @TipOper = null -- solo para CB
	set @RegOrg = @RegCtbOrg -- solo para CB	

	set @IC_Crea = 'I'
	set @IB_PgTot = 1
	set @IB_EsProv = null
	set @Grdo = null -- solo para CB


	--select * from venta where Cd_Vta = 'VT00000104'
	set @RegCtb = dbo.RegCtb_Ctb(@RucE, @Cd_MR, @Cd_Fte, @Cd_Area , @Ejer, @Prdo)



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
	--set @NroCta = (select case @Cd_MdRg when '01' then DC_MN else DC_ME end from PlanCtasDef where RucE=@RucE) --> ya no
	set @NroCta = (select case @Cd_MdRg_Prov when '01' then DC_MN else DC_ME end from PlanCtasDef where RucE=@RucE  and Ejer=@Ejer) --> ahora nos guiamos de la MdReg de la provision
	if @NroCta='' or @NroCta is null
	begin
		set @msj = 'Cobro no pudo ser registrada en linea por no tener una cuenta definida en Documentos por Cobrar'
		Print '/n/rNOTA : /n/rRegistre una cuenta valida en el menu Definir Cuentas  --> Documentos por cobrar. Luego elimine venta y vuelva a registrar'
		return
	end
	print 'Cta. Def. en Doc. X Cobrar :' + @NroCta


	/* NO SELECCIONAMOS CTA ASOCIADA
	set @CtaAsoc=''
	set @CtaAsoc = (select c.Cta from Auxiliar a inner join Cliente c on a.RucE=c.RucE and a.Cd_Aux = c.Cd_Aux where a.RucE=@RucE and a.Cd_Aux = @Cd_Aux)
	--set @CtaAsoc = (select c.Cta from Auxiliar a inner join Cliente c on a.RucE=c.RucE and a.Cd_Aux = c.Cd_Aux where a.RucE='11111111111' and a.Cd_Aux = 'CLT0047')
	print 'Cta Asociada :' + @CtaAsoc
	*/

	set @NroCtaBco=''
	set @NroCtaBco = (select NroCta from Banco where RucE=@RucE and Itm_BC=@Itm_BC)
	if @NroCtaBco is null or @NroCtaBco=''	
	begin
		set @msj = 'No existe este banco. Cobro no pudo ser registrado'
		print @msj
		--delete voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
		--print '----------> Se elimino registro ' + @RegCtb
		PRINT 'SE PROCESO COBRANZA: ' + @RegCtb
		return
	end
		

	print @NroCtaBco


	set @NroSre = ( select NroSerie from Serie where RucE=@RucE and Cd_Sr=@Cd_Sr )
	print @NroSre

	--set @Glosa = 'Por el cobro de servicios'
	print @Glosa

	
	set @IC_TipAfec = null

	--debe jalarlo de la Venta
	set @Cd_CC = '01010101'
	set @Cd_SC = '01010101'
	set @Cd_SS = '01010101'

	



	print 'Cod. Venta: ' + @Cd_Vta
	print 'Llamando a creacion de voucher'
	--Iniciamos voucher
	set @IC_Crea = 'I'
        set @MtoD = 0.00
        set @MtoH = @MtoOr

	exec pvo.Ctb_VoucherCrea7 --Modificacion: 7C
	@RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, null, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc,
	@FecED, @FecVD,	@Glosa,	@MtoOr,	@MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, @TC_Pvs, @Cd_CC, @Cd_SC, @Cd_SS, @Cd_Area,
	@Cd_MR,	@NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, @SaldoMN output, @SaldoME output,
	@TipMov, --> M: Manual, A: Automatico
	------------------------------
	@IC_TipAfec, @TipOper, @Grdo, @RegOrg,
	------------------------------
	@IC_Crea, @IB_PgTot, @IB_EsProv, @msj output
		--with encryption
	--as


	--//Terminammos voucher-------------
	--set @NroCta = @NroCtaBco
	set @IC_Crea = 'F'
        set @MtoD = @MtoOr
        set @MtoH = 0.00

	exec pvo.Ctb_VoucherCrea7 --Modificacion: 7C
	@RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCtaBco, null, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc,
	@FecED, @FecVD,	@Glosa,	@MtoOr,	@MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS, @Cd_Area,
	@Cd_MR,	@NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, @SaldoMN output, @SaldoME output,
	@TipMov, --> M: Manual, A: Automatico
	------------------------------
	@IC_TipAfec, @TipOper, @Grdo, @RegOrg,
	------------------------------
	@IC_Crea, @IB_PgTot, @IB_EsProv, @msj output
		--with encryption
	--as


	PRINT 'SE PROCESO COBRANZA: ' + @RegCtb
	set @RegCtbGen = @RegCtb --> Guardamos el Registro Contagle generado

end

print @msj

-- PRUEBAS ---------------
/*
select * from venta where rucE='11111111111' and Cd_Vta='VT00000104'
select * from voucher where rucE='11111111111' and regctb='VTGN_CB02-00001'
delete voucher where rucE='11111111111' and regctb='VTGN_CB02-00001'

exec pvo.Vta_MayorizaCobroUn '11111111111','2009','VT00000104',null  <-- ahora se cobra por Item_Cobro
exec pvo.Vta_MayorizaCobroUn '11111111111','2009',1,null,null
*/

------------------------
--PV: LUN 03/08/09  --> Creado
--PV: MAR 21/10/09  --> Mdf: para que coja la cta x cbr segun la MdaReg de la provision
GO
