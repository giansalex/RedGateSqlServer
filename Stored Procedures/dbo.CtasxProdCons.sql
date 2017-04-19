SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[CtasxProdCons]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RctbNcta varchar(4000)
as
declare @consulta varchar(2000),
@count varchar(1000),
@cond varchar(1000),
@rest varchar(100)

set @count = (select count(RegCtb) from CptoCostoOFDoc where RucE= ''+@RucE+'' and (regCtb + '|' + nrocta) in (''+@RctbNcta+'') )
set @cond = (select count(v.RegCtb) from voucher v inner join planctas cta on cta.RucE=v.ruce and v.nrocta=cta.nrocta where v.RucE=''+@RucE+'' and (v.regCtb + '|' + v.nrocta) in (''+@RctbNcta+'') and cta.IB_Imp=1)
set @rest = case when @count=0 then 1 else @count end

set @consulta = '
select 
	v.Regctb,v.Nrocta,
	case when '''+@cond+''' >1
	then 
		(case (v.Cd_MdOr) when ''02'' then (SUM((v.MtoD_ME-v.MtoH_ME)))/'''+@rest+''' else  (sum(v.MtoD-v.MtoH))/'''+@rest+''' end )
	else
		(case (v.Cd_MdOr) when ''02'' then SUM((v.MtoD_ME-v.MtoH_ME)) else  sum(v.MtoD-v.MtoH) end / COUNT(v.RegCtb)) end as TotalDH,
	case when '''+@cond+''' >1
	then
		SUM(cpto.CstAsig)/count(v.RegCtb) * '''+@rest+'''
	else
		SUM(cpto.CstAsig)end as CstAsig,
	case when '''+@cond+''' >1
	then
		(case (v.Cd_MdOr) when ''01'' then sum(v.MtoD-v.MtoH)/'''+@rest+''' else sum(MtoD_ME-v.MtoH_ME)/'''+@rest+''' end - case when SUM(CstAsig) is null then 0.00 else SUM(CstAsig) /count(v.RegCtb)*'''+@rest+''' end ) 
	else
		(case (v.Cd_MdOr) when ''01'' then sum(v.MtoD-v.MtoH)/ COUNT(v.RegCtb) else sum(MtoD_ME-v.MtoH_ME)/ COUNT(v.RegCtb) end - case when SUM(CstAsig) is null then 0.00 else SUM(CstAsig) end) end as Total, 	
	v.Cd_MdOr, v.CamMda
from Voucher v 
left join  CptoCostoOFDoc cpto on v.RucE=cpto.RucE and v.RegCtb=cpto.RegCtb and v.NroCta=cpto.NroCta
where v.RucE= '''+@RucE+''' and v.ejer='''+@Ejer+'''
and (v.regCtb + ''|'' + v.nrocta) in ('''+@RctbNcta+''')
group by v.nroCta,v.regctb,v.Cd_MdOr,cpto.Cd_Mda,v.Cd_MdOr, v.CamMda --order by regctb'
	exec(@consulta)
print @consulta
GO
