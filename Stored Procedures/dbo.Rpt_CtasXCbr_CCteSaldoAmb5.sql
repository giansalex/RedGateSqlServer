SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXCbr_CCteSaldoAmb5]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Clt char(10),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@FechaAl smalldatetime,
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
			-- isnull(a.NDoc,'No identificado') as NDocAux, --<<-- Modificado en Linea 25
			isnull(c.NDoc,'No identificado') as NDocAux, --<<-- Nueva
			-- isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux, --<<-- Modificado en Linea 27
			isnull(c.RSocial,(isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))) as NomAux, --<<-- Nueva
			v.NroCta,
			isnull(v.Cd_TD,'') as Cd_TD,isnull(v.NroSre,'') as NroSre,isnull(v.NroDoc,'') as NroDoc,
						
			-- DESPUES (MEJORA)
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED,
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD,
			--sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,v.FecCbr) else 0 end) as Saldo_Dias,  
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,  		

			sum(v.MtoD)Debe, 
			sum(v.MtoH)Haber,
			(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
			sum(v.MtoD_ME) Debe_ME,
			sum(v.MtoH_ME) Haber_ME,		
			(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		
		from voucher as v
		-- left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux --<<-- Modificado en linea 46
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt --<<-- Nueva
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
		left join Empresa as e on e.Ruc=v.RucE
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Clt= @Cd_Clt and /*(v.FecMov <= @FechaAl)*/ convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'

		--where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 /*and v.Cd_Aux= @Cd_Aux*//*==*//*and v.IB_Anulado<>'1'*/ /*and ==*/ and v.FecMov <= @FechaAl and v.IB_Anulado<>1 and v.Cd_Aux= @Cd_Aux
			/*and a.NDoc not in (select 	
							a.NDoc
						from voucher as v
						left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
						left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
						where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 and v.FecMov <= @FechaAl and v.IB_Anulado<>1 and v.Cd_Aux= @Cd_Aux
						group by a.NDoc
						having (sum(v.MtoD)-sum(v.MtoH))=0
					   )*/
		-- group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc --<<-- Modificado en linea 63
		group by c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial, v.NroCta, v.Cd_TD, v.NroSre,v.NroDoc
		having sum(v.MtoD) - sum(v.MtoH) <> 0 or sum(v.MtoD_ME)-sum(v.MtoH_ME)<>0
		order by NomAux
		
end
else
begin
		select 	
			-- isnull(a.NDoc,'No identificado') as NDocAux, --<<-- Modificado en linea 72
			isnull(c.NDoc,'No identificado') as NDocAux, --<<-- Nueva
			-- isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux, --<<-- Modificado en linea 74
			isnull(c.RSocial,(isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))) as NomAux, --<<-- Nueva
			 v.NroCta,
			isnull(v.Cd_TD,'') as Cd_TD,isnull(v.NroSre,'') as NroSre,isnull(v.NroDoc,'') as NroDoc,
			-- DESPUES (MEJORA)
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED,
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD,
			--sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,v.FecCbr) else 0 end) as Saldo_Dias,  
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias, 	
			
			sum(v.MtoD)Debe, 
			sum(v.MtoH)Haber,
			(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
			sum(v.MtoD_ME) Debe_ME,
			sum(v.MtoH_ME) Haber_ME,		
			(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux --<<-- Modificado en linea 92
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
		left join Empresa as e on e.Ruc=v.RucE
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and /*(v.FecMov <= @FechaAl)*/ convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'


		--where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 /*and v.Cd_Aux= @Cd_Aux*//*==*//*and v.IB_Anulado<>'1'*/ /*and ==*/ and v.FecMov <= @FechaAl and v.IB_Anulado<>1
			/*and a.NDoc not in (select 	
							a.NDoc
						from voucher as v
						left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
						left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
						where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 and v.FecMov <= @FechaAl and v.IB_Anulado<>1
						group by a.NDoc
						having (sum(v.MtoD)-sum(v.MtoH))=0
				)*/
		-- group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, v.Cd_TD,v.NroSre,v.NroDoc--, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg --<<-- Modificado en Linea 110
		group by c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial, v.NroCta, v.Cd_TD,v.NroSre,v.NroDoc --<<-- Nueva
		having sum(v.MtoD)-sum(v.MtoH)<>0 or sum(v.MtoD_ME)-sum(v.MtoH_ME)<>0
		order by NomAux

end
--Pruebas:
--exec pvo.Rpt_CtasXPagar_CCteSaldo5 '11111111111','2009','','','','','01',null
--select * from voucher where ruce='11111111111' and nrodoc='121212'

--PV: VIE 05/06/2009 : CREADO
--PV: VIE 03/07/2009 : MODF: se arreglo la No_agrupacion por fecha diferente y los saldos dias
--JS: LUN 02/11/2009 : MODF: se arreglo que el reporte no jale los voucher Anulados
--CAM VIE 17/09/2010 : Modificado PR03 RA01:
--				Se quito la tabla Auxiliar
--				Se agrego la tabla Cliente2
--				Se cambio el parametro @Cd_Aux por @Cd_Clt
print @msj
GO
