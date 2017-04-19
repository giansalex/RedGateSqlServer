SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Rpt_Detraccion_Alerta '11111111111','2012'

CREATE procedure [dbo].[Rpt_Detraccion_Alerta1]
@RucE nvarchar(11),
@Ejer varchar(4),
@FecD date,
@FecH date
AS

declare @Today datetime
set @Today=getdate()
declare @Cons_Niv1_1 varchar(max)--, @Cons_Niv1_2 varchar(max),@Cons_Niv1_End varchar(400)
--NIVELES
--1 = Documentos
--2 = Registros Contables
--Documentos
--1 = Pagados
--2 = Pendientes de pago

set @Cons_Niv1_1='
declare @Today datetime
set @Today=getdate()
--select Convert(varchar,@Today,103) Today
select SUM(Pendiente) as Pendiente, Sum(Vencido) as Vencido from(
select  case when Isnull(Estado,'''')=''Pendiente'' then isnull(Cant,0) else 0 end as Pendiente,
		case when isnull(Estado,'''')=''Vencido'' then isnull(Cant,0) else 0 end as Vencido,
		1 as paraagrupar from (
select Count(*) Cant ,Estado from (
select case when Canc=1 then ''Pagado'' else case when Datediff(Day,@Today,FecVD) <0 then ''Vencido'' when Datediff(Day,@Today,FecVD) >=0 then ''Pendiente'' End End as Estado,t.FecVd from (
select 
	1 as niv,
	Convert(bit,1) as Canc, v.RucE,v.Ejer, v.Cd_Prv,p2.NDoc
	, case when ISNULL(p2.RSocial,'''')='''' then ISNULL(p2.ApPat,'''')+'' ''+ISNULL(p2.ApMat,'''')+'' ''+ISNULL(p2.Nom,'''') else ISNULL(p2.RSocial,'''') end as Proveedor
	, Convert(varchar,Max(v.FecMov),103) FecMov, Convert(varchar,Max(v.FecED),103) FecED, Convert(varchar,Max(v.FecVD),103) FecVD, '''' as RegCtb, '''' Glosa, v.Cd_TD, Isnull(v.NroSre,'''') NroSre ,Isnull(v.NroDoc,'''') NroDoc
	,Sum(v.MtoD) MtoD, Sum(v.MtoH) MtoH,Sum(v.MtoD - v.MtoH) SaldoMN
	,Sum(v.MtoD_ME) MtoD_ME, Sum(v.MtoH_ME) MtoH_ME, Sum(v.MtoD_ME - v.MtoH_ME) SaldoME
	,'''' Cd_Area,'''' Cd_CC,'''' Cd_SC,'''' Cd_SS,Convert(bit,0) IB_EsProv, Convert(bit,0) IB_Anulado
	,'''' UsuCrea,'''' FecReg
from  
	 voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	 inner join Proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
where 
	 v.RucE='''+Convert(varchar,@RucE)+''' and v.Ejer='''+Convert(varchar,@Ejer)+''' and isnull(p.IB_Dtr,0)<>0 and Convert(date,v.FecMov) between Convert(date,'''+Convert(varchar(50),@FecD)+''') and Convert(date,'''+Convert(varchar(50),@FecH)+''')
Group By v.RucE,v.Ejer,v.Cd_Prv,p2.NDoc
		 ,case when ISNULL(p2.RSocial,'''')='''' then ISNULL(p2.ApPat,'''')+'' ''+ISNULL(p2.ApMat,'''')+'' ''+ISNULL(p2.Nom,'''') else ISNULL(p2.RSocial,'''') end
		 ,v.Cd_TD,v.NroSre,v.NroDoc
Having Sum(v.MtoD - v.MtoH) + Sum(v.MtoD_ME - v.MtoH_ME) = 0
union all
select 
	1 as niv, Convert(bit,0) as Canc,v.RucE,v.Ejer, v.Cd_Prv,p2.NDoc
	, case when ISNULL(p2.RSocial,'''')='''' then ISNULL(p2.ApPat,'''')+'' ''+ISNULL(p2.ApMat,'''')+'' ''+ISNULL(p2.Nom,'''') else ISNULL(p2.RSocial,'''') end as Proveedor
	, Convert(varchar,Max(v.FecMov),103) FecMov, Convert(varchar,Max(v.FecED),103) FecED, Convert(varchar,Max(v.FecVD),103) FecVD,'''' as RegCtb, '''' Glosa, v.Cd_TD, Isnull(v.NroSre,'''') NroSre ,Isnull(v.NroDoc,'''') NroDoc
	,Sum(v.MtoD) MtoD, Sum(v.MtoH) MtoH,Sum(v.MtoD - v.MtoH) SaldoMN
	,Sum(v.MtoD_ME) MtoD_ME, Sum(v.MtoH_ME) MtoH_ME, Sum(v.MtoD_ME - v.MtoH_ME) SaldoME
	,'''' Cd_Area,'''' Cd_CC,'''' Cd_SC,'''' Cd_SS,Convert(bit,0) IB_EsProv, Convert(bit,0) IB_Anulado
	,'''' UsuCrea,'''' FecReg
from  
	 voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	 inner join Proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
where 
	 v.RucE='''+Convert(varchar,@RucE)+''' and v.Ejer='''+Convert(varchar,@Ejer)+''' and isnull(p.IB_Dtr,0)<>0 and Convert(date,v.FecMov) between Convert(date,'''+Convert(varchar(50),@FecD)+''') and Convert(date,'''+Convert(varchar(50),@FecH)+''')
Group By v.RucE,v.Ejer,v.Cd_Prv,p2.NDoc
		 ,case when ISNULL(p2.RSocial,'''')='''' then ISNULL(p2.ApPat,'''')+'' ''+ISNULL(p2.ApMat,'''')+'' ''+ISNULL(p2.Nom,'''') else ISNULL(p2.RSocial,'''') end
		 ,v.Cd_TD,v.NroSre,v.NroDoc
Having Sum(v.MtoD - v.MtoH) + Sum(v.MtoD_ME - v.MtoH_ME) <> 0
)as t
where t.Canc<>1
) as t 
group by Estado
) as t
)as t
group by paraagrupar
--order by t.Canc desc,t.NroDoc,t.niv
'
print 'len var 1: '+ Convert(varchar,len(@Cons_Niv1_1))

print @Cons_Niv1_1





exec(
@Cons_Niv1_1
)
GO
