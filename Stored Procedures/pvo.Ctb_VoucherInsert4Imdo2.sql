SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherInsert4Imdo2] --(se esta usando para insertar amarres)
@RucE		nvarchar(11),
--@Cd_Vou	int,
@Ejer		nvarchar(4),
@Prdo		nvarchar(2),
@RegCtb	nvarchar(15),
@Cd_Fte	varchar(2),
@FecMov	smalldatetime,
@FecCbr	smalldatetime,
@NroCta	nvarchar(10),
--@Cd_Aux	nvarchar(7),
----------------------
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
@UsuCrea 	nvarchar(10),
------------------------------
@IC_TipAfec 	varchar(1),
@TipOper 	varchar(4),
@Grdo	 	varchar(100),
@IB_EsProv	bit,
@IB_Anulado bit,
@Cd_TDI nvarchar(2),--tipo Documento Autorizacion
@RucC varchar(15),--NroDoc de Cliente
@RucP varchar(15),--NroDoc de Proveedor
------------------------------
@msj 		varchar(100) output
as


/*
print 'Imprimimos parametros: (Ctb_VoucherInsert4)'
print @RegCtb
print @FecMov
print @FecCbr
print @NroCta
*/

declare @Cd_Clt	char(10)
declare @Cd_Prv	char(7)
set @Cd_Clt=null
set @Cd_Prv=null
if(Isnull(@RucC,'')<>'')
	set @Cd_Clt=(select Cd_Clt from Cliente2 where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@RucC)
else if(Isnull(@RucP,'')<>'')
	set @Cd_Prv=(select Cd_Prv from Proveedor2 where RucE=@RucE and Cd_TDI=@Cd_TDI and NDoc=@RucP)


declare @Cd_Vou int
set @Cd_Vou = dbo.Cod_Vou(@RucE)

declare @MtoD_ME numeric(13,2), @MtoH_ME numeric(13,2)

set @MtoD_ME = 0
set @MtoH_ME = 0


if @Cd_MdRg='01'
begin

    if @IC_CtrMd='$' or @IC_CtrMd='a'
    begin
	set @MtoD_ME = @MtoD/@CamMda
	set @MtoH_ME = @MtoH/@CamMda

	if @IC_CtrMd='$' -- si es exclusivamente en dolares -->> (se registra al cambio de moneda solamente en dolares)
	begin
		set @MtoD = 0
		set @MtoH = 0
	end

    end
  /*else --if @IC_CtrMd='s' -- si es exclusivamente en soles -->> (se mantiene el monto de entrada (que es la variable para soles) y no es necesario hacer 0.00 los Montos_ME )
    begin
	set @MtoD_ME = 0
	set @MtoH_ME = 0
    end
  */

end
else --if @Cd_MdRg='02'
begin

    set @MtoD_ME = @MtoD
    set @MtoH_ME = @MtoH

    if @IC_CtrMd='s' or @IC_CtrMd='a'
    begin 
	set @MtoD = @MtoD*@CamMda
	set @MtoH = @MtoH*@CamMda
 
	if @IC_CtrMd='s' -- si es exclusivamente en soles -->> (se registra al cambio de moneda solamente en soles)
	begin
		set @MtoD_ME = 0
		set @MtoH_ME = 0
	end
   end
   else --if @IC_CtrMd='$' -- si es exclusivamente en Dolares -->> (Nos aseguramos que el monto de entrada (variable para soles) quede en 0.00 )
   begin
	set @MtoD = 0.00
	set @MtoH = 0.00
   end


end

if(select IB_Aux from PlanCtas where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer)=0 
begin
set @Cd_Clt = null
set @Cd_Prv = null
--set @Cd_Aux = null
set @Cd_TD = null
set @NroSre = null
set @NroDoc = null
set @IB_EsProv = null
end

print '          --------------'
print '          MONTOS: (a insertar) -->Insert4' 
print '          @MtoD: ' + convert(varchar,@MtoD)
print '          @MtoH: ' + convert(varchar,@MtoH)
print '          @MtoD_ME: ' + convert(varchar,@MtoD_ME)
print '          @MtoH_ME: ' + convert(varchar,@MtoH_ME)
print '          --------------'


insert into Voucher ( RucE, Cd_Vou, Ejer, Prdo, RegCtb, Cd_Fte, FecMov, FecCbr, NroCta, /*Cd_Aux*/ Cd_Clt, Cd_Prv, Cd_TD, NroSre,
		      NroDoc, FecED, FecVD, Glosa, MtoOr, MtoD, MtoH, MtoD_ME, MtoH_ME, Cd_MdOr, Cd_MdRg, CamMda, Cd_CC,
		      Cd_SC, Cd_SS,  Cd_Area, Cd_MR, Cd_TG, IC_CtrMd, IC_TipAfec, TipOper, NroChke, Grdo, IB_EsProv, FecReg, UsuCrea, IB_Anulado)

		values( @RucE, @Cd_Vou, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, /*Cd_Aux*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre,
			@NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @MtoD_ME, @MtoH_ME, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
			@Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @Cd_TG, @IC_CtrMd, @IC_TipAfec, @TipOper, @NroChke, @Grdo, @IB_EsProv, getdate(), @UsuCrea, @IB_Anulado)

	if @@rowcount<=0
	   set @msj = 'Voucher no pudo ser registrado'
	else
	begin
	   insert into VoucherRM (RucE, NroReg, RegCtb, Ejer, Cd_Vou, NroCta, Cd_TD, NroDoc, Debe, Haber, Cd_Mda, Cd_Area, Cd_MR, Usu, FecMov, Cd_Est)
	   			 values (@RucE, dbo.Nro_RegVouRM(@RucE), @RegCtb, @Ejer, @Cd_Vou, @NroCta, @Cd_TD, @NroDoc, @MtoD, @MtoH, @Cd_MdRg, @Cd_Area, @Cd_MR, @UsuCrea, getdate(), '01')
	end
	 --insert into VoucherRM values (@RucE, dbo.Nro_RegVouRM(@RucE), @Cd_Vou, @Cd_TD, @NroDoc, @MtoD, @MtoH, @Cd_MdRg, @Cd_Area, @Cd_MR, @UsuCrea, getdate(), '01')


--PV: Mdf Lun 18/05/2009  ---> Es exclusivamente Dolares
--PV: Mdf Vie 19/03/2010  ---> Campos VoucherRM
--PV: Mie 24/03/2010 - Mdf: En los IF, No se respetaba cuando era exclusivamente s ó $
--PV: Mar 26/10/2010 - Mdf: se agregaron campos @Cd_Clt, @Cd_Prv

----- NO TOCAR ESTE SP ----- PV



GO
