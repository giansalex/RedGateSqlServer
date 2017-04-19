SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_RegistroComprasCtb_X_Cli]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Rprdo1 nvarchar(2),
@Rprdo2 nvarchar(2),
@Cd_Mda nvarchar(2), --Servira para intercambio de moneda
@msj varchar(100) output
as
--Declare @Data nvarchar(150)  -- Jesus
If(@Cd_Mda = '01')
Begin
	/*select 
		v.RucE,e.RSocial,v.RegCtb,
		v.Ejer,@RPrdo1 as Prdo1,@RPrdo2 as Prdo2,
		v.Cd_Fte,convert(varchar,v.FecMov,103) FecMov,
		v.Cd_TD,
		v.NroSre,v.NroDoc,
		a.Cd_TDI,a.NDoc,Case(v.Cd_Aux) when '' then '' else isnull(a.RSocial, a.ApPat+' '+a.ApMat+' '+a.Nom) end NomAux
	from Voucher v
	inner join Empresa e on v.RucE=e.Ruc
	left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC'and (left(v.NroCta,2) in ('42','46')) and isnull(len(rtrim(v.IC_TipAfec)),0)=0 --VALIDAR  DE ACUERDO A LAS CUENTAS ASIGNADAS A CUENTAS POR PAGAR Y AUXILIAR
	Group by v.RucE,e.RSocial,v.Ejer,v.RegCtb,v.Cd_Fte,v.FecMov,v.RegCtb,v.Cd_TD,v.NroSre,v.NroDoc,a.Cd_TDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.Cd_Aux
	Order by 3*/
	


	---Jesus--
	
	if not exists(select * from voucher where RucE=@RucE and Cd_Fte='RC' and Ejer =@Ejer and Prdo between @Rprdo1 and @Rprdo2)
	begin
		--set @Data = '--------------NO EXISTEN REGISTROS DE COMPRA-----------------'
		--select @Data as Data,@Rprdo1 as Prdo1,@Rprdo1 as Prdo2,@Ejer as Ejer
		--select Ruc,RSocial from Empresa	where Ruc=@RucE

		select  top 1 
			@RucE as RucE,
			(select RSocial from Empresa Where Ruc=@RucE) as RSocial,
			'-----------' as RegCtb,
			@Ejer as Ejer,
			@RPrdo1 as Prdo1,
			@RPrdo2 as Prdo2,
			'--' as Cd_Fte,
			'-----' as FecMov,--convert(varchar,v.FecMov,103) FecMov,
			'--' as Cd_TD,
			'-----' as NroSre,
			'-----' as NroDoc,
			'--' as Cd_TDI,
			'--' as NDoc,
			'*** No contiene informaciÃ³n ***'  as NomAux,
			Case(@Cd_Mda) when '01' then 'Nuevos Soles' else 'DÃ³lares Americanos' end as NomMoneda,
			'--'  as FecR,
			'--'  as TDR,
			'--'  as NSreR,
			'--'  as NDocR
		from Voucher --v
		--left join Empresa e on v.RucE=e.Ruc
		--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		where RucE=@RucE and Ejer=@Ejer --and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' --and (left(v.NroCta,2) in ('42','46')) and isnull(len(rtrim(v.IC_TipAfec)),0)=0 --VALIDAR  DE ACUERDO A LAS CUENTAS ASIGNADAS A CUENTAS POR PAGAR Y AUXILIAR
--		Group by v.RucE,e.RSocial,v.Ejer,v.RegCtb,v.Cd_Fte,v.IB_Anulado--,v.RegCtb,v.DR_FecED,v.DR_CdTD,v.DR_NSre,v.DR_NDoc/*,v.FecED,v.Cd_TD,v.NroSre,v.NroDoc,a.Cd_TDI,a.NDoc*//*,a.RSocial,a.ApPat,a.ApMat,a.Nom*/--,v.Cd_Aux
--		Order by 3		

		
		select  top 1
		@RucE as RucE,
		'-----------' as RegCtb,
		0.00 as BIM_ME,
		0.00 CamMda,
		0.00 BIM1_S,
		0.00 BIM2_E,
		0.00 BIM3_C,
		0.00 BIM4_N,
		 '0' as IC_TipAfec
	from Voucher
	where RucE=@RucE
	--left join Empresa e on v.RucE=e.Ruc
	/* ANTERIOR
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (len(v.IC_TipAfec) > 0 or left(v.NroCta,6)='40.1.1' or v.NroCta in ('40.1.0.01'))--or v.NroCta in ('40.1.4.01'))
	*/
	--and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (len(v.IC_TipAfec) > 0)-- or left(v.NroCta,6)='40.1.1' or v.NroCta in ('40.1.0.01'))--or v.NroCta in ('40.1.4.01'))
	--Group by v.RucE,v.RegCtb--,v.CamMda--,v.Cd_MdRg
	--Order by 2


	select  top 1
		@RucE as RucE,
		'-----------' as RegCtb,
		0.00 as IGV,
		0.00 as Otros,
		0.00 as Total
		
	from Voucher
	where RucE=@RucE

	--left join PlanCtasDef p on v.RucE=p.RucE
	 --and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' --and (left(v.NroCta,4)='40.1' or v.NroCta in ('40.1.0.01','40.1.7.20') or len(v.IC_TipAfec)>0) --and v.RucE=p.RucE
	--Group by v.RucE,v.RegCtb
	--Order by 2

	end
	
	
	else
	begin
		select
			v.RucE,e.RSocial,v.RegCtb,
			v.Ejer,--@RPrdo1 as Prdo1,@RPrdo2 as Prdo2,
			v.Cd_Fte,Max(convert(varchar,v.FecED,103)) as FecMov,--convert(varchar,v.FecMov,103) FecMov,
			Max(v.Cd_TD) as Cd_TD,
			Max(v.NroSre) as NroSre,MAx(v.NroDoc) as NroDoc,
			Max(p.Cd_TDI) as Cd_TDI,Max(p.NDoc) as NDoc,
			tdi.NCorto + ' ' + p.NDoc as Grupo,
			/*Max(a.Cd_TDI) as Cd_TDI,Max(a.NDoc) as NDoc,
			tdi.NCorto + ' ' + a.NDoc as Grupo,*/
			Case(isnull(len(Max(v.Cd_Prv)),'0')) when '0' then '*** No Registrado ***' else isnull(Max(p.RSocial),
			(isnull(Max(isnull(p.ApPat,''))+' '+Max(isnull(p.ApMat,''))+' '+Max(isnull(p.Nom,'')),'*** No Existe en Data ***'))) end NomAux,
			/*Case(isnull(len(Max(v.Cd_Prv)),'0')) when '0' then '*** No Registrado ***' else isnull(Max(a.RSocial),
			(isnull(Max(isnull(a.ApPat,''))+' '+Max(isnull(a.ApMat,''))+' '+Max(isnull(a.Nom,'')),'*** No Existe en Data ***'))) end NomAux,*/
			Case(@Cd_Mda) when '01' then 'Nuevos Soles' else 'Dolares Americanos' end as NomMoneda,
			Case(v.IB_Anulado) when 0 then Max(convert(varchar,v.DR_FecED,103)) else '' end as FecR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_CdTD) else '' end as TDR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NSre) else '' end as NSreR,
			Case(v.IB_Anulado) when 0 then Max(v.DR_NDoc) else '' end as NDocR
		from Voucher v
		left join Empresa e on v.RucE=e.Ruc
		--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		left join proveedor2 p on p.RucE=v.RucE and p.Cd_Prv=v.Cd_Prv
		---------------------------------------------------------------------
		left join TipDocIdn tdi on tdi.Cd_TDI=p.Cd_TDI
		--inner join TipDocIdn tdi on a.Cd_TDI = tdi.Cd_TDI
		where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' --and (left(v.NroCta,2) in ('42','46')) and isnull(len(rtrim(v.IC_TipAfec)),0)=0 --VALIDAR  DE ACUERDO A LAS CUENTAS ASIGNADAS A CUENTAS POR PAGAR Y AUXILIAR
		Group by v.RucE,v.Ejer/*,a.NDoc*/,p.NDoc,e.RSocial,v.RegCtb,v.Cd_Fte,v.IB_Anulado,tdi.NCorto--,v.RegCtb,v.DR_FecED,v.DR_CdTD,v.DR_NSre,v.DR_NDoc/*,v.FecED,v.Cd_TD,v.NroSre,v.NroDoc,a.Cd_TDI,a.NDoc*//*,a.RSocial,a.ApPat,a.ApMat,a.Nom*/--,v.Cd_Aux
		Order by p.NDoc/*a.NDoc*/
	end
	-------------------------------------------------------------------------------------------------
	--CONSULTANDO LAS BASES IMPONIBLES
	-------------------------------------------------------------------------------------------------
	select  
		v.RucE,
		v.RegCtb,
		Sum(Case(v.Cd_MdRg) when '02' then Case( left(v.NroCta,6))when '40.1.1' then 0 else v.MtoD_ME-v.MtoH_ME end  else 0 end) BIM_ME,
		Max(v.CamMda) CamMda,
		--BIM--------------------
		Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD-v.MtoH else 0 end) BIM1_S,
		Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD-v.MtoH else 0 end) BIM2_E,
		Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD-v.MtoH else 0 end) BIM3_C,
		Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD-v.MtoH when 'F' then v.MtoD-v.MtoH else 0 end) BIM4_N,
		/* ANTERIOR
		Convert(varchar,Case(Sum(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 111 when 'C' then 1111 else 0 end)) 
			when 0 then 0  when 1 then 1  when 2 then 1 when 3 then 1 when 4 then 1 when 5 then 1  when 6 then 1 when 7 then 1 when 8 then 1 when 9 then 1 when 10 then 1 when 11 then 1 when 12 then 1 when 13 then 1 when 14 then 1 when 15 then 1
			when 16 then 1  when 17 then 1  when 18 then 1 	when 19 then 1 	when 20 then 1 	when 21 then 1  when 22 then 1 when 23 then 1 when 24 then 1 when 25 then 1 
			when 26 then 1 when 27 then 1 when 28 then 1 when 29 then 1 when 30 then 1 when 31 then 1 when 32 then 1  when 33 then 1  when 34 then 1 when 35 then 1 when 36 then 1 when 37 then 1  when 38 then 1 when 39 then 1 when 40 then 1 when 41 then 1 when 42 then 1 when 43 then 1 when 44 then 1 when 45 then 1 when 46 then 1 when 47 then 1	when 48 then 1 	when 49 then 1 when 50 then 1
			 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			when 111 then 2 when 222 then 2 when 333 then 2 when 444 then 2 when 555 then 2 when 666 then 2 when 777 then 2 when 888 then 2 when 999 then 2 when 1110 then 2 when 1221 then 2 when 1332 then 2 when 1443 then 2 when 1554 then 2 when 1665 then 2
			------------------------------------------------------------------------------------------------------------------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		             when 1111 then 3 when 2222 then 3 when 3333 then 3 when 4444 then 3 when 5555 then 3 when 6666 then 3 when 7777 then 3 when 8888 then 3 when 9999 then 3 when 11110 then 3 when 12221 then 3 when 13332 then 3 when 14443 then 3 when 15554 then 3 when 16665 then 3  
		end) IC_TipAfec
		*/
		Convert(varchar,Sum(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 2 when 'C' then 3 else 0 end) / Case(Count(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 2 when 'C' then 3 else 0 end) + Sum(Case(v.IC_TipAfec) when 'n' then -1 else 0 end)) when 0 then 1 else Count(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 2 when 'C' then 3 else 0 end) + Sum(Case(v.IC_TipAfec) when 'n' then -1 else 0 end) end) as IC_TipAfec
	from Voucher v
	left join Empresa e on v.RucE=e.Ruc
	--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	left join proveedor2 p on p.RucE=v.RucE and p.Cd_Prv=v.Cd_Prv
	/* ANTERIOR
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (len(v.IC_TipAfec) > 0 or left(v.NroCta,6)='40.1.1' or v.NroCta in ('40.1.0.01'))--or v.NroCta in ('40.1.4.01'))
	*/
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (len(v.IC_TipAfec) > 0)-- or left(v.NroCta,6)='40.1.1' or v.NroCta in ('40.1.0.01'))--or v.NroCta in ('40.1.4.01'))
	Group by v.RucE,p.NDoc,/*a.NDoc,*/v.RegCtb--,v.CamMda--,v.Cd_MdRg
	Order by p.NDoc/*a.NDoc*/
	-------------------------------------------------------------------------------------------------
	--CONSULTANDO EL IGV Y EL TOTAL
	-------------------------------------------------------------------------------------------------

	select  
	v.RucE,
	v.RegCtb,
	Sum(Case(left(v.NroCta,6)) when '40.1.0' then v.MtoD-v.MtoH  else 0 end + Case(v.NroCta) when '40.1.1.01' 
	then v.MtoD-v.MtoH when '40.1.1.10' then v.MtoD-v.MtoH else 0 end + Case(left(v.NroCta,10)) when '2002.01.01' 
	then v.MtoD-v.MtoH  else 0 end) IGV,
	Sum(Case(v.NroCta) when p.QCtg then v.MtoD-v.MtoH when '40.1.7.02' then v.MtoD-v.MtoH 
	when '40.1.1.30' then v.MtoD-v.MtoH else 0 end) as Otros,
	sum(Case(v.NroCta) when '40.1.0.02' then v.MtoD-v.MtoH else 0 end) Total
	from Voucher v
	left join PlanCtasDef p on v.RucE=p.RucE and p.Ejer=v.Ejer
	--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	left join proveedor2 pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' --and (left(v.NroCta,4)='40.1' or v.NroCta in ('40.1.0.01','40.1.7.20') or len(v.IC_TipAfec)>0) --and v.RucE=p.RucE
	Group by v.RucE,pr.NDoc/*,a.NDoc*/,v.RegCtb
	Order by pr.NDoc/*a.NDoc*/



End
Else
Begin
	/*
	select 
		v.RucE,e.RSocial,v.RegCtb,
		v.Ejer,@RPrdo1 as Prdo1,@RPrdo2 as Prdo2,
		v.Cd_Fte,convert(varchar,v.FecMov,103) FecMov,
		v.Cd_TD,
		v.NroSre,v.NroDoc,
		a.Cd_TDI,a.NDoc,Case(v.Cd_Aux) when '' then '' else isnull(a.RSocial, a.ApPat+' '+a.ApMat+' '+a.Nom) end NomAux
	from Voucher v
	inner join Empresa e on v.RucE=e.Ruc
	left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC'and (left(v.NroCta,2) in ('42','46')) and isnull(len(rtrim(v.IC_TipAfec)),0)=0 --VALIDAR  DE ACUERDO A LAS CUENTAS ASIGNADAS A CUENTAS POR PAGAR Y AUXILIAR
	Group by v.RucE,e.RSocial,v.Ejer,v.RegCtb,v.Cd_Fte,v.FecMov,v.RegCtb,v.Cd_TD,v.NroSre,v.NroDoc,a.Cd_TDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.Cd_Aux
	Order by 3*/

	
	---Jesus--
	
	if not exists(select * from voucher where RucE=@RucE and Cd_Fte='RC' and Ejer =@Ejer and Prdo between @Rprdo1 and @Rprdo2)
	begin
		select  top 1 
			@RucE as RucE,
			(select RSocial from Empresa Where Ruc=@RucE) as RSocial,
			'-----------' as RegCtb,
			@Ejer as Ejer,
			@RPrdo1 as Prdo1,
			@RPrdo2 as Prdo2,
			'--' as Cd_Fte,
			'-----' as FecMov,--convert(varchar,v.FecMov,103) FecMov,
			'--' as Cd_TD,
			'-----' as NroSre,
			'-----' as NroDoc,
			'--' as Cd_TDI,
			'--' as NDoc,
			'---NO EXISTEN REGISTROS---' as NomAux,
			Case(@Cd_Mda) when '01' then 'Nuevos Soles' else 'Dolares Americanos' end as NomMoneda,
			'--'  as FecR,
			'--'  as TDR,
			'--'  as NSreR,
			'--'  as NDocR
		from Voucher --v
		--left join Empresa e on v.RucE=e.Ruc
		--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		where RucE=@RucE and Ejer=@Ejer --and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' --and (left(v.NroCta,2) in ('42','46')) and isnull(len(rtrim(v.IC_TipAfec)),0)=0 --VALIDAR  DE ACUERDO A LAS CUENTAS ASIGNADAS A CUENTAS POR PAGAR Y AUXILIAR
--		Group by v.RucE,e.RSocial,v.Ejer,v.RegCtb,v.Cd_Fte,v.IB_Anulado--,v.RegCtb,v.DR_FecED,v.DR_CdTD,v.DR_NSre,v.DR_NDoc/*,v.FecED,v.Cd_TD,v.NroSre,v.NroDoc,a.Cd_TDI,a.NDoc*//*,a.RSocial,a.ApPat,a.ApMat,a.Nom*/--,v.Cd_Aux
--		Order by 3		

		
		select  top 1
		@RucE as RucE,
		'-----------' as RegCtb,
		0.00 as BIM_ME,
		0.00 CamMda,
		0.00 BIM1_S,
		0.00 BIM2_E,
		0.00 BIM3_C,
		0.00 BIM4_N,
		 '0' as IC_TipAfec
	from Voucher
	where RucE=@RucE
	--left join Empresa e on v.RucE=e.Ruc
	/* ANTERIOR
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (len(v.IC_TipAfec) > 0 or left(v.NroCta,6)='40.1.1' or v.NroCta in ('40.1.0.01'))--or v.NroCta in ('40.1.4.01'))
	*/
	--and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (len(v.IC_TipAfec) > 0)-- or left(v.NroCta,6)='40.1.1' or v.NroCta in ('40.1.0.01'))--or v.NroCta in ('40.1.4.01'))
	--Group by v.RucE,v.RegCtb--,v.CamMda--,v.Cd_MdRg
	--Order by 2


	select  top 1
		@RucE as RucE,
		'-----------' as RegCtb,
		0.00 as IGV,
		0.00 as Otros,
		0.00 as Total
		
	from Voucher
	where RucE=@RucE
	end
	

	else
	begin
	---Jesus--
	
	select 
		v.RucE,e.RSocial,v.RegCtb,
		v.Ejer,@RPrdo1 as Prdo1,@RPrdo2 as Prdo2,
		v.Cd_Fte,Min(convert(varchar,v.FecED,103)) as FecMov,--convert(varchar,v.FecMov,103) FecMov,
		Max(v.Cd_TD) as Cd_TD,
		Max(v.NroSre) as NroSre,MAx(v.NroDoc) as NroDoc,
		/*Max(a.Cd_TDI) as Cd_TDI,Max(a.NDoc) as NDoc,*/
		Max(p.Cd_TDI) as Cd_TDI,Max(p.NDoc) as NDoc,
		Case(isnull(len(Max(v.Cd_Aux)),'0')) when '0' then '*** No Registrado ***' else isnull(Max(p.RSocial),(isnull(Max(isnull(p.ApPat,''))+' '+Max(isnull(p.ApMat,''))+' '+Max(isnull(p.Nom,'')),'*** No Existe en Data ***'))) end NomAux,
		/*Case(isnull(len(Max(v.Cd_Aux)),'0')) when '0' then '*** No Registrado ***' else isnull(Max(a.RSocial),(isnull(Max(isnull(a.ApPat,''))+' '+Max(isnull(a.ApMat,''))+' '+Max(isnull(a.Nom,'')),'*** No Existe en Data ***'))) end NomAux,*/
		Case(@Cd_Mda) when '01' then 'Nuevos Soles' else 'Dolares Americanos' end as NomMoneda,
		Case(v.IB_Anulado) when 0 then Max(convert(varchar,v.DR_FecED,103)) else '' end as FecR,
		Case(v.IB_Anulado) when 0 then Max(v.DR_CdTD) else '' end as TDR,
		Case(v.IB_Anulado) when 0 then Max(v.DR_NSre) else '' end as NSreR,
		Case(v.IB_Anulado) when 0 then Max(v.DR_NDoc) else '' end as NDocR
	from Voucher v
	left join Empresa e on v.RucE=e.Ruc
	--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	left join proveedor2 p on p.RucE=v.RucE and p.Cd_Prv=v.Cd_Prv
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' --and (left(v.NroCta,2) in ('42','46')) and isnull(len(rtrim(v.IC_TipAfec)),0)=0 --VALIDAR  DE ACUERDO A LAS CUENTAS ASIGNADAS A CUENTAS POR PAGAR Y AUXILIAR
	Group by v.RucE,e.RSocial,p.NDoc/*,a.NDoc*/,v.Ejer,v.RegCtb,v.Cd_Fte,v.IB_Anulado--,v.RegCtb,v.DR_FecED,v.DR_CdTD,v.DR_NSre,v.DR_NDoc/*,v.FecED,v.Cd_TD,v.NroSre,v.NroDoc,a.Cd_TDI,a.NDoc*//*,a.RSocial,a.ApPat,a.ApMat,a.Nom*/--,v.Cd_Aux
	Order by p.NDoc/*a.NDoc*/
	end
	-------------------------------------------------------------------------------------------------
	--CONSULTANDO LAS BASES IMPONIBLES
	-------------------------------------------------------------------------------------------------
	select  
		v.RucE,
		v.RegCtb,
		Sum(Case(v.Cd_MdRg) when '02' then Case( left(v.NroCta,6))when '40.1.1' then 0 else v.MtoD_ME-v.MtoH_ME end  else 0 end) BIM_ME,
		Max(v.CamMda) CamMda,
		--BIM--------------------
		Sum(Case(v.IC_TipAfec) when 'S' then v.MtoD_ME-v.MtoH_ME else 0 end) BIM1_S,
		Sum(Case(v.IC_TipAfec) when 'E' then v.MtoD_ME-v.MtoH_ME else 0 end) BIM2_E,
		Sum(Case(v.IC_TipAfec) when 'C' then v.MtoD_ME-v.MtoH_ME else 0 end) BIM3_C,
		Sum(Case(v.IC_TipAfec) when 'N' then v.MtoD_ME-v.MtoH_ME when 'F' then v.MtoD-v.MtoH else 0 end) BIM4_N,
		/* ANTERIOR
		Convert(varchar,Case(Sum(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 111 when 'C' then 1111 else 0 end)) 
			when 0 then 0  when 1 then 1  when 2 then 1 when 3 then 1 when 4 then 1 when 5 then 1  when 6 then 1 when 7 then 1 when 8 then 1 when 9 then 1 when 10 then 1 when 11 then 1 when 12 then 1 when 13 then 1 when 14 then 1 when 15 then 1
			when 16 then 1  when 17 then 1  when 18 then 1 	when 19 then 1 	when 20 then 1 	when 21 then 1  when 22 then 1 when 23 then 1 when 24 then 1 when 25 then 1 
			when 26 then 1 when 27 then 1 when 28 then 1 when 29 then 1 when 30 then 1 when 31 then 1 when 32 then 1  when 33 then 1  when 34 then 1 when 35 then 1 when 36 then 1 when 37 then 1  when 38 then 1 when 39 then 1 when 40 then 1 when 41 then 1 when 42 then 1 when 43 then 1 when 44 then 1 when 45 then 1 when 46 then 1 when 47 then 1	when 48 then 1 	when 49 then 1 when 50 then 1
			 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			when 111 then 2 when 222 then 2 when 333 then 2 when 444 then 2 when 555 then 2 when 666 then 2 when 777 then 2 when 888 then 2 when 999 then 2 when 1110 then 2 when 1221 then 2 when 1332 then 2 when 1443 then 2 when 1554 then 2 when 1665 then 2
			------------------------------------------------------------------------------------------------------------------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		             when 1111 then 3 when 2222 then 3 when 3333 then 3 when 4444 then 3 when 5555 then 3 when 6666 then 3 when 7777 then 3 when 8888 then 3 when 9999 then 3 when 11110 then 3 when 12221 then 3 when 13332 then 3 when 14443 then 3 when 15554 then 3 when 16665 then 3  
		end) IC_TipAfec
		*/
		Convert(varchar,Sum(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 2 when 'C' then 3 else 0 end) / Case(Count(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 2 when 'C' then 3 else 0 end) + Sum(Case(v.IC_TipAfec) when 'n' then -1 else 0 end)) when 0 then 1 else Count(Case(v.IC_TipAfec) when 'S' then 1 when 'E' then 2 when 'C' then 3 else 0 end) + Sum(Case(v.IC_TipAfec) when 'n' then -1 else 0 end) end) as IC_TipAfec
	from Voucher v
	left join Empresa e on v.RucE=e.Ruc
	--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	left join proveedor2 p on p.RucE=v.RucE and p.Cd_Prv=v.Cd_Prv
	/* ANTERIOR
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (len(v.IC_TipAfec) > 0 or left(v.NroCta,6)='40.1.1' or v.NroCta in ('40.1.0.01'))--or v.NroCta in ('40.1.4.01'))
	*/
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC' and (len(v.IC_TipAfec) > 0)-- or left(v.NroCta,6)='40.1.1' or v.NroCta in ('40.1.0.01'))--or v.NroCta in ('40.1.4.01'))
	Group by v.RucE,p.NDoc,/*a.NDoc,*/v.RegCtb--,v.CamMda--,v.Cd_MdRg
	Order by p.NDoc/*a.NDoc*/
	-------------------------------------------------------------------------------------------------
	--CONSULTANDO EL IGV Y EL TOTAL
	-------------------------------------------------------------------------------------------------
	select  
	v.RucE,
	v.RegCtb,
	Sum(Case(left(v.NroCta,6)) when '40.1.0' then v.MtoD-v.MtoH  else 0 end + Case(v.NroCta) when '40.1.1.01' 
	then v.MtoD-v.MtoH when '40.1.1.10' then v.MtoD-v.MtoH else 0 end + Case(left(v.NroCta,10)) when '2002.01.01' 
	then v.MtoD-v.MtoH  else 0 end) IGV,
	Sum(Case(v.NroCta) when p.QCtg then v.MtoD-v.MtoH when '40.1.7.02' then v.MtoD-v.MtoH 
	when '40.1.1.30' then v.MtoD-v.MtoH else 0 end) as Otros,
	sum(Case(v.NroCta) when '40.1.0.02' then v.MtoD-v.MtoH else 0 end) Total
	from Voucher v
	left join PlanCtasDef p on v.RucE=p.RucE and p.Ejer=v.Ejer
	--left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	left join proveedor2 pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	where v.RucE=@RucE and v.Ejer=@Ejer and v.Prdo between @RPrdo1 and @RPrdo2 and v.Cd_Fte='RC'---and (left(v.NroCta,4)='40.1' or v.NroCta in ('40.1.0.01','40.1.7.20') or len(v.IC_TipAfec)>0) --and v.RucE=p.RucE
	Group by v.RucE,pr.NDoc,/*a.NDoc,*/v.RegCtb
	Order by pr.NDoc/*a.NDoc*/

End


-- LEYENDA --
-- J : 06/07/2010 <Modificacion : se agregÃ³ para que se pueda visualizar el Nro. Ruc, Aux cuando no haya registros>
-- Ejemplo
-- exec Rpt_RegistroComprasCtb_X_Cli '11111111111','2010','01','05','01',null
-- JJ: 2010-09-19:	Modificacion del SP RA01,  MG02

GO
