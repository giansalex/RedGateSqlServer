SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXCbr_EstCtaAmb4]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Clt char(10),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@FechaAl smalldatetime,
@msj varchar(100) output
as

/*select * from empresa where RSocial like '%CONTA%'
select * from auxiliar where NDoc='20109714039' and RucE='20512635025'

Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @Cd_Aux nvarchar(7)
Declare @NroCta1 nvarchar(10)
Declare @NroCta2 nvarchar(10)
Declare @FechaAl smalldatetime
Declare @Cd_Mda nvarchar(2)

Set @RucE='20512635025'
Set @Ejer='2009'
Set @Cd_Aux=''--'CLT0109'
Set @NroCta1=''
Set @NroCta2=''
Set @FechaAl='31/12/2009'
Set @Cd_Mda='01'*/

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
			-- isnull(a.NDoc,'No identificado') as NDoc, --<<-- Modificado en linea 43
			isnull(c.NDoc,'No identificado') as NDoc, --<<-- Nueva
			--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux, --<<-- Modificado en linea 45
			isnull(c.RSocial,(isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))) as NomAux, --<<-- Nueva
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc, 
			--convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,
			sum(v.MtoD)as Debe,sum(v.MtoD_ME)as Debe_ME, 
			sum(v.MtoH)as Haber,sum(v.MtoH_ME)as Haber_ME
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux --<<-- Modificado en linea 54
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer

		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Clt= @Cd_Clt and /*(v.FecMov <= @FechaAl)*/ convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		

		/*where 	
			v.RucE=@RucE and v.Ejer=@Ejer 
			and (v.NroCta between @NroCta1 and @NroCta2) 
			and v.Cd_Aux= @Cd_Aux and v.FecMov <= @FechaAl 
			and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' 
			and v.NroDoc not in 
			(select v.NroDoc from voucher as v
				left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
				left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
				where 	v.RucE=@RucE and v.Ejer=@Ejer and 
				(v.NroCta between @NroCta1 and @NroCta2) and 
				p.IB_CtasXCbr=1 and v.FecMov <= @FechaAl and 
				v.IB_Anulado<>1 and v.Cd_Aux= @Cd_Aux
				group by v.NroDoc
				having (sum(v.MtoD)-sum(v.MtoH))=0
			)*/

		group by 
			-- a.NDoc,a.ApPat,a.ApMat,a.Nom,a.RSocial, --<<-- Modificado en linea 80
			c.NDoc,c.ApPat,c.ApMat,c.Nom,c.RSocial, --<<-- Nueva
			v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov
		--having sum(v.MtoD)-sum(v.MtoH)<>0
		-- order by a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov --<<-- Modificado en linea 84
		order by c.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov --<<-- Nueva

end
else -- No tiene aux
begin
		select 	
			-- isnull(a.NDoc,'No identificado') as NDoc,  --<<-- Modificado en linea 91
			isnull(c.NDoc,'No identificado') as NDoc, --<<-- Nueva
			-- isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux, --<<-- Modificado en linea 93
			isnull(c.RSocial,(isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,''))) as NomAux, --<<-- Nueva
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc, 
			--convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,
			sum(v.MtoD)as Debe,sum(v.MtoD_ME)as Debe_ME, 
			sum(v.MtoH)as Haber,sum(v.MtoH_ME)as Haber_ME
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux --<<-- Modificado en linea 102
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Aux=v.Cd_Aux
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		

		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and /*(v.FecMov <= @FechaAl)*/ convert(varchar,v.FecMov,102) <= convert(varchar,@FechaAl,102) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'


		--where 	
			--v.RucE=@RucE and v.Ejer=@Ejer 
			--and (v.NroCta between @NroCta1 and @NroCta2) 
			/*and v.Cd_Aux= @Cd_Aux*/ --and v.FecMov <= @FechaAl 
			--and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1' 
			/*and v.NroDoc not in
			(select v.NroDoc from voucher as v
				left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
				left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
				where 	v.RucE=@RucE and v.Ejer=@Ejer and 
				(v.NroCta between @NroCta1 and @NroCta2) and 
				p.IB_CtasXCbr=1 and v.FecMov <= @FechaAl and 
				v.IB_Anulado<>1 --and v.Cd_Aux= @Cd_Aux
				group by v.NroDoc
				having (sum(v.MtoD)-sum(v.MtoH))=0
			)*/

		group by 
			-- a.NDoc,a.ApPat,a.ApMat,a.Nom,a.RSocial, --<<-- Modificado en linea 129
			c.NDoc,c.ApPat,c.ApMat,c.Nom,c.RSocial,
			v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov
		--having sum(v.MtoD)-sum(v.MtoH)<>0
		-- order by a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov --<<-- Modificado en linea 133
		order by c.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc,v.FecMov --<<-- Nueva

end
--Pruebas:

--exec pvo.Rpt_CtasXCbr_EstCtaAmb4 '11111111111','2010','','','','29/09/2010',null
--PV: VIE 05/06/2009 : CREADO
--J : JUE 06/08/2009 : MODIFICADO
--J y D : MIE 06/01/2010 : MODICADO LAS CONSULTAS (Having y el Where)
--CAM VIE 17/09/2010 Modificado PR03 AR01:
--					Se elimino la tabla Auxiliar
--					Se agrego la tabla Cliente2
--					Se cambio el parametro @Cd_Aux por @Cd_Clt

print @msj

GO
