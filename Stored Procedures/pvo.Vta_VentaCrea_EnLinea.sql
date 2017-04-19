SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Vta_VentaCrea_EnLinea]
@RucE nvarchar(11),
@Ejer varchar(4),
@FecMov smalldatetime,
@FecCbr smalldatetime,
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@Cd_Sr nvarchar(4),
@FecED smalldatetime,
@FecVD smalldatetime,
@Cd_Cte nvarchar(7),
@Cd_Vdr nvarchar(7),
@Cd_Area nvarchar(6),
@Cd_MR nvarchar(2),
@Obs varchar(1000),
--@BIM numeric(13,2),
--@IGV numeric(13,2),
--@Total numeric(13,2),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
--@FecReg datetime,
--@FecMdf datetime,
@UsuCrea nvarchar(10),
--@UsuModf nvarchar(10),
@IB_Anulado bit,
@Cd_Vta nvarchar(10), 
@RegCtb nvarchar(15),
@Eje nvarchar(4), 
@Prdo nvarchar(2), 
@Cd_FPC nvarchar(2), 
--@INF numeric(13,2),
--@EXO numeric(13,2),
@Cd_CC nvarchar(8), 
@Cd_SC nvarchar(8), 
@Cd_SS nvarchar(8),
@msj varchar(100) output
as
if exists (select * from Voucher where RucE=@RucE and RegCtb=@RegCtb)
	set @msj = 'Ya exite voucher con el mismo Reg. Contable, elimine venta y vuelva a registrar'
else
begin
/*	if (select opc.EnLinea from Config where RucE=@RucE) = 0
	    return
	else
*/



	declare @NroCta	nvarchar(12), @CtaAsoc nvarchar(12), @NroSre nvarchar(4), @Glosa varchar(200), @MtoD numeric(13,2), @MtoH numeric(13,2)

	set @NroCta=''
	set @NroCta = (select case @Cd_Mda when '01' then DC_MN else DC_ME end from PlanCtasDef where RucE=@RucE and Ejer=@Ejer)
	
	if @NroCta='' or @NroCta is null
	begin
		set @msj = 'Venta no pudo ser registrada en linea por no tener una cuenta definida en Documentos por Cobrar'
		Print '/n/rNOTA : /n/rRegistre una cuenta valida en el menu Definir Cuentas  --> Documentos por cobrar. Luego elimine venta y vuelva a registrar'
		return
	end
 
	
	print 'Cta. Def. en Doc. X Cobrar :' + @NroCta

	set @CtaAsoc=''
	set @CtaAsoc = (select c.Cta from Auxiliar a inner join Cliente c on a.RucE=c.RucE and a.Cd_Aux = c.Cd_Aux where a.RucE=@RucE and a.Cd_Aux = @Cd_Cte)
	--set @CtaAsoc = (select c.Cta from Auxiliar a inner join Cliente c on a.RucE=c.RucE and a.Cd_Aux = c.Cd_Aux where a.RucE='11111111111' and a.Cd_Aux = 'CLT0047')
	print 'Cta Asociada :' + @CtaAsoc

	set @NroSre = ( select NroSerie from Serie where RucE=@RucE and Cd_Sr=@Cd_Sr )
	print @NroSre

	set @Glosa = 'Por la venta de servicios'
	print @Glosa


	--set @Cd_CC = '01010101'
	--set @Cd_SC = '01010101'
	--set @Cd_SS = '01010101'


	--Analizamos parte afecta y extorno
	declare @Tot numeric(13,2), @IGV numeric(13,2), @EXO numeric(13,2), @INF numeric(13,2), @IC_TipAfec varchar(1)
	set @Tot = 0.00
	select @Tot=Total, @IGV=IGV, @EXO=EXO, @INF=INF from Venta where RucE=@RucE and Cd_Vta = @Cd_Vta

	if @Cd_TD='07'
	begin	set @MtoD = 0.00
		set @MtoH = @Tot
	end
	else
	begin	set @MtoD = @Tot
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


	




	print 'Llamando a creacion de voucher'

	exec pvo.Ctb_VoucherCrea7 --Modificacion: 7C
	@RucE, @Eje, @Prdo, @RegCtb, 'RV', @FecMov, @FecCbr, @NroCta, @CtaAsoc, @Cd_Cte,
	@Cd_TD,	@NroSre, @NroDoc, @FecED, @FecVD,
	@Glosa,
	0.00,	--> @MtoOr  numeric(13,2),
	@MtoD,
	@MtoH,   --> @MtoH  numeric(13,2),
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
	@IC_TipAfec, --> @IC_TipAfec 	varchar(1),
	null, --> @TipOper varchar(4),
	null, --> @Grdo	varchar(100),
	null, --> @RegOrg  nvarchar(15),  --> Para saber que provicion estamos cancelando
	------------------------------
	'I',  --> @IC_Crea  varchar(1), --> I:Inicio, T:Transicion, F:Fin  <-- Indicador del estado de creacion
	1,    --> @IB_PgTot, 
	1,    --> @IB_EsProv, 

	@msj output






end

-- PRUEBAS ---------------
/*
exec pvo.Vta_VentaCrea_EnLinea '111111111111','20/03/2009',null,'01','0001111','S001',null,null,'CLT0047'
,null,'010101','01','obs','01','3.147','admin',0,'VT00000126','VTLM_RV03-00007','2009','03','01','01010101','01010101','01010101',null

select * from voucher where RegCtb='VTLM_RV03-00007'
delete voucher where RegCtb='VTLM_RV03-00007'
*/
------------------------


--PV: MIE 18/03/09  --> Creado
--PV: VIE 20/03/09  --> agregue 3 campos cc,sc,ss
--PV: JUE 06/07/09  --> Mdf: afecto y extorno desde Mod. Vtas.
GO
