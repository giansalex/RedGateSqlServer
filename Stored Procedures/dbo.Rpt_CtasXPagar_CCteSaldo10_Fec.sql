SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Rpt_CtasXPagar_CCteSaldo10_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Prv char(7),--Modificado, antes era @Cd_Aux nvarchar(7)
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@Cd_Mda nvarchar(2),
@IB_VerSaldados bit,

@msj varchar(100) output
as
--set @RucE='11111111111'
--set @Ejer='2011'
--set @Cd_Mda='01'
--set @FechaIni='01/03/2011'
--set @FechaFin='31/05/2011'
--set @IB_VerSaldados=0

declare @VarNum decimal(8,5)
set @VarNum = 0.00
if @IB_VerSaldados = 1
begin
	set @VarNum = 937.67676 -- cual numero que tenga mas de 2 decimales
end

if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

--TABLA CABECERA
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE


--TABLA DETALLE
if(@Cd_Prv!='' and @Cd_Prv is not null)
begin

	select 
			COALESCE(isnull(pr.NDoc,''),'---Sin Información---') as NDoc,
			case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial end as NomAux,
			v.NroCta,
			isnull(v.Cd_TD,'') as Cd_TD, isnull(v.NroSre,'') as NroSre, isnull(v.NroDoc,'') as NroDoc,
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, 
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,v.FecCbr) else 0 end) as Saldo_Dias,  
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
			@Cd_Mda as Cd_MdRg
	from 
			voucher as v left join PlanCtas as p on
			p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
			left join proveedor2 pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	where
			v.RucE=@RucE and 
			v.Ejer=@Ejer and 
			isnull(p.IB_CtasXPag,0)=1 and
			isnull(v.IB_Anulado,0)<>1 and
			v.Cd_Prv=@Cd_Prv and
			Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
			and (v.NroCta between @NroCta1 and @NroCta2)
	Group By 
			pr.NDoc,
			pr.ApPat,
			pr.ApMat,
			pr.Nom,
			pr.Rsocial,
			v.NroCta,
			v.Cd_TD,
			v.NroSre,
			v.NroDoc,
			v.Cd_Prv
	having 
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum <>0
	order by 
			NomAux

end
else 
	begin

	select 
			COALESCE(isnull(pr.NDoc,''),'---Sin Información---') as NDoc,
			case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial end as NomAux,
			v.NroCta,
			isnull(v.Cd_TD,'') as Cd_TD, isnull(v.NroSre,'') as NroSre, isnull(v.NroDoc,'') as NroDoc,
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, 
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,v.FecCbr) else 0 end) as Saldo_Dias,  
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
			@Cd_Mda as Cd_MdRg
	from 
			voucher as v left join PlanCtas as p on
			p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
			left join proveedor2 pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	where
			v.RucE=@RucE and 
			v.Ejer=@Ejer and 
			isnull(p.IB_CtasXPag,0)=1 and
			isnull(v.IB_Anulado,0)<>1 and
			Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
			and (v.NroCta between @NroCta1 and @NroCta2)
	Group By 
			pr.NDoc,
			pr.ApPat,
			pr.ApMat,
			pr.Nom,
			pr.Rsocial,
			v.NroCta,
			v.Cd_TD,
			v.NroSre,
			v.NroDoc,
			v.Cd_Prv
	having 
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum <>0
	order by 
			NomAux

end
GO
