SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_DocsAuxCons4]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Clt char(10),
@Cd_Prv char(7),
@IC_Oper char(1)
AS






--set @RucE='11111111111'
--set @Ejer='2012'
--set @Cd_Clt='CLT0000009'
declare @Consulta varchar(max)
declare @Opc varchar(500)
declare @Saldos varchar(100)
set @Saldos ='SaldoS, SaldoD,'
if(@IC_Oper='I') set @Opc='and p.IB_CtasXCbr<>0'
else if(@IC_Oper='E') 
Begin
	set @Opc = 'and p.IB_CtasXPag<>0'
	set @Saldos = 'SaldoS*-1 As SaldoS, SaldoD*-1 As SaldoD,'
end
else set @Opc='and (p.IB_CtasXCbr<>0 or p.IB_CtasXPag<>0)'
set @Consulta='
declare @Tabla table
(	
	Cd_Vou int null,
	NroCta varchar (15),
	NomCta varchar(200),
	DR_CdTD varchar(2),
	DR_NSre varchar(4),
	DR_NDoc varchar(15),
	TD varchar(2),
	Sre varchar(4),
	NroDoc varchar(15),
	Glosa varchar(200),
	SaldoS numeric(13,2),
	SaldoD numeric(13,2),
	MdReg char(5),
	TC_Org numeric(6,3) )
insert into @Tabla (Cd_Vou,NroCta,NomCta,DR_CdTD,DR_NSre,Dr_NDoc,TD,Sre,NroDoc,SaldoS,SaldoD,MdReg,TC_Org)
select	Cd_Vou, NroCta, NomCta, Case When Isnull(DR_CdTD,'''')='''' Then TD Else DR_CdTD End As DR_CdTD
		, Case When Isnull(DR_NSre,'''')='''' Then Sre else DR_NSre End As DR_NSre
		, Case When Isnull(Dr_NDoc,'''')='''' Then NroDoc else Dr_NDoc End As Dr_NDoc
		, TD, Sre, NroDoc, 
		'+@Saldos+'
		MdReg, TC_Org from (
		select 
			max(case(IB_EsProv) when ''1'' then v.Cd_Vou else 0 end) as Cd_Vou, Max(v.DR_CdTD) as DR_CdTD, Max(v.DR_NSre) as DR_NSre, Max(v.DR_NDoc) as DR_NDoc
			, v.NroCta, p.NomCta, v.Cd_TD as TD, v.NroSre as Sre, v.NroDoc, Sum(v.MtoD-v.MtoH) as SaldoS, Sum(v.MtoD_ME-v.MtoH_ME) as SaldoD,
			Max(case(IB_EsProv) when ''1'' then Case(v.Cd_MdRg) when ''01'' then ''S/.'' else ''US$'' end else '''' end)  as MdReg, 
			dbo.TipCamCalc('''+@RucE+''', '''+@Ejer+''', '''+isnull(@Cd_Clt,'')+''', '''+isnull(@Cd_Prv,'')+''', v.Cd_TD, v.NroSre, v.NroDoc) as TC_Org
		from Voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer='''+@Ejer+''' and p.NroCta=v.NroCta
		where 
			v.RucE='''+@RucE+''' and isnull(v.IB_Cndo,0)<>1  and isnull(v.IB_Anulado,0)<>1 '+@Opc+'
			and Case When isnull('''+Convert(varchar,Isnull(@Cd_Clt,''))+''','''') <>'''' Then v.Cd_Clt Else '''' End =isnull('''+Convert(varchar,Isnull(@Cd_Clt,''))+''','''')
			and Case When isnull('''+Convert(varchar,Isnull(@Cd_Prv,''))+''','''') <>'''' Then v.Cd_Prv Else '''' End =isnull('''+Convert(varchar,Isnull(@Cd_Prv,''))+''','''')
		Group by v.NroCta,p.NomCta,v.Cd_TD,v.NroSre,v.NroDoc
		having Sum(v.MtoD-v.MtoH)<>0
	) as CtasxCobrar where Cd_Vou > 0


-- Cabecera	
select 	Case When Conteo=1 then Convert(bit,1) else Convert(bit,0) End As Jala
		,Case When Conteo=1 then Cd_Vou else 0 end as Cd_Vou
		, NroCta, NomCta, DR_CdTD, DR_NSre, DR_NDoc, '''' TD
		, '''' Sre, '''' NroDoc, '''' Glosa, SaldoS, SaldoD, MdReg
		, Case when conteo=1 then TC_Org else .0 end As TC_Org
		from (
	select
		Count(DR_NDoc) as Conteo
		--, Sum(case wehn Count(DR_NDoc)=1 then Cd_Vou else 0 end) As Vou
		, Max(Cd_Vou) as Cd_Vou
		, NroCta
		, NomCta
		, DR_CdTD
		, DR_NSre
		, DR_NDoc
		, '''' TD
		, '''' Sre
		, '''' NroDoc
		, SUM(SaldoS) SaldoS
		, SUM(SaldoD) SaldoD
		, MdReg
		, MAX(TC_Org) TC_Org
	from 
		@Tabla
	Group By
		NroCta,NomCta,DR_CdTD,DR_NSre,DR_NDoc, MdReg
) as Cons 
Order By DR_CdTD desc ,DR_NSre desc, DR_NDoc desc

select
	Convert(bit,1) Jala 
	, *
from 
	@Tabla
where 
Cd_Vou not in(select
		Case When Conteo=1 then Cd_Vou else 0 end as Cd_Vou
		from (
	select Count(DR_NDoc) as Conteo, Max(Cd_Vou) as Cd_Vou
	from @Tabla Group By NroCta,NomCta,DR_CdTD,DR_NSre,DR_NDoc, MdReg
) as Cons 
)
Order By DR_CdTD desc ,DR_NSre desc, DR_NDoc desc, TD
'
print len(@Consulta)
print @Consulta
exec(@Consulta)

--exec Tsr_DocsAuxCons3 '11111111111','2012','CLT0003662',null,'I'
--MP : <28/08/2012> : <Modificacion del procedimiento almacenado: Se agrego Glosa>
GO
