SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_TotalVentaXCliente]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FecIni DateTime,
@FecFin DateTime,
@Cd_Mda nvarchar(2)
as
--set @RucE ='11111111111'
--set @Eje ='2012'
--set @FecIni ='01/01/2012'
--set @FecFin ='30/04/2012'
--set @Cd_Mda ='01'

	select
	Max(v.RucE) as RucE, Max(e.RSocial) as RSocial,
	Max(Convert(nvarchar,@FecIni,103)+' al '+Convert(nvarchar,@FecFin,103)) as Fecha,
	max(c2.Cd_TDI) as Cd_TDI, max(c2.NDoc) as NDocCte,
	max(case(IB_Anulado)  when 0 then  '' else '(ANULADO) - ' end + case(isnull(len(c2.RSocial),0)) when 0 then isnull(c2.ApPat,'')+' '+isnull(c2.ApMat,'')+' '+isnull(c2.Nom,'') else isnull(c2.RSocial,'') end) as NomCli,--<<--Nueva
	--sum(v.BIM_Neto) as BIM,
	sum(case @Cd_Mda when '01' then case v.Cd_Mda when '01' then case v.Cd_TD when '07' then -1*v.BIM_Neto else v.BIM_Neto end
												  when '02' then cast((case v.Cd_TD when '07' then -1*v.BIM_Neto else BIM_Neto end)*v.CamMda as decimal(15,2)) end
												  
					 when '02' then case v.Cd_Mda when '01' then cast((case v.Cd_TD when '07' then -1*v.BIM_Neto else BIM_Neto end)/v.CamMda as decimal(15,2)) 
												  when '02' then case v.Cd_TD when '07' then -1*v.BIM_Neto else BIM_Neto end  end end) as BIM
		
	--sum(v.EXO_Neto) as EXO,
	,sum(case @Cd_Mda when '01' then case v.Cd_Mda when '01' then case v.Cd_TD when '07' then -1*v.EXO_Neto else v.EXO_Neto end
												  when '02' then cast((case v.Cd_TD when '07' then -1*v.EXO_Neto else v.EXO_Neto end)*v.CamMda as decimal(15,2)) end
												  
					 when '02' then case v.Cd_Mda when '01' then cast((case v.Cd_TD when '07' then -1*v.EXO_Neto else v.EXO_Neto end)/v.CamMda as decimal(15,2)) 
												  when '02' then case v.Cd_TD when '07' then -1*v.EXO_Neto else v.EXO_Neto end  end end) as EXO
												  
	--sum(v.INF_Neto) as INF,
	,sum(case @Cd_Mda when '01' then case v.Cd_Mda when '01' then case v.Cd_TD when '07' then -1*v.INF_Neto else v.INF_Neto end
												  when '02' then cast((case v.Cd_TD when '07' then -1*v.INF_Neto else v.INF_Neto end)*v.CamMda as decimal(15,2)) end
												  
					 when '02' then case v.Cd_Mda when '01' then cast((case v.Cd_TD when '07' then -1*v.INF_Neto else v.INF_Neto end)/v.CamMda as decimal(15,2)) 
												  when '02' then case v.Cd_TD when '07' then -1*v.INF_Neto else v.INF_Neto end  end end) as INF
												  
	--sum(v.IGV) as IGV,
	,sum(case @Cd_Mda when '01' then case v.Cd_Mda when '01' then case v.Cd_TD when '07' then -1*v.IGV else v.IGV end
												  when '02' then cast((case v.Cd_TD when '07' then -1*v.IGV else v.IGV end)*v.CamMda as decimal(15,2)) end
												  
					 when '02' then case v.Cd_Mda when '01' then cast((case v.Cd_TD when '07' then -1*v.IGV else v.IGV end)/v.CamMda as decimal(15,2)) 
												  when '02' then case v.Cd_TD when '07' then -1*v.IGV else v.IGV end  end end) as IGV
												  
	,sum(case @Cd_Mda when '01' then case v.Cd_Mda when '01' then case v.Cd_TD when '07' then -1*v.Total else v.Total end
												  when '02' then cast((case v.Cd_TD when '07' then -1*v.Total else v.Total end)*v.CamMda as decimal(15,2)) end
												  
					 when '02' then case v.Cd_Mda when '01' then cast((case v.Cd_TD when '07' then -1*v.Total else v.Total end)/v.CamMda as decimal(15,2)) 
												  when '02' then case v.Cd_TD when '07' then -1*v.Total else v.Total end  end end) as Total
	from Venta v, Empresa e,
	Cliente2 c2, --<<-- Nueva
	TipDocIdn ti
	where v.RucE=@RucE and v.Eje=@Ejer and v.FecMov between @FecIni and @FecFin and isnull(v.IB_Anulado,0)<>1 --and v.Cd_Mda = @Cd_Mda
	and v.RucE=e.Ruc and
	v.RucE=c2.RucE and --<<-- Nueva
	v.Cd_Clt=c2.Cd_Clt and c2.Cd_TDI=ti.Cd_TDI --<<-- Nueva
	group by 
	v.RucE,e.RSocial,
	c2.Cd_TDI, c2.NDoc
--Creado
--Javier
--Modificado <<19/04/2012>>
--Modificado <<03/11/2012>> // se modifico para que descuente las notas de credito.




--
GO
