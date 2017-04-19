SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherCons_Ultimo2]
--exec Ctb_VoucherCons_Ultimo2 '20507931686','2012',null
@RucE nvarchar(11),
@Eje nvarchar(4),
@msj varchar(100) output
as
if not exists (select top 1 Cd_Vou,Cd_TD,NroSre,NroDoc,RegCtb  from Voucher where RucE = @RucE and Ejer = @Eje and (TipOper = 'CHEQ' or Cd_TMP in ('007','102')) and ISNULL(NroChke,'')<>'' and ISNULL(IB_Anulado,0)<>1 order by FecReg desc)
set @msj = 'No se encontraron cheques registrados'
else
begin
select top 1 v.Cd_Vou,v.Cd_TD,v.NroSre,v.NroDoc,v.RegCtb,v.NroCta, p.NomCta
from Voucher v inner join
		PlanCtas p on p.NroCta = v.NroCta and p.RucE = v.RucE and p.Ejer = v.Ejer
		inner join Banco b on b.RucE = v.RucE and b.NroCta = v.NroCta and b.Ejer = v.Ejer 
where v.RucE = @RucE and v.Ejer = @Eje and (v.TipOper = 'CHEQ' or v.Cd_TMP in ('007','102')) and ISNULL(v.NroChke,'')<>'' and ISNULL(v.IB_Anulado,0)<>1 order by v.FecReg desc
end


--select * from MedioPago

--Creado JA: <13/09/2011>
--
GO
