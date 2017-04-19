SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Rpt_LDSimplificado '11111111111','2010','01','12',9,null
CREATE procedure [user321].[Rpt_LDSimplificado]
@RucE nvarchar(11),
@Ejer varchar(4),
@Prdo1 varchar(2),
@Prdo2 varchar(2),
@Mda char(1),
@Nivel int,
@NroCtaD varchar(15),
@NroCtaH varchar(15),
@Filtro varchar(100),
@msj varchar(100) output
as
if not exists(select top 1 *from Voucher Where RucE=@RucE)
	set @msj='No hay registros'
else
begin

	declare @var varchar(4000)
	declare @Var1 varchar(200)
	set @Var1=''
	if(isnull(@NroCtaD,'')<>'' and isnull(@NroCtaH,'') <> '')
		set @Var1=' and a.NroCta between '''+@NroCtaD+''' and '''+@NroCtaH+''''
	else if(isnull(@NroCtaH,'')<>'')
		set @Var1=' and a.NroCta <= '''+@NroCtaH+''''
	else if(isnull(@NroCtaD,'')<>'')
		set @Var1=' and a.NroCta >= '''+@NroCtaD+''''

	--nivel 1 - 2
	--nivel 2 - 4
	--nivel 3 - 6
	--nivel 4 - 9
	set @var='select distinct left(a.NroCta,'+Convert(nvarchar,@Nivel)+') NroCta, 
	case(SubString(a.Cd_Blc,0,3)) when ''A1'' then ''1'' when ''A2'' then ''1'' when ''P1'' then ''2''
	when ''P2'' then ''2'' when ''PT'' then ''3'' else case(a.IC_IEN) when ''E'' then ''4'' when ''I'' then ''5'' end end as tipoCuenta,
	a.NomCta from PlanCtas a inner join Voucher b on a.RucE=b.RucE and a.NroCta=left(b.NroCta,'+Convert(nvarchar,@Nivel)+') and a.Ejer=b.Ejer
	where a.RucE='''+@RucE+''' and a.Ejer='''+@Ejer+''' and b.Prdo between '''+@Prdo1+''' and '''+@Prdo2+''' and  (a.Cd_Blc is not null or a.IC_IEN is not null)
             and b.Cd_Fte in('+@Filtro+') and substring(a.NroCta,0,2) <> '''''+@Var1+' 
	group by left(a.NroCta,'+Convert(nvarchar,@Nivel)+'),a.Cd_Blc,a.IC_IEN,a.NomCta
	order by 2, 1'
	print @Var
	exec(@var)
	--1 ACTVIVO
	--2 PASIVO
	--3 PATRIMONIO
	--4 EGRSO
	--5 INGRESO
	--60 gastos
	--70 ingresos
	--60 gastos
	--70 ingresos

	set @var='
	select a.RegCtb,a.Prdo,Max(a.Glosa) as Glosa,left(a.NroCta,'+Convert(nvarchar,@nivel)+') NroCta,
        	Sum(CASE('''+@Mda+''') when ''S'' then a.MtoD else a.MtoD_ME end) MtoD,SuM(case('''+@Mda+''') when ''S'' then a.MtoH else a.MtoH_ME end) MtoH,Convert(nvarchar,Max(a.FecMov),103) FecMov
	from Voucher a inner join PlanCtas b on a.RucE=b.RucE and b.NroCta=left(a.NroCta,'+Convert(nvarchar,@nivel)+') and a.Ejer=b.Ejer
	Where a.RucE='''+@RucE+''' and a.ejer='''+@Ejer+''' and a.Prdo between '''+@Prdo1+''' and '''+@Prdo2+''' and (b.Cd_Blc is not null or b.Ic_IEN is not null)
	and a.Cd_Fte in('+@Filtro+') and substring(a.NroCta,0,2) <> '''''+@Var1+'
	group by a.Prdo,a.Ejer,left(a.NroCta,'+Convert(nvarchar,@nivel)+'),a.RegCtb
	order by fecmov,a.RegCtb'
	print @var
	exec(@var)
end
--Leyenda--
--JJ :  18-01-2011   <Creacion del Procedimiento Almacenado>
--DI :  09-05-2011	 <Modificacion de "order by a.fecmov,a.RegCtb" --> "order by fecmov,a.RegCtb">
--DI :  05-12-2012	 <Modificacion de "substring(a.NroCta,0,2) <> ''9'' --> substring(a.NroCta,0,2) <> ''''">

GO
