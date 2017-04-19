SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXCbr_CCteSaldo7]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Clt char(10),
@NroCta1 nvarchar(10),
--@Prdo nvarchar(2),
@NroCta2 nvarchar(10),
@FechaAl smalldatetime,
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

--TABLA CABECERA
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,Convert(varchar,@FechaAl,103) as FechaAl from Empresa where Ruc=@RucE

--TABLA DETALLE
if(@Cd_Clt!='' and @Cd_Clt is not null)
begin
		
		select 	
			--isnull(a.NDoc,'No identificado') as NDocAux, --<<-- Modificado en Linea 28
			isnull(c.NDoc,'No identificado') as NDocAux, --<<-- Nueva
			--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux, --<<-- Modificado en Linea 30
			isnull(c.RSocial,(isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))) as NomAux, --<<-- Nueva
			v.NroCta,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, v.NroCta,
			--Max(v.Cd_TD) as Cd_TD, Max(v.NroSre) as NroSre, Max(v.NroDoc) as NroDoc,
			isnull(v.Cd_TD,'') as Cd_TD,isnull(v.NroSre,'') as NroSre,isnull(v.NroDoc,'') as NroDoc,
			-- ANTES
			-- convert(varchar,v.FecED,103) as FecED, 
			-- v.FecVD as FecVD, /*v.FecVD,*/ 
			-- datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,  					
			
			-- DESPUES (MEJORA)
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, -- else '00/00/0000' end) as FecED, 
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD, -- else '00/00/0000' end) as FecVD, 
			--sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,v.FecCbr) else 0 end) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,  
			
			--convert(varchar,@FechaAl,103) as FechaAl,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
			@Cd_Mda as Cd_Mda--, --> DEBERIA JALAR LA MONEDA DEL VOUCHER
			--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
		from voucher as v
		left join Empresa emp on emp.Ruc=v.RucE
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux --<<-- Modificado en Linea 55
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt --<<-- Nueva
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
		--left join Empresa as e on e.Ruc=v.RucE


		where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta>=@NroCta1 and v.NroCta<=@NroCta2 
		/*(v.NroCta between @NroCta1 and @NroCta2)*/ 
		and v.Cd_Clt = @Cd_Clt and /*(v.FecMov <= @FechaAl)*/
		 convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) 
		and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'


		/*where v.RucE=@RucE and v.Ejer=@Ejer 
		and (v.NroCta between @NroCta1 and @NroCta2) 
		and p.IB_CtasXCbr=1  and v.IB_Anulado<>'1'
		and v.FecMov <= @FechaAl
		and v.Cd_Aux= @Cd_Aux*/
		/*and a.NDoc not in (select isNull(a.NDoc,'No identificado') as NDoc from voucher as v
				left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
				left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
				where v.RucE=@RucE and v.Ejer=@Ejer 
				and (v.NroCta between @NroCta1 and @NroCta2) 
				and p.IB_CtasXCbr=1 and v.FecMov <= @FechaAl and v.IB_Anulado<>'1' 
				and v.Cd_Aux= @Cd_Aux
				group by a.NDoc
				having sum(case(@Cd_Mda) when '01' then (v.MtoD) 
				else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)=0
					   )*/
		--group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc--,v.Cd_MdRg, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg --<<-- Modificado en Linea 85
		group by c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial, v.NroCta, v.Cd_TD,v.NroSre,v.NroDoc --<<-- Nueva
		having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
		order by NomAux--,v.Cd_TD,v.NroSre, v.NroDoc,FecED,a.NDoc


end
else -- No tiene aux
begin

		select 	
			-- isnull(a.NDoc,'No identificado') as NDocAux, --<<-- Modificado en Linea 96
			isnull(c.NDoc,'No identificado') as NDocAux, --<<-- Nueva
			-- isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux, --<<-- Modificado en Linea 98
			isnull(c.RSocial,(isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))) as NomAux, --<<-- Nueva
			 v.NroCta,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, v.NroCta,
			--Max(v.Cd_TD) as Cd_TD, Max(v.NroSre) as NroSre, Max(v.NroDoc) as NroDoc,
			isnull(v.Cd_TD,'') as Cd_TD,isnull(v.NroSre,'') as NroSre,isnull(v.NroDoc,'') as NroDoc,
			-- ANTES
			-- convert(varchar,v.FecED,103) as FecED, 
			-- v.FecVD as FecVD, /*v.FecVD,*/ 
			-- datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,  
					
			-- DESPUES (MEJORA)
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, -- else '00/00/0000' end) as FecED, 
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD, -- else '00/00/0000' end) as FecVD, 
			--sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,v.FecCbr) else 0 end) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,  

			--convert(varchar,@FechaAl,103) as FechaAl,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
			@Cd_Mda as Cd_MdRg--, --> DEBERIA JALAR LA MONEDA DEL VOUCHER
		--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
		from voucher as v
		left join Empresa as e on e.Ruc=v.RucE
		-- left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux --<<-- Modificado en Linea 123
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt --<<-- Nueva
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
		
		where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta>=@NroCta1 and v.NroCta<=@NroCta2 
		/*(v.NroCta between @NroCta1 and @NroCta2)*/and /*(v.FecMov <= @FechaAl)*/ 
		convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) 
		and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'

		--where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) 
		--and p.IB_CtasXCbr=1 /*and v.Cd_Aux= @Cd_Aux*//*==*//*and v.IB_Anulado<>'1'*/ /*and ==*/ 
		--and v.FecMov <= @FechaAl and v.IB_Anulado<>1
		/*and a.NDoc not in (select isNull(a.NDoc,'No identificado') as NDoc 
				   from voucher as v
				   left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
				   left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
				   where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 and v.FecMov <= @FechaAl and v.IB_Anulado<>1
				   group by a.NDoc
				   having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)=0
				   )*/
		-- group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc--,v.Cd_MdRg, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg --<<-- Modificado en Linea 144
		group by c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial, v.NroCta, v.Cd_TD,v.NroSre,v.NroDoc --<<-- Nueva
		having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
		order by NomAux--,v.Cd_TD,v.NroSre, v.NroDoc,FecED,a.NDoc

end
print @msj
/*---PRUEBAS---*/
/*exec pvo.Rpt_CtasXCbr_CCteSaldo7 '20512635025','2009','','','','31/12/2009','01',null*/
--JE : 22/01/2009 : SE CREO ESTE PROCEDIMIENTO PARA AGREGAR EL CAMPO FECHA_AL PARA QUE SE PUEDA VISUALIZAR
--Jesus -> 16-07-2010 : Se agrego la sentencia -> case(Cd_MdRg) when '01' then 'S/.' else 'US$' end as Cd_MdRg
--CAM VIE 17/09/2010 Modificado PR3 RA01 :
--					Eliminacion de la tabla Auxiliar as a
--					Agregada la tabla Cliente2 as c
--					Cambio de parametros @Cd_Aux a @Cd_Clt (char 10)
GO
