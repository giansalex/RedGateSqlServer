SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherMdf_Mto2]
@RucE		nvarchar(11),
--@Cd_Vou	int,
@Ejer		nvarchar(4),
@Prdo		nvarchar(2),
@RegCtb	nvarchar(15),
@MtoD		numeric(13,2),
@MtoH		numeric(13,2),
@NroCta	nvarchar(10),
@Cd_MdRg 	nvarchar(2),
@CamMda 	numeric(6,3),
@IC_CtrMd	varchar(1),
----------------------------
@Cd_Vou_Base 	int,
---------------------------
@msj 		varchar(100) output

with encryption
as

/*
print 'VARIABLES RECIBIDAS'
print @RucE
print @Ejer
print @Prdo
print @RegCtb
print @MtoD
print @MtoH
print @NroCta
print @Cd_MdRg
print @CamMda 
print @IC_CtrMd
print 'FIN VARIABLES RECIBIDAS'
*/



--declare @Cd_Vou int
--set @Cd_Vou = dbo.Cod_Vou(@RucE)

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
end



if @MtoD>0
--begin update Voucher set MtoD=MtoD+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD end
	update Voucher set MtoD=MtoD+@MtoD, MtoD_ME=MtoD_ME+@MtoD_ME  where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta and Cd_Vou>=@Cd_Vou_Base
else
	update Voucher set MtoH=MtoH+@MtoH, MtoH_ME=MtoH_ME+@MtoH_ME  where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta and Cd_Vou>=@Cd_Vou_Base

	if @@rowcount<=0
	   set @msj = 'No se pudo actualizar monto'


---------------
--PV: Mdf: Cd_Vou>=@Cd_Vou_Base --> esto para que no se tenga poblemas con actualizar Ctas. Dest. de anteriores registros

GO
