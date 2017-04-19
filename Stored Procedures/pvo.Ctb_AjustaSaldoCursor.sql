SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [pvo].[Ctb_AjustaSaldoCursor]
@RucE	nvarchar(11),
@Ejer	nvarchar(4),
@FecAjt	smalldatetime,
@RegCtb	nvarchar(15),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@TC_AjC numeric(6,3),
@TC_AjV numeric(6,3),
@Cd_Area nvarchar(6),
@Cd_MR	 nvarchar(2),
@Cd_CC	nvarchar(8),
@Cd_SC	nvarchar(8),
@Cd_SS	nvarchar(8),
@UsuCrea nvarchar(10),
@msj 	varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL off

if exists (select RegCtb from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and IB_Anulado = 0)
begin 
	set @msj='Ya existe un voucher con este numero de Registro Contable'
    return
end

if(isnull(@NroCta1 + @NroCta2,'') = '')
	select @NroCta1 = min(NroCta), @NroCta2 = max(NroCta) from PlanCtas where RucE = @RucE and Ejer = @Ejer

declare @IC_ACV varchar(1),
@TC_Aj numeric(6,3),
@NroCta nvarchar(10),
@Cd_TD nvarchar(2), 
@NroSre nvarchar(4), 
@NroDoc nvarchar(15),
@Cd_Clt char(10),
@Cd_Prv char(7),
@IB_JalaCC bit

if(@Cd_CC is null and @Cd_SC is null and @Cd_SS is null)
	set @IB_JalaCC=1
	
declare @n int
select @n= count(v.RucE) from voucher v inner join planctas p on v.ruce = p.ruce and v.NroCta = p.NroCta and v.Ejer=p.Ejer 
where v.ruce=@RucE and v.Ejer=@Ejer and FecMov<=@FecAjt and IC_ASM = 's' and len(p.NroCta)>8 and p.NroCta>=@NroCta1 and p.NroCta<=@NroCta2 and IB_Anulado = 0 
group by v.RucE, v.Ejer, v.NroCta, Cd_Clt, Cd_Prv, isnull(Cd_TD,''), isnull(NroSre,''), isnull(NroDoc,'')
if @n = 0
begin
	set @msj ='No se proceso ninguna cuenta'
	return
end 

--if (@IB_JalaCC=1)
	declare Cur_AjS cursor for select v.NroCta, IC_ACV, Cd_Clt, Cd_Prv,  isnull(Cd_TD,'') as Cd_TD, isnull(NroSre,'') as NroSre, isnull(NroDoc,'') as NroDoc, @Cd_CC as Cd_CC , @Cd_SC as Cd_SC, @Cd_SS as Cd_SS from voucher v inner join planctas p on v.ruce = p.ruce and v.NroCta = p.NroCta and v.Ejer=p.Ejer where v.ruce=@RucE and v.Ejer=@Ejer and FecMov<=@FecAjt and IC_ASM = 's' and len(p.NroCta)>8 and p.NroCta>=@NroCta1 and p.NroCta<=@NroCta2 and IB_Anulado = 0 group by v.RucE, v.Ejer, v.NroCta, Cd_Clt, Cd_Prv, isnull(Cd_TD,''), isnull(NroSre,''), isnull(NroDoc,''), IC_ACV
--else
	--declare Cur_AjS cursor for select v.NroCta, IC_ACV, Cd_Clt, Cd_Prv,  isnull(Cd_TD,'') as Cd_TD, isnull(NroSre,'') as NroSre, isnull(NroDoc,'') as NroDoc, @Cd_CC as Cd_CC , @Cd_SC as Cd_SC, @Cd_SS as Cd_SS	from voucher v inner join planctas p on v.ruce = p.ruce and v.NroCta = p.NroCta and v.Ejer=p.Ejer where v.ruce=@RucE and v.Ejer=@Ejer and FecMov<=@FecAjt and IC_ASM = 's' and len(p.NroCta)>8 and p.NroCta>=@NroCta1 and p.NroCta<=@NroCta2 and IB_Anulado = 0 group by v.RucE, v.Ejer, v.NroCta, Cd_Clt, Cd_Prv, isnull(Cd_TD,''), isnull(NroSre,''), isnull(NroDoc,''), IC_ACV, Cd_CC, Cd_SC, Cd_SS

		open Cur_AjS
			fetch Cur_AjS into @NroCta, @IC_ACV, @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @Cd_CC, @Cd_SC, @Cd_SS
			while (@@fetch_status=0)
			begin
				if(@IC_ACV='c')
					set @TC_Aj = @TC_AjC
				else
					set @TC_Aj = @TC_AjV

				print @RucE +', '+ @Ejer +', '+ convert(varchar,@FecAjt,103) +', '+ @RegCtb +', '+ @NroCta  +', '+ @Cd_Clt +', '+ @Cd_Prv +', '+ @Cd_TD +', '+ @NroSre +', '+ @NroDoc +', '+ @UsuCrea +', '+ convert(varchar,@TC_Aj) +', '+ @Cd_Area +', '+ @Cd_MR +', '+ @msj 				
				exec pvo.Ctb_AjustaSaldoDocUn @RucE, @Ejer, @FecAjt, @RegCtb, @NroCta, @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @UsuCrea, @TC_Aj, @Cd_Area, @Cd_MR, @Cd_CC, @Cd_SC, @Cd_SS, @msj output
				fetch Cur_AjS into @NroCta, @IC_ACV, @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @Cd_CC, @Cd_SC, @Cd_SS
			end
		close Cur_AjS
	deallocate Cur_AjS

print 'XD' +isnull(@msj, '')

declare @Prdo	nvarchar(2) = right('0' + convert(varchar,(month(@FecAjt))),2),
@Cd_Fte varchar(2) = left(right(@RegCtb,10),2),
@FecMov smalldatetime = @FecAjt,
@Glosa varchar(200) = 'Ajuste de Saldo',
@MtoOr numeric(13,2) = 0.00,
@Cd_MdRg nvarchar(2) = (select isnull(Cd_Mda,'01') from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta= @NroCta),
@Cd_MdOr nvarchar(2) = (select isnull(Cd_Mda,'01') from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta= @NroCta),
@Cd_TG nvarchar(2) = '01',
@IC_CtrMd varchar(1),
@IC_TipAfec varchar(1),
@TipOper varchar(4),
@IB_EsProv bit

declare @SD numeric(13,2), 
@SH numeric(13,2), 
@SD_ME numeric(13,2), 
@SH_ME numeric(13,2),
@MtoD numeric(13,2), 
@MtoH numeric(13,2), 
@MtoD_ME numeric(13,2), 
@MtoH_ME numeric(13,2),
@NroCtaG nvarchar(12), 
@NroCtaP nvarchar(12),
@TipMov varchar(1) = 'M'

declare @Cd_Vou int

if @Cd_CC is null
begin
	set @Cd_CC = '01010101'
	set @Cd_SC = '01010101'
	set @Cd_SS = '01010101'
end

if (select count(RegCtb) from voucher where Ruce=@RucE and Ejer=@Ejer and RegCtb=@RegCtb) = 0
begin
	set @msj ='Se proceso ' + convert(varchar,@n)+ ' cuenta(s), pero no se registraron movimientos de ajuste.'
	return
end

select @SD=sum(MtoD), @SH=sum(MtoH), @SD_ME=sum(MtoD_ME), @SH_ME=sum(MtoH_ME) from voucher where Ruce=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
select @NroCtaP = DCPer, @NroCtaG = DCGan from PlanCtasDef where RucE=@RucE and Ejer=@Ejer

if(@SH_ME > 0)
begin
	set @MtoD_ME = @SH_ME
	set @NroCta = @NroCtaP
	set @IC_CtrMd = '$'
	set @Cd_MdRg='02'
	set @MtoD = 0.00 
	set @MtoH = 0.00
	set @MtoH_ME = 0.00

	exec pvo.Ctb_VoucherInsert6_conCtaDest1
		@RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, null, @NroCta, null, null, null, null,	null, null, null, @Glosa, @MtoOr, @MtoD_ME, @MtoH, @Cd_MdOr, @Cd_MdRg, 0.00, @Cd_CC,
		@Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, null, @Cd_TG, @IC_CtrMd, @UsuCrea, @IC_TipAfec, @TipOper, null, @IB_EsProv, null, null, null, null, @TipMov, @msj output
end

if(@SD_ME > 0)
begin
	set @MtoH_ME = @SD_ME
	set @NroCta = @NroCtaG 
	set @IC_CtrMd = '$'
	set @Cd_MdRg='02'
	set @MtoD = 0.00 
	set @MtoH = 0.00
	set @MtoD_ME = 0.00

	exec pvo.Ctb_VoucherInsert6_conCtaDest1
	   @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, null, @NroCta, null, null, null, null, null, null, null, @Glosa, @MtoOr, @MtoD, @MtoH_ME, @Cd_MdOr, @Cd_MdRg, 0.00, @Cd_CC,
	   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, null, @Cd_TG, @IC_CtrMd, @UsuCrea, @IC_TipAfec, @TipOper, null, @IB_EsProv, null, null, null, null, @TipMov, @msj output
end

if(@SH > 0)
begin
	set @MtoD = @SH
	set @NroCta = @NroCtaP
	set @IC_CtrMd = 's' 
	set @Cd_MdRg='01'
	set @MtoH = 0.00
	set @MtoD_ME = 0.00
	set @MtoH_ME = 0.00

	exec pvo.Ctb_VoucherInsert6_conCtaDest1
		@RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, null, @NroCta, null, null, null, null, null, null, null, @Glosa, @MtoOr, @MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, 0.00, @Cd_CC,
		@Cd_SC, @Cd_SS, @Cd_Area, @Cd_MR, null, @Cd_TG, @IC_CtrMd, @UsuCrea, @IC_TipAfec, @TipOper,  null, @IB_EsProv, null, null, null, null, @TipMov, @msj output
end

if(@SD > 0)
begin
	set @MtoH = @SD
	set @NroCta = @NroCtaG 
	set @IC_CtrMd = 's' 
	set @Cd_MdRg='01'
	set @MtoD = 0.00 
	set @MtoD_ME = 0.00
	set @MtoH_ME = 0.00

	exec pvo.Ctb_VoucherInsert6_conCtaDest1
		@RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, null, @NroCta, null, null, null, null, null, null, null, @Glosa, @MtoOr, @MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, 0.00, @Cd_CC,
		@Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, null, @Cd_TG, @IC_CtrMd, @UsuCrea, @IC_TipAfec, @TipOper, null, @IB_EsProv, null, null, null, null, @TipMov, @msj output
end

/*
declare @msj varchar(4000)
exec [pvo].[Ctb_AjustaSaldoCursor]
@RucE = '11111111111',
@Ejer = '2013',
@FecAjt = '20/03/2013',
@RegCtb = 'CTGN_LD03-00101',
@NroCta1 = null,
@NroCta2 = null,
@TC_AjC = 2.56,
@TC_AjV = 2.55,
@Cd_Area = '010101',
@Cd_MR = '01',
@Cd_CC = '01010101',
@Cd_SC = '01010101',
@Cd_SS = '01010101',
@UsuCrea = 'pepe',
@msj = @msj output
print @msj
*/
GO
