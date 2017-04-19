SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXPagar_CCteResumAmb4]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Prv char(7),--Cd_Prv char 7
--@Prdo nvarchar(2),
@FechaAl smalldatetime,
--@Cd_Mda nvarchar(2),
@msj varchar(100) output
as
if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,Convert(varchar,@FechaAl,103) as FechaAl from Empresa where Ruc=@RucE

if(@Cd_Prv!='' and @Cd_Prv is not null)
--if not exists(select * from voucher where rucE=@RucE and ejer=@Ejer)
--set @msj='Error de Consulta'
	begin
		select v.RucE,	
		-- isnull(a.NDoc,'No identificado') as NDoc, --<<-- Modificado en Linea 26
		isnull(pr.NDoc,'No identificado') as NDoc, --<<-- Nueva
		-- isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux, -- Modificado en linea 28
		isnull(pr.RSocial,(isnull(pr.ApPat,'')+' '+isnull(pr.ApMat,'')+' '+isnull(pr.Nom,''))) as NomAux, -- Nueva
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		sum(v.MtoD)Debe, 
		sum(v.MtoH)Haber,
		(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
		sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH_ME) Haber_ME,		
		(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux--<<--Modificado linea 38
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 
		and convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) and v.Cd_Prv=@Cd_Prv
		--group by v.RucE,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom--<<-- Modificado en linea 42
		group by v.RucE,pr.NDoc,pr.RSocial,pr.ApPat,pr.ApMat,pr.Nom --<<-- Nueva
		having sum(v.MtoD)-sum(v.MtoH)<>0 or sum(v.MtoD_ME)-sum(v.MtoH_ME)<>0
		--order by a.RSocial,a.ApPat,a.ApMat,a.Nom--<<-- Modificado linea 45
		order by pr.RSocial,pr.ApPat,pr.ApMat,pr.Nom --<<-- Nueva
	end
else
	begin
		select v.RucE,	
		--isnull(a.NDoc,'No identificado') as NDoc,--<<-- Modificado Linea 54
		isnull(pr.NDoc,'No identificado') as NDoc,--<<-- Nueva
		--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,--<<-- Modificado linea 56
		isnull(pr.RSocial,(isnull(pr.ApPat,'')+' '+isnull(pr.ApMat,'')+' '+isnull(pr.Nom,''))) as NomAux,--<<--Nueva
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		sum(v.MtoD)Debe, 
		sum(v.MtoH)Haber,
		(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
		sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH_ME) Haber_ME,		
		(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux--<<--Modificado linea 67
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 
		and convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102)
		--group by v.RucE,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom --<<-- Modificado linea 69
		group by v.RucE,pr.NDoc,pr.RSocial,pr.ApPat,pr.ApMat,pr.Nom
		having sum(v.MtoD)-sum(v.MtoH)<>0 or sum(v.MtoD_ME)-sum(v.MtoH_ME)<>0
		--order by a.RSocial,a.ApPat,a.ApMat,a.Nom--<<-- Modificado en Linea 82		
		order by pr.RSocial,pr.ApPat,pr.ApMat,pr.Nom--<<-- Nueva
	end
print @msj
--Leyenda
-- CAM VIE 17/08/2010 Modificado PR03 RA01:
--					Quito la tabla Auxiliar
--					Agregue la tabla Proveedor2
--					Modificacion del parametro @Cd_Aux por @Cd_Prv char 7
--
--exec  pvo.Rpt_CtasXPagar_CCteResumAmb4 '11111111111','2010','','','PRV0001','01/01/2010',''

GO
