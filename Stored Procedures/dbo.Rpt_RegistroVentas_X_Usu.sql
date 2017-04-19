SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_RegistroVentas_X_Usu]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Rprdo1 nvarchar(2),
@Rprdo2 nvarchar(2),
@Cd_Mda nvarchar(2), --Servira para intercambio de moneda
@msj varchar(100) output
as
begin

select
	---------------------- VENTA -------------------------
	--====================================================
	
	v.RucE, e.RSocial, --v.Prdo +'  -  '+v.Eje as Prdo, 

	--@RPrdo1+' - '+@RPrdo2+' del '+v.Eje as Prdo,
	
		v.RegCtb,
	Convert(nvarchar,v.FecMov,103) as FecED,
	--v.FecED,
	v.FecVD, 

	v.Cd_TD, v.NroSre as NroSerie, v.NroDoc,

	-- ca.Cd_TDI, ca.NDoc as NDocCte, --<<-- Modificado en linea 27
	c2.Cd_TDI, c2.NDoc as NDocCte, --<<-- Nueva
	case(IB_Anulado)  when 0 then  '' else '(ANULADO) - ' end +
	/*case(isnull(len(ca.RSocial),0))
	     when 0 then ca.ApPat+' '+ca.ApMat+' '+ca.Nom else ca.RSocial end as NomCli,*/--<<-- Modificado linea 31
	case(isnull(len(c2.RSocial),0))--<<-- Nueva
	     when 0 then c2.ApPat+' '+c2.ApMat+' '+c2.Nom else c2.RSocial end as NomCli, --<<-- Nueva
	
	/*v.BIM, v.EXO, v.INF, v.IGV, v.Total,*/v.UsuCrea as Grupo,@Rprdo1+' - '+@Rprdo2+' del '+@Eje as Prdo, --v.CamMda
		
	--Modificar--
	 --Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then v.BIM_Neto*v.CamMda else v.BIM_Neto end) else '0.00' end as BIM,	
	 --Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then v.EXO_Neto*v.CamMda else v.EXO_Neto end) else '0.00' end as EXO,
	 --Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then v.INF_Neto*v.CamMda else v.INF_Neto end) else '0.00' end as INF,
	 --Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then v.IGV*v.CamMda else v.IGV end) else '0.00' end as IGV,	
  --   Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then v.Total*v.CamMda else v.Total end) else '0.00' end as Total, 
  	 Case(IB_Anulado)  when 0 then ( cast(case(v.Cd_Mda) when '02' then v.BIM_Neto*v.CamMda else v.BIM_Neto end as decimal(13,2))) else '0.00' end as BIM,	
	 Case(IB_Anulado)  when 0 then ( cast(case(v.Cd_Mda) when '02' then v.EXO_Neto*v.CamMda else v.EXO_Neto end as decimal(13,2))) else '0.00' end as EXO,
	 Case(IB_Anulado)  when 0 then ( cast(case(v.Cd_Mda) when '02' then v.INF_Neto*v.CamMda else v.INF_Neto end as decimal(13,2))) else '0.00' end as INF,
	 Case(IB_Anulado)  when 0 then ( cast(case(v.Cd_Mda) when '02' then v.IGV*v.CamMda else v.IGV end as decimal(13,2))) else '0.00' end as IGV,	
     Case(IB_Anulado)  when 0 then ( cast(case(v.Cd_Mda) when '02' then v.Total*v.CamMda else v.Total end as decimal(13,2))) else '0.00' end as Total, 
	 Case(IB_Anulado)  when 0 then ( case(v.Cd_Mda) when '02' then v.CamMda else '0.000' end) else '0.000' end as CamMda  

        	--Case(IB_Anulado)  when 0 then  v.BIM else '0.00' end as BIM,	
        	--Case(IB_Anulado)  when 0 then  v.EXO else '0.00' end as EXO,
		--Case(IB_Anulado)  when 0 then  v.INF else '0.00' end as INF,
        	--Case(IB_Anulado)  when 0 then  v.IGV else '0.00' end as IGV,	 
        	--Case(IB_Anulado)  when 0 then  v.Total else '0.00' end as Total,      
        	--Case(IB_Anulado)  when 0 then  v.CamMda else '0.000' end as CamMda       
	------------------------------------------------------------------------ 
	,convert(varchar,v.DR_FecED,103) as FecR,v.DR_CdTD as TDR,v.DR_NSre as NSreR,v.DR_NDoc as NDocR
	,Case(v.IB_Anulado) when 0 then Case(v.Cd_Mda) when '01' then 0.00 else v.BIM_Neto end else 0.00 end as EXO_ME
	from Venta v, Empresa e, /*Serie s,*/
	-- Cliente c, Auxiliar ca --<<-- Modificado linea 55
	Cliente2 c2 --<<-- Nueva 
	where v.RucE=@RucE and  v.Eje=@Eje and v.Prdo >= @Rprdo1 and v.Prdo <= @Rprdo2 and v.RucE=e.Ruc /*and v.RucE=s.RucE and v.Cd_Sr=s.Cd_Sr*/ and 
	-- v.RucE=c.RucE and  --<<-- Modificado en linea 58
	v.RucE=c2.RucE and --<<-- Nueva
      	-- v.Cd_Cte=c.Cd_Aux and c.RucE=ca.RucE and c.Cd_Aux=ca.Cd_Aux --and v.IB_Anulado<>1 --<<-- Modificado en linea
	v.Cd_Clt=c2.Cd_Clt --<<-- Nueva
order by v.UsuCrea asc
end
print @msj

--Leyenda
--Creado por: no Dice.

--CAM 20/09/2010 Modificado RA01 : Se quito Auxiliar y Cliente. Se agrego Cliente2

--exec Rpt_RegistroVentas_X_Usu '11111111111','2010','01','09','01',''
--sp_help Rpt_RegistroVentas_X_Usu



GO
