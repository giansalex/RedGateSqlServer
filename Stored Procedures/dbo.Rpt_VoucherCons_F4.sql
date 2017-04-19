SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VoucherCons_F4] --procedimiento final de la consulta de vouchers para imprimir en reporte
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb1 nvarchar(15),
@RegCtb2 nvarchar(15),
@mustraDestino bit,
@SumaDestino char(1),
@msj varchar(10) output
as
/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @RegCtb1 nvarchar(15)
Declare @RegCtb2 nvarchar(15)
Set @RucE = '20100977037' Set @Ejer = '2009' Set @RegCtb1 = 'TSGN_CB09-00444' Set @RegCtb2 = 'TSGN_CB09-00444'
*/



/************ TITULO ***********/

select 
	v.RucE,e.RSocial,v.RegCtb,'S/.' as Mda1, 'US$.' as Mda2,v.UsuCrea as Usuario,v.IB_Anulado as Anulado, @SumaDestino as SumaDestino
from Voucher v, Empresa e
where v.RucE=@RucE and v.Ejer=@Ejer and e.Ruc=v.RucE
      and v.RegCtb between @RegCtb1 and @RegCtb2
Group by v.RucE,e.RSocial,v.RegCtb,v.UsuCrea,v.IB_Anulado

/************ CEBECERA ***********/

/*CB*/
select 
	v.RegCtb,p.NomCta as Nombre,b.NCtaB as NroCta,v.CamMda as TipCmb,
	CASE(v.IB_Anulado) when 1 then 0.00 else Case(v.Cd_MdRg) when '01' then abs(v.MtoD) else abs(v.MtoD_ME) end end TotalI,
	CASE(v.IB_Anulado) when 1 then 0.00 else Case(v.Cd_MdRg) when '01' then abs(v.MtoH) else abs(v.MtoH_ME) end end TotalS,
	v.Cd_MdRg as MdaReg,
	--v.MtoD+v.MtoH as MtoMN, v.MtoD_ME+v.MtoH_ME as MtoME,
	--v.MtoD-v.MtoH as MtoMN, v.MtoD_ME-v.MtoH_ME as MtoME,
	Case(isnull(v.NroChke,0)) when '0' then isnull(v.TipOper,'') else isnull(v.TipOper,'')+'    '+isnull(v.NroChke,'') end as Oper
	
from Voucher v 
left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
left join Banco b on b.RucE=v.RucE and b.NroCta=v.NroCta and b.Ejer=v.Ejer
where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte='CB' and left(v.NroCta,2)='10'
      and v.RegCtb between @RegCtb1 and @RegCtb2
Group by v.RegCtb,p.NomCta,NCtaB,v.CamMda,v.Cd_MdRg,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.NroChke,v.TipOper,v.IB_Anulado

UNION ALL


/*RV y RC*/
/*
select 
	v.RegCtb,isnull(a.RSocial,a.ApPat+' '+a.ApMat+' '+a.Nom)as Nombre,'' as NroCta,v.CamMda as TipCmb,
	CASE(v.IB_Anulado) when 1 then 0.00 else Case(v.Cd_MdRg) when '01' then abs(v.MtoD) else abs(v.MtoD_ME) end end TotalI,
	CASE(v.IB_Anulado) when 1 then 0.00 else Case(v.Cd_MdRg) when '01' then abs(v.MtoH) else abs(v.MtoH_ME) end end TotalS, 
	v.Cd_MdRg as MdaReg,
	--v.MtoD+v.MtoH as MtoMN, v.MtoD_ME+v.MtoH_ME as MtoME,
	--v.MtoD-v.MtoH as MtoMN, v.MtoD_ME-v.MtoH_ME as MtoME,
	v.RegCtb as Oper
from Voucher v  
left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
left join Auxiliar a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte in ('RV','RC') and left(v.NroCta,2) in ('12','42','46')
      and v.RegCtb between @RegCtb1 and @RegCtb2
Group by v.RegCtb,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.CamMda,v.Cd_MdRg,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.RegCtb,v.IB_Anulado

UNION ALL
*/


select 
v.RegCtb,
case(isnull(len(v.Cd_Clt),0)) when 0 then
	case(isnull(len(pv2.RSocial),0)) when 0 then 
		isnull(nullif(pv2.ApPat +' '+pv2.ApMat+' '+pv2.Nom,''),'------- SIN NOMBRE ------')
	else pv2.RSocial 
	end
else
	case(isnull(len(cl2.RSocial),0)) when 0 then 
		isnull(nullif(cl2.ApPat +' '+cl2.ApMat+' '+cl2.Nom,''),'------- SIN NOMBRE ------')
	else cl2.RSocial
	end
end as Nombre_AUX,
'' as NroCta,v.CamMda as TipCmb,
CASE(v.IB_Anulado) when 1 then 0.00 else Case(v.Cd_MdRg) when '01' then abs(v.MtoD) else abs(v.MtoD_ME) end end TotalI,
CASE(v.IB_Anulado) when 1 then 0.00 else Case(v.Cd_MdRg) when '01' then abs(v.MtoH) else abs(v.MtoH_ME) end end TotalS, 
v.Cd_MdRg as MdaReg,
v.RegCtb as Oper
from Voucher v  
left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
left join Cliente2 as cl2 on v.Cd_Clt = cl2.Cd_Clt and v.RucE = cl2.RucE
left join Proveedor2 as pv2 on v.Cd_Prv = pv2.Cd_Prv and v.RucE = pv2.RucE
where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte in ('RV','RC') and left(v.NroCta,2) in ('12','42','46')
      and v.RegCtb between @RegCtb1 and @RegCtb2
Group by v.RegCtb,
	--cl2.RSocial,cl2.ApPat,cl2.ApMat,cl2.Nom,
	case(isnull(len(v.Cd_Clt),0)) when 0 then
	case(isnull(len(pv2.RSocial),0)) when 0 then 
		isnull(nullif(pv2.ApPat +' '+pv2.ApMat+' '+pv2.Nom,''),'------- SIN NOMBRE ------')
	else pv2.RSocial 
	end
else
	case(isnull(len(cl2.RSocial),0)) when 0 then 
		isnull(nullif(cl2.ApPat +' '+cl2.ApMat+' '+cl2.Nom,''),'------- SIN NOMBRE ------')
	else cl2.RSocial
	end
end,
	v.CamMda,v.Cd_MdRg,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.RegCtb,v.IB_Anulado
UNION ALL

/*LD*/
select 
	v.RegCtb,isnull(v.Grdo,Case When isnull(v.Cd_Clt,'')<>'' Then  isnull(isnull(cl2.RSocial,''),isnull(cl2.ApPat,'')+' '+isnull(cl2.ApMat,'')+' '+isnull(cl2.Nom,'')) Else isnull(isnull(pv2.RSocial,''),isnull(pv2.ApPat,'')+' '+isnull(pv2.ApMat,'')+' '+isnull(pv2.Nom,'')) End) as Nombre,'' as NroCta,
	v.CamMda as TipCmb,
	--,0.000 as TipCmb,
	--Max(Case(v.Cd_MdRg) when '01' then abs(v.MtoD-v.MtoH) else abs(v.MtoD_ME-v.MtoH_ME) end) Total, 
	0.00 as TotalI, 
	0.00 as TotalS,
	--v.Cd_MdRg as MdaReg,
	'01' as MdaReg,
	--v.MtoD-v.MtoH as MtoMN, v.MtoD_ME-v.MtoH_ME as MtoME,
	Case(isnull(v.NroChke,0)) when '0' then isnull(v.TipOper,'') else isnull(v.TipOper,'')+'    '+isnull(v.NroChke,'') end as Oper
from Voucher v  
--left join Auxiliar a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
left join Cliente2 as cl2 on v.Cd_Clt = cl2.Cd_Clt and v.RucE = cl2.RucE
left join Proveedor2 as pv2 on v.Cd_Prv = pv2.Cd_Prv and v.RucE = pv2.RucE
where v.RucE=@RucE and v.Ejer=@Ejer and v.Cd_Fte='LD'
      and v.RegCtb between @RegCtb1 and @RegCtb2
Group by v.RegCtb,v.CamMda,
	--cl2.RSocial,cl2.ApPat,cl2.ApMat,cl2.Nom,v.Cd_Clt,pv2.RSocial,pv2.ApPat,pv2.ApMat,pv2.Nom,v.CamMda
	isnull(v.Grdo,Case When isnull(v.Cd_Clt,'')<>'' Then  isnull(isnull(cl2.RSocial,''),isnull(cl2.ApPat,'')+' '+isnull(cl2.ApMat,'')+' '+isnull(cl2.Nom,'')) Else isnull(isnull(pv2.RSocial,''),isnull(pv2.ApPat,'')+' '+isnull(pv2.ApMat,'')+' '+isnull(pv2.Nom,'')) End),
	Case(isnull(v.NroChke,0)) when '0' then isnull(v.TipOper,'') else isnull(v.TipOper,'')+'    '+isnull(v.NroChke,'') end
--having isnull(v.Grdo,isnull(a.RSocial,a.ApPat+' '+a.ApMat+' '+a.Nom))!= 'NULL'

/*GLOSA ***********************************************************************************/

select v.RegCtb,v.Glosa from Voucher v 
where v.RucE=@RucE and v.Ejer=@Ejer
      and v.RegCtb between @RegCtb1 and @RegCtb2
Group by v.RegCtb,v.Glosa

/*FECHA DOCUMENTO Y DE MOVIMIENTO  ***********************************************************/

select v.RegCtb,Max(convert(varchar,v.FecED,103)) as FecDoc,Max(convert(varchar,v.FecMov,103)) as FecReg 
       ,Max(Case(v.Cd_Fte) when 'CB' then isnull(v.Grdo,Case When isnull(v.Cd_Clt,'')<>'' Then  isnull(isnull(cl2.RSocial,''),isnull(cl2.ApPat,'')+' '+isnull(cl2.ApMat,'')+' '+isnull(cl2.Nom,'')) Else isnull(isnull(pv2.RSocial,''),isnull(pv2.ApPat,'')+' '+isnull(pv2.ApMat,'')+' '+isnull(pv2.Nom,'')) End) else '' end) as NomAux
from Voucher v 
--left join Auxiliar a On a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
left join Cliente2 as cl2 on v.Cd_Clt = cl2.Cd_Clt and v.RucE = cl2.RucE
left join Proveedor2 as pv2 on v.Cd_Prv = pv2.Cd_Prv and v.RucE = pv2.RucE
where v.RucE=@RucE and v.Ejer=@Ejer
      and v.RegCtb between @RegCtb1 and @RegCtb2
Group by v.RegCtb--,convert(varchar,v.FecED,103),convert(varchar,v.FecReg,103)
--having convert(varchar,v.FecED,103)  != 'NULL'

/************ DETALLE ***********/

if(@mustraDestino=0)
begin
select
	v.RegCtb,v.NroCta,c.NomCta,Case When isnull(v.Cd_Clt,'')<>'' Then v.Cd_Clt Else v.Cd_Prv End As Cd_Aux,Case When isnull(v.Cd_Clt,'')<>'' Then cl2.NDoc Else pv2.NDoc End as NroAux,
 	v.Cd_TD,v.NroSre+'-'+v.NroDoc as Dcto,v.Cd_CC as CCos,v.Cd_SC as SCCos,v.Cd_SS as SSCCos,v.Glosa,
	v.Cd_MdRg,
	Case(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when '$' then 0 else v.MtoD end end as DebeMN,
	Case(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when '$' then 0 else v.MtoH end end as HaberMN,
	Case(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when 's' then 0 else v.MtoD_ME end end as DebeME,
	Case(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when 's' then 0 else v.MtoH_ME end end as HaberME
	,isnull(v.IB_esDes,0) As IB_esDes
from Voucher v
	left join PlanCtas c on v.RucE=c.RucE and v.NroCta=c.NroCta and v.Ejer=c.Ejer
	--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	left join Cliente2 as cl2 on v.Cd_Clt = cl2.Cd_Clt and v.RucE = cl2.RucE
	left join Proveedor2 as pv2 on v.Cd_Prv = pv2.Cd_Prv and v.RucE = pv2.RucE
where v.RucE=@RucE and v.Ejer=@Ejer
      and v.RegCtb between @RegCtb1 and @RegCtb2 and ib_esdes is null
end 

else
begin

select
	v.RegCtb,v.NroCta,c.NomCta,Case When isnull(v.Cd_Clt,'')<>'' Then v.Cd_Clt Else v.Cd_Prv End As Cd_Aux,Case When isnull(v.Cd_Clt,'')<>'' Then cl2.NDoc Else pv2.NDoc End as NroAux,
 	v.Cd_TD,v.NroSre+'-'+v.NroDoc as Dcto,v.Cd_CC as CCos,v.Cd_SC as SCCos,v.Cd_SS as SSCCos,v.Glosa,
	v.Cd_MdRg,
	Case(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when '$' then 0 else v.MtoD end end as DebeMN,
	Case(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when '$' then 0 else v.MtoH end end as HaberMN,
	Case(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when 's' then 0 else v.MtoD_ME end end as DebeME,
	Case(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when 's' then 0 else v.MtoH_ME end end as HaberME
	,isnull(v.IB_esDes,0) As IB_esDes
from Voucher v
	left join PlanCtas c on v.RucE=c.RucE and v.NroCta=c.NroCta and v.Ejer=c.Ejer
	--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	left join Cliente2 as cl2 on v.Cd_Clt = cl2.Cd_Clt and v.RucE = cl2.RucE
	left join Proveedor2 as pv2 on v.Cd_Prv = pv2.Cd_Prv and v.RucE = pv2.RucE
where v.RucE=@RucE and v.Ejer=@Ejer
      --v.RucE='20504743561' and v.Ejer='2011'
	--and v.RegCtb between 'CTGN_LD04-00005' and 'CTGN_LD04-00005'
      and v.RegCtb between @RegCtb1 and @RegCtb2

end

-- Leyenda --
-------------

-- DI : 05/10/2009 --> Creacion del procedimiento almacenado
-- DI : 19/10/2009 --> Se modifico en la FECHA DOCUMENTO Y DE REGISTRO que todos son diferente a NULL
-- DI : 23/10/2009 --> Se modifico en la FECHA DOCUMENTO Y DE REGISTRO que que envie el nombre Aux cuando sea CB
-- DI : 06/05/2010 --> Se modifico los campos para cuando es anulado un registro muestre 0
-- JS : 04/02/2011 --> Se agrego el campo EsDestino para el reporte de consulta vouchers
-- JA : 09/03/2011 --> Se agrego dos campos @SumaDestino, @MuestraDestino 
-- DI : 22/03/2011 --> Se agregi el ejercicio en la relacion  de PlanCtas
-- DI : 20/04/2011 --> <Se cambio auxiliar por Cliente2 y Proveedor2>





GO
