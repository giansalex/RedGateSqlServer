SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherCons_CB5]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtbDesde nvarchar(16),
@RegCtbHasta nvarchar(16),
@NoNegociable char(1),
@Cta_Banco nvarchar(10),
@msj varchar(100) output
as



--if not exists (select * from Voucher where RucE=@RucE and (RegCtb=@RegCtbDesde or RegCtb = @RegCtbHasta))
if not exists (select Cd_Vou,Cd_TD,NroSre,NroDoc,RegCtb  from Voucher where RucE = @RucE and Ejer = @Ejer and (TipOper = 'CHEQ' or Cd_TMP in ('007','102')) and ISNULL(NroChke,'')<>'' and ISNULL(IB_Anulado,0)<>1 and RegCtb = @RegCtbDesde) or not exists (select Cd_Vou,Cd_TD,NroSre,NroDoc,RegCtb  from Voucher where RucE = @RucE and Ejer = @Ejer and (TipOper = 'CHEQ' or Cd_TMP in ('007','102')) and ISNULL(NroChke,'')<>'' and ISNULL(IB_Anulado,0)<>1 and RegCtb = @RegCtbHasta)
	Set @msj = 'No existe voucher con el registro contable'
else
begin
	select  
		Convert(char(10),FecMov,103) as FecMov,
		case(Cd_MdRg) when '01' then (MtoD+MtoH) else (MtoD_ME+MtoH_ME) end  as Importe, 
		v.NroChke,
		Grdo,
		'' as Empresa,
		v.NroCta,
		b.NroCta,
		b.NCtaB,
		b.Itm_BC,
		@NoNegociable AS NoNeg
		,e.CodSNT_ as CodBancoSunat
		
	--from Voucher v, Banco b
	--where v.RucE=@RucE and v.Ejer=@Ejer and b.Ejer=@Ejer and RegCtb=@RegCtb and v.RucE=b.RucE and v.NroCta=b.NroCta and (left(v.NroCta,2)='10' or left(v.NroCta,2)='12')
	
	from Voucher v--, Banco b
	Left Join Banco b on b.RucE =v.RucE and b.Ejer=v.Ejer and b.NroCta = v.NroCta
	left join EntidadFinanciera e on b.Cd_EF = e.Cd_EF
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Ejer=@Ejer and v.RegCtb between @RegCtbDesde and @RegCtbHasta
	and (v.TipOper = 'CHEQ' or v.Cd_TMP in ('007','102')) and ISNULL(NroChke,'')<>'' and ISNULL(v.IB_Anulado,0)<>1
	and (v.NroCta in (Select NroCta From Banco Where RucE=@RucE and Ejer=@Ejer and isnull(Estado,0)=1) or left(v.NroCta,2)='12')
	and case when @Cta_Banco = '' then '' else v.NroCta end = isnull(@Cta_Banco,'')
	--and v.NroCta = @Cta_Banco
end
print @msj



--Ja: 17/08/2011 Creado
--Cheques Masivos.
--exec Ctb_VoucherCons_CB5 '20507931686','2012','TSSM_CB09-00001','TSSM_CB09-00001',1,'10.41.01.1',null

GO
