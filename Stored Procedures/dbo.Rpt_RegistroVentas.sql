SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_RegistroVentas]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Rprdo1 nvarchar(2),
@Rprdo2 nvarchar(2),
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as
begin
select
	---------------------- VENTA -------------------------
	--====================================================
	
	v.RucE, e.RSocial, --v.Prdo +'  -  '+v.Eje as Prdo, 

	@RPrdo1+' - '+@RPrdo2+' del '+@Eje as Prdo,
	
	v.RegCtb, 
	Convert(nvarchar,v.FecMov,103) as FecED,
	--v.FecED,
	 v.FecVD, 

	v.Cd_TD, s.NroSerie, v.NroDoc,

	ca.Cd_TDI, ca.NDoc as NDocCte,
	
	/*case(isnull(len(ca.RSocial),0))
		when 0 then	case(v.IB_Anulado)
					when 0 then ca.ApPat+' '+ca.ApMat+' '+ca.Nom
					else 'ANULADO'
				end
		else 	case(v.IB_Anulado)
					when 0 then ca.RSocial
					else 'ANULADO'
				end
	end as NomCli,*/


	case(v.IB_Anulado)  when 0 then  '' else '(ANULADO) - ' end +
	case(ca.RSocial)
	     when null then ca.ApPat+' '+ca.ApMat+' '+ca.Nom
	     when '' then ca.ApPat+' '+ca.ApMat+' '+ca.Nom
	     else ca.RSocial end as NomCli,
	
	
	--v.BIM, v.EXO, v.INF, v.IGV, v.Total, v.CamMda

	--Modificar--

	 Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then v.BIM*v.CamMda else v.BIM end) else '0.00' end as BIM,	
	 Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then v.EXO*v.CamMda else v.EXO end) else '0.00' end as EXO,
	 Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then v.INF*v.CamMda else v.INF end) else '0.00' end as INF,
	 Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then v.IGV*v.CamMda else v.IGV end) else '0.00' end as IGV,	
    	 Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then v.Total*v.CamMda else v.Total end) else '0.00' end as Total, 
	 Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then convert(varchar,v.CamMda) else'0.000' end) else '0.000' end as CamMda  
	 --Case(IB_Anulado)  when 0 then  v.BIM else '0.00' end as BIM,	
       	 --Case(IB_Anulado)  when 0 then  v.EXO else '0.00' end as EXO,
	 --Case(IB_Anulado)  when 0 then  v.INF else '0.00' end as INF,
       	 --Case(IB_Anulado)  when 0 then  v.IGV else '0.00' end as IGV,	 
       	 --Case(IB_Anulado)  when 0 then  v.Total else '0.00' end as Total,      
         --Case(IB_Anulado)  when 0 then  v.CamMda else '0.000' end as CamMda       
	------------------------------------------------------------------------  
	,convert(varchar,v.DR_FecED,103) as FecR,v.DR_CdTD as TDR,v.DR_NSre as NSreR,v.DR_NDoc as NDocR
	,Case(v.IB_Anulado) when 0 then Case(v.Cd_Mda) when '01' then 0.00 else v.BIM end else 0.00 end as EXO_ME
from Venta v, Empresa e, Serie s, Cliente c, Auxiliar ca
where v.RucE=@RucE and v.Eje=@Eje and v.Prdo >= @Rprdo1 and v.Prdo <= @Rprdo2 and v.RucE=e.Ruc and v.RucE=s.RucE and v.Cd_Sr=s.Cd_Sr and v.RucE=c.RucE and 
      v.Cd_Cte=c.Cd_Aux and c.RucE=ca.RucE and c.Cd_Aux=ca.Cd_Aux --and v.IB_Anulado<>1
order by 3 asc
end
print @msj
------CODIGO DE MODIFICACION--------
--CM=MG01
GO
