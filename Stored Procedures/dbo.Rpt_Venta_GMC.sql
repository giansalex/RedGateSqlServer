SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_GMC]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as 
begin
	/*================================================================================================*/
	/*REPORTE VENTA*/
	/*================================================================================================*/
	select top 1
	        ------------------------------------------------------------------------------------------------------
	        --Datos Fecha--
		day(ve.FecMov) as dd,
		datename(month,ve.FecMov) as mm,
		year(ve.FecMov)as aaaa,
		convert(char,ve.FecCbr,103) as FecCbr,		
		--Datos Cliente--
		case(isnull(len(cl.RSocial),0)) when 0 then cl.ApPat+' '+cl.ApMat+' '+cl.Nom else cl.RSocial end as RSocialCli,
	       	cl.NDoc as NDocCli,
               	cl.Direc as DirecCli,
	       	--Datos Venta--
		ve.CA01,
		ve.Obs,
		Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then (isnull(BIM_Neto,0)+isnull(EXO_Neto,0)+isnull(INF_Neto,0)+isnull(EXPO_Neto,0))/**ve.CamMda*/ else isnull(BIM_Neto,0)+isnull(EXO_Neto,0)+isnull(INF_Neto,0)+isnull(EXPO_Neto,0) end) else '0.00' end as BIM_Vta,		
	 	Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then ve.IGV/**ve.CamMda*/ else ve.IGV end) else '0.00' end as IGV_Vta,	
		Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then ve.Total/**ve.CamMda*/ else ve.Total end) else '0.00' end as Total_Vta, 
		Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then ve.CamMda else '0.000' end) else '0.000' end as CamMda ,
		Case(IB_Anulado)  when 0 then vd.Cant else '0.00' end as Cant,
		vd.Descrip as NomProd,
		Case(IB_Anulado) when 0 then vd.PU else '0.00' end as PUnit, 
		Case(IB_Anulado)  when 0 then '' else 'ANULADO' end as Letra,
		ve.FecMov as FecMov,
	        --Datos Monedas--
                ve.Cd_Mda,mo.Simbolo,mo.Nombre as NomMoneda,
		--------------
		ve.IB_Anulado
		
	from Venta ve
	--Datos Cliente--
	left join Cliente2 cl on cl.RucE=ve.RucE and cl.Cd_Clt=ve.Cd_Clt
	--Datos Venta--
	left join VentaDet vd on ve.RucE=vd.RucE and ve.Cd_Vta = vd.Cd_Vta
	--select * from VentaDet 
	--Datos moneda--
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
	where ve.RucE=@RucE /*and Eje=@Eje */and ve.Cd_Vta=@Cd_Vta --and ve.IB_Anulado=0
	order by vd.Nro_RegVdt
	
end
print @msj
-- exec dbo.Rpt_Venta_GMC '20504743561','2010','VT00000005',null
-- JJ: 2010-08-23:  Modificacion del SP Se Modificio Consulta RA01

GO
