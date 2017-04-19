SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherInsert3]
@RucE		nvarchar(11),
--@Cd_Vou	int,
@Ejer		nvarchar(4),
@Prdo		nvarchar(2),
@RegCtb	nvarchar(15),
@Cd_Fte	varchar(2),
@FecMov	smalldatetime,
@FecCbr	smalldatetime,
@NroCta	nvarchar(10),
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
@UsuCrea 	nvarchar(10),
------------------------------
@IC_TipAfec 	varchar(1),
@TipOper 	varchar(4),
@Grdo	 	varchar(100),
------------------------------
@msj 		varchar(100) output
as

set @msj = 'Para insertar voucher, debe actualizar el sistema'
/*
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
    end
--  else --> Es exclusivamente Soles (Mtos_ME=0)

end
else 
begin
    set @MtoD_ME = @MtoD
    set @MtoH_ME = @MtoH

    if @IC_CtrMd='s' or @IC_CtrMd='a'
    begin 
	set @MtoD = @MtoD*@CamMda
	set @MtoH = @MtoH*@CamMda
    end
    else --> Es exclisivamente Dolares
    begin
	set @MtoD = 0.00
	set @MtoH = 0.00
    end

end

if(select IB_Aux from PlanCtas where RucE=@RucE and NroCta=@NroCta)=0
begin
set @Cd_Aux = null
set @Cd_TD = null
set @NroSre = null
set @NroDoc = null
end


insert into Voucher ( RucE, Cd_Vou, Ejer, Prdo, RegCtb, Cd_Fte, FecMov, FecCbr, NroCta, Cd_Aux, Cd_TD, NroSre,
		      NroDoc, FecED, FecVD, Glosa, MtoOr, MtoD, MtoH, MtoD_ME, MtoH_ME, Cd_MdOr, Cd_MdRg, CamMda, Cd_CC,
		      Cd_SC, Cd_SS,  Cd_Area, Cd_MR, Cd_TG, IC_CtrMd, IC_TipAfec, TipOper, NroChke, Grdo, FecReg, UsuCrea, IB_Anulado )

		values( @RucE, @Cd_Vou, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, @Cd_Aux, @Cd_TD, @NroSre,
			@NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @MtoD_ME, @MtoH_ME, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
			@Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @Cd_TG, @IC_CtrMd, @IC_TipAfec, @TipOper, @NroChke, @Grdo, getdate(), @UsuCrea, 0 )

	if @@rowcount<=0
	   set @msj = 'Voucher no pudo ser registrado'
	else
	   insert into VoucherRM values (@RucE, dbo.Nro_RegVouRM(@RucE), @Cd_Vou, @Cd_TD, @NroDoc, @MtoD, @MtoH, @Cd_MdRg, @Cd_Area, @Cd_MR, @UsuCrea, getdate(), '01')

*/


--PV: Mdf Lun 18/05/2009  ---> Es exclusivamente Dolares
GO
