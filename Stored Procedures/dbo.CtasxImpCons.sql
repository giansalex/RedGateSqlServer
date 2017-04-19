SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[CtasxImpCons]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
@NroCta nvarchar(10),
@Cd_IP char(7)
as

select @RegCtb as RegCtb, @NroCta as NroCta,pc.NomCta,
(select top 1 Cd_TD from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and Cd_TD is not null and Cd_TD <> '' group by Cd_TD) as Cd_TD,
(select top 1 NroSre from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and NroSre is not null and NroSre <> '' group by NroSre)as NroSre,
(select top 1 NroDoc from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and NroDoc is not null and NroDoc <> '' group by NroDoc)as NroDoc,
min(Cd_MdRg) as Cd_Mda, min(CamMda) as CamMda,
sum(MtoD-MtoH)-(select count(CstAsig) from impcomp where RucE= @RucE and RegCtb=@RegCtb and NroCta = @NroCta and Cd_IP <> @Cd_IP) as Imp,
sum(MtoD_ME-MtoH_ME)-(select count(CstAsig_ME) from impcomp where RucE= @RucE and RegCtb=@RegCtb and NroCta = @NroCta and Cd_IP <> @Cd_IP) as Imp_ME
from Voucher as v 
inner join planCtas pc on pc.RucE=v.RucE and pc.NroCta=v.NroCta and v.Ejer=pc.Ejer
where v.RucE = @RucE and  v.Ejer = @Ejer and v.RegCtb = @RegCtb and v.NroCta = @NroCta
group by pc.NomCta
GO
