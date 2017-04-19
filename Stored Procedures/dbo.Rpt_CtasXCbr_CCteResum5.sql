SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXCbr_CCteResum5]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Clt char(10),--Antes estaba nvarchar(7), falta modificar en la progra
--@Prdo nvarchar(2),
@FechaAl smalldatetime,
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

select  Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR ,Convert(varchar,@FechaAl,103) as FechaAl
from Empresa where Ruc=@RucE
--select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR from Empresa where Ruc=@RucE
--if( @Cd_Mda = '01')
if(@Cd_Clt!='' and @Cd_Clt is not null)
begin
	select	
		isnull(clt2.NDoc,'No identificado') as NDocAux,
		isnull(clt2.RSocial,(isnull(clt2.ApPat,'')+' '+isnull(clt2.ApMat,'')+' '+isnull(clt2.Nom,''))) as NomAux,
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
		sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		@Cd_Mda as Moneda,
		case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
	from voucher as v
	--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join Cliente2 as clt2 on clt2.RucE=v.RucE and clt2.Cd_Clt=v.Cd_Clt
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	--left join Empresa as e on e.Ruc=a.RucE and e.Ruc=v.RucE----<<<<-----
	left join Empresa as e on e.Ruc=v.RucE

	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Clt = @Cd_Clt /*v.Cd_Aux= @Cd_Aux*/ and /*(v.FecMov <= @FechaAl)*/ convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
	--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'



	/*where v.RucE=@RucE and 
	v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and 
	p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' and 
	v.FecMov <= @FechaAl and v.Cd_Aux=@Cd_Aux*/
	group by clt2.NDoc,clt2.RSocial,clt2.ApPat,clt2.ApMat,clt2.Nom,v.Cd_MdRg
	having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
	order by clt2.RSocial,clt2.ApPat,clt2.ApMat,clt2.Nom
end
else
begin
	select	
		isnull(clt2.NDoc,'No identificado') as NDocAux,
		isnull(clt2.RSocial,(isnull(clt2.ApPat,'')+' '+isnull(clt2.ApMat,'')+' '+isnull(clt2.Nom,''))) as NomAux,
		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-
		sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		@Cd_Mda as Moneda,
		case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
	from voucher as v
	--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join Cliente2 as clt2 on clt2.RucE=v.RucE and clt2.Cd_Clt=v.Cd_Clt
	left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	--left join Empresa as e on e.Ruc=a.RucE and e.Ruc=v.RucE----<<<<-----	
	left join Empresa as e on e.Ruc=v.RucE
	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and  /*(v.FecMov <= @FechaAl)*/ convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
	--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'


	--where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' and v.FecMov <= @FechaAl
	group by clt2.NDoc,clt2.RSocial,clt2.ApPat,clt2.ApMat,clt2.Nom,v.Cd_MdRg
	having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
	order by clt2.RSocial,clt2.ApPat,clt2.ApMat,clt2.Nom
	

end	
print @msj
/*
Jesus -> 16-07-2010 : Se agrego la sentencia -> case(Cd_MdRg) when '01' then 'S/.' else 'US$' end as Cd_MdRg
*/
--MP: VIE 17-09-2010 --> Se quito las referencias a la tabla Auxiliar y se relaciono con la tabla Cliente2
--CM: PR03
--CM: RA01


GO
