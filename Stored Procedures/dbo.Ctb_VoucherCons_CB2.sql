SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherCons_CB2]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
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
		'' AS NoNeg
		
	--from Voucher v, Banco b
	--where v.RucE=@RucE and v.Ejer=@Ejer and b.Ejer=@Ejer and RegCtb=@RegCtb and v.RucE=b.RucE and v.NroCta=b.NroCta and (left(v.NroCta,2)='10' or left(v.NroCta,2)='12')
	
	from Voucher v--, Banco b
	Left Join Banco b on b.RucE =v.RucE and b.Ejer=v.Ejer and b.NroCta = v.NroCta
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Ejer=@Ejer and v.RegCtb=@RegCtb 
	and (left(v.NroCta,2)='10' or left(v.NroCta,2)='12')

end
print @msj
--PV: 22/07/2009 Mdf: para que jale tb dolares segun voucher
--PV: 21/09/2009 Mdf: para que jale tb Banco del NroCta --> para tomarlo en cuenta a la hora del reporte de cheque
--PV: 22/09/2009 Mdf: campo  se agrego NoNeg
--Ja: 31/03/2011 Mdf: declare @NoNegociable para imprimir texto NoNegociable
--exec Ctb_VoucherCons_CB2 '11111111111','2011','VTGE_RV03-00019','1',null
--select * from Voucher where RegCtb = 'VTGE_RV03-00019' and ruce='11111111111'
GO
