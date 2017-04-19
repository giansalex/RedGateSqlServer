SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherCons_CB4]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
@NoNegociable char(1),
@msj varchar(100) output
as



if not exists (select * from Voucher where RucE=@RucE and RegCtb=@RegCtb)
	Set @msj = 'No existe voucher con el registro contable '+@RegCtb
else
begin
	select top 1 
		Convert(char(10),FecMov,103) as FecMov,
		case(Cd_MdRg) when '01' then (MtoD+MtoH) else (MtoD_ME+MtoH_ME) end  as Importe, 
		NroChke,
		Grdo,
		'CONTA PERU S.A.C.' as Empresa,
		v.NroCta,b.NroCta,b.NCtaB,
		b.Itm_BC,
		@NoNegociable AS NoNeg
		,e.CodSNT_ as CodBancoSunat
		
	--from Voucher v, Banco b
	--where v.RucE=@RucE and v.Ejer=@Ejer and b.Ejer=@Ejer and RegCtb=@RegCtb and v.RucE=b.RucE and v.NroCta=b.NroCta and (left(v.NroCta,2)='10' or left(v.NroCta,2)='12')
	
	from Voucher v--, Banco b
	Left Join Banco b on b.RucE =v.RucE and b.Ejer=v.Ejer and b.NroCta = v.NroCta
	left join EntidadFinanciera e on b.Cd_EF = e.Cd_EF
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Ejer=@Ejer and v.RegCtb=@RegCtb 
	and (v.NroCta in (Select NroCta From Banco Where RucE=@RucE and Ejer=@Ejer and isnull(Estado,0)=1) or left(v.NroCta,2)='12')

end
print @msj

--Ja: 07/06/2011 Creado

--exec Ctb_VoucherCons_CB4 '20100977037','2011','TSGN_CB06-00128','0',null
--select * from Voucher where RegCtb = 'VTGE_RV03-00019' and ruce='11111111111'
GO
