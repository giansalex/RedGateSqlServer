SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXCbr_CCteResumAmb5_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Clt char(10),--Se cambio en nombre, antes era @Cd_Aux
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@IB_VerSaldados bit,
@msj varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL OFF

--if(@NroCta1='' or @NroCta1 is null)
--set @NroCta1 = '00'

--if(@NroCta2='' or @NroCta2 is null)
--set @NroCta2 = '99'



--declare @VarNum decimal(8,5)
--set @VarNum = 0.00
--if @IB_VerSaldados = 1
--begin
--	set @VarNum = 937.67676 -- cual numero que tenga mas de 2 decimales
--end

select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE

/*
if(@Cd_Clt!='' and @Cd_Clt is not null)
	begin
		select NDocAux,NomAux,Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo, Sum(Debe_ME) Debe_ME, Sum(Haber_ME) Haber_ME, Sum(Saldo_ME) Saldo_ME
		from(
		select 
		COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Informacion---') as NDocAux,
		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
		end 
		as NomAux,		
		
		sum(v.MtoD)Debe, 
		sum(v.MtoH)Haber,
		(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
		sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH_ME) Haber_ME,		
		(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		from voucher as v
	
		left join Empresa as e on e.Ruc=v.RucE
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv= v.RucE
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
		
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Clt= @Cd_Clt 
		and convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) 
		and convert(varchar,@FechaFin,102)
		and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		
		group by  c.NDoc,c.RSocial,pr.NDoc,pr.RSocial,v.Cd_Clt,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.ApPat,pr.ApMat,pr.Nom,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom
		having sum(v.MtoD) - sum(v.MtoH) + @VarNum <> 0 or sum(v.MtoD_ME) - sum(v.MtoH_ME) + @VarNum <> 0
		--order by c.RSocial,c.ApPat,c.ApMat,c.Nom
		) as Con1
		group by NDocAux,NomAux
		order by NomAux

	end
else
	begin
		select NDocAux,NomAux,Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo, Sum(Debe_ME) Debe_ME, Sum(Haber_ME) Haber_ME, Sum(Saldo_ME) Saldo_ME
		from(
		select 
		COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Informacion---') as NDocAux,
		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then null
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
		end 
		as NomAux,
		sum(v.MtoD)Debe, 
		sum(v.MtoH)Haber,
		(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
		sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH_ME) Haber_ME,		
		(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		from voucher as v

		left join Empresa as e on e.Ruc=v.RucE
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv= v.RucE
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
		
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and 
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) 
		and convert(varchar,@FechaFin,102)
		and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'

		group by  c.NDoc,c.RSocial,pr.NDoc,pr.RSocial,v.Cd_Clt,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.ApPat,pr.ApMat,pr.Nom,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom
		having sum(v.MtoD) - sum(v.MtoH) + @VarNum <> 0 or sum(v.MtoD_ME) - sum(v.MtoH_ME) + @VarNum <> 0
		--order by c.RSocial,c.ApPat,c.ApMat,c.Nom
	) as con2 
	group by NDocAux,NomAux
	order by NomAux

	end
	*/
	
Select 
	isnull(c.NDoc,isnull(r.NDoc,'')) As NDocAux,
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
																									   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
																	 End 							  
	End As NomAux,
	Sum(v.MtoD) As Debe,
	Sum(v.MtoH) As Haber,
	Sum(v.MtoD) - Sum(v.MtoH) As Saldo,
	Sum(v.MtoD_ME) As Debe_ME,
	Sum(v.MtoH_ME) As Haber_ME,
	Sum(v.MtoD_ME) - Sum(v.MtoH_ME) As Saldo_ME
	--,isnull(g.IB_Saldado,0) As IB_Saldado
From 
	Voucher v
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	Left Join 
	(	Select v.RucE,	v.Ejer,	v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 
		and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
		Group by v.RucE, v.Ejer,	v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), isnull(v.NroSre,''), isnull(v.NroDoc,'')
		Having Sum(v.MtoD) - Sum(v.MtoH)=0 and Sum(v.MtoD_ME) - Sum(v.MtoH_ME)=0
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
	
Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	and isnull(v.IB_Anulado,0)<>1
	and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
	and Case When isnull(@NroCta1,'')<>'' Then v.NroCta Else '' End>=isnull(@NroCta1,'')
	and Case When isnull(@NroCta2,'')<>'' Then v.NroCta Else '' End<=isnull(@NroCta2,'')
	and Case When isnull(@Cd_Clt,'')<>'' Then v.Cd_Clt Else '' End =isnull(@Cd_Clt,'')
Group by 
	isnull(c.NDoc,isnull(r.NDoc,'')),
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
																									   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
																	 End 							  
	End--,
	--g.IB_Saldado

Having
	sum(isnull(g.IB_Saldado + Convert(int,@IB_VerSaldados),0))=0
	and Sum(v.MtoD) + Sum(v.MtoH)<>0 and Sum(v.MtoD_ME) + Sum(v.MtoH_ME)<>0
	
Order by NomAux
	
	
	
print @msj
/*
--Jesus : Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
--exec Rpt_CtasXCbr_CCteResumAmb5_Fec '11111111111','2010','','','','01/12/2010','31/12/2010',1,null
*/

--DEMO
--exec Rpt_CtasXCbr_CCteResumAmb5_Fec '11111111111','2010','','','CLT0000002','01/01/2010','01/12/2010',1,null
--MP: VIE 17-09-2010 --> Se quito las referencia a la tabla auxiliar y se enlazo con Cliente2
		         --> Se cambio la variable Cd_Aux a Cd_Clt
--CM: PR03
--CM: RA01
--DI 02/08/2011 <Se quito el cambo IB_Saldadp en el Group by y se asigno como Suma en el Having>


GO
