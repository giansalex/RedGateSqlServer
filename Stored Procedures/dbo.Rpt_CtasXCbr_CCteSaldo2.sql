SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Rpt_CtasXCbr_CCteSaldo2]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Aux nvarchar(7),
@NroCta1 nvarchar(10),
--@Prdo nvarchar(2),
@NroCta2 nvarchar(10),
@FechaAl smalldatetime,
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as


--Tabla cabecera
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR from Empresa where Ruc=@RucE
	


if( @Cd_Aux= (select Cd_Aux from voucher where rucE=@RucE and Ejer=@Ejer and (left(NroCta,2)=12 or left(NroCta,2)=16 )and Cd_Aux=@Cd_Aux))

--if(@Cd_Aux!='')
begin

	if( @Cd_Mda = '01')
	begin
		select 	v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, sum(v.MtoD) Debe, sum(v.MtoH) Haber,
		@Cd_Mda as Cd_MdRg,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux
		--e.Rsocial
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		--left join Empresa as e on e.Ruc=v.RucE
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and (left(v.NroCta,2)=12 or left(v.NroCta,2)=16) and v.Cd_Aux= @Cd_Aux
		group by v.RucE, a.NDoc, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial 


	end
	else 
	begin
		select 	v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, sum(v.MtoD_ME) Debe, sum(v.MtoH_ME) Haber,
		@Cd_Mda as Cd_MdRg, case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux
	--	e.Rsocial
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		--left join Empresa as e on e.Ruc=v.RucE
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and (left(v.NroCta,2)=12 or left(v.NroCta,2)=16) and v.Cd_Aux=@Cd_Aux
		group by v.RucE, a.NDoc, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial
	end

end
else
begin
	if( @Cd_Mda = '01')
	begin
		select 	 v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, sum(v.MtoD) Debe, sum(v.MtoH) Haber,
		@Cd_Mda as Cd_MdRg,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux
	--	e.Rsocial
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		--left join Empresa as e on e.Ruc=v.RucE
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) /*and a.cd_aux=@Cd_Aux*/ and (left(v.NroCta,2)=12 or left(v.NroCta,2)=16)
		group by v.RucE, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial, a.NDoc
	end
	else 
	begin
		select 	v.NroCta, a.NDoc as Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103) as FecMov, v.FecVD, datediff(day,v.FecMov,@FechaAl) as Saldo_Dias, sum(v.MtoD_ME) Debe, sum(v.MtoH_ME) Haber,
		@Cd_Mda as Cd_MdRg,case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux
		--e.Rsocial
		from voucher as v
		left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		--left join Empresa as e on e.Ruc=v.RucE
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2)/* and a.cd_aux=@Cd_Aux*/ and (left(v.NroCta,2)=12 or left(v.NroCta,2)=16)
		group by v.RucE, a.NDoc, v.NroCta, v.Cd_Aux, v.Cd_TD, v.NroSre, v.NroDoc, convert(varchar,v.FecMov,103), v.FecVD, datediff(day,v.FecMov,@FechaAl), v.Cd_MdRg,a.ApPat,a.ApMat,a.Nom,a.RSocial
	end
end

------CODIGO DE MODIFICACION--------
--CM=MG01
GO
