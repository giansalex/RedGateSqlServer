SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_MBL]
@RucE nvarchar(11),
@Ejer varchar(4),
@FechaIni datetime,
@FechaFin datetime
as

--Cabecera
select RSocial,Ruc,'Del '+convert(nvarchar,@FechaIni,103)+' al '+ convert(nvarchar,@FechaFin,103)as Fecha from Empresa where Ruc = @RucE

select 
	FecMov as Fecha,
	Agente,
	TipoLinea +'-'+ Linea as Tipo,
	Nave,
	MBL,
	Consig as Consignatario,
	ETA,
	Peso,
	Volumen,
	isnull(Total,0) as [Total Flete],
	isnull(PagoNaviera,0) as [Pago Naviera],
	isnull(PagoAgente,0) as [Pago Agente],
	isnull(Total,0)-isnull(PagoNaviera,0)-isnull(PagoAgente,0) as Ganancia
from(
	select 
	 mbl.FecMov,Case when Isnull(Len(Max(Agente)),0)=0 then '--Sin Agente--' else Max(Agente) end As Agente, mbl.TipoLinea,mbl.Linea,mbl.Nave,mbl.MBL,mbl.Consig,mbl.Peso,mbl.Volumen,mbl.Total
	 ,MAX(ETA) As ETA
	from(	
		  select 
		  convert(varchar,c.FecMov,103) as FecMov,
		  case when Isnull(c.CA20,'')='Agente' then case(isnull(len(p.RSocial),0)) when 0 then p.ApPat +' '+ p.ApMat +' '+ p.Nom 
		  else p.RSocial end else null end As Agente,
		  MAX(c.CA02)as TipoLinea,
		  MAX(c.CA03)as Linea,
		  MAX(c.CA10) as Nave,
		  c.CA01 as MBL,
		  'Varios' as Consig,
		  MAX(c.CA13) as ETA,
		  Isnull(SUM(cast(v.CA04 as decimal(12,3))),0) As Peso,
		  Isnull(SUM(cast(v.CA05 as decimal(12,3))),0) As Volumen,
		  ISnull(SUM(case when isnull(v.IGV,0) = 0 then v.Total else 0 end),0) as Total--,
		  --sum(v.Total) as Total
		  
		  from 
			Compra c
			left join proveedor2 p on p.RucE = c.RucE and c.cd_prv = p.cd_prv
			left join venta v on v.RucE = c.RucE and v.Eje = c.Ejer and c.CA01 = v.CA01
			left join cliente2 clt on clt.RucE = c.RucE and clt.Cd_clt = v.Cd_clt
			left join vendedor2 vdr on vdr.RucE = c.RucE and vdr.cd_Vdr = v.cd_vdr
		  where 
			c.RucE = @RucE and 
			c.Ejer = @Ejer and c.CA20 in('Naviera','Agente')
			--and isnull(c.CA20,'')='Agente'
			--c.Ejer = @Ejer and c.CA20 like '%Agente%'
		group by c.CA01,c.FecMov,c.CA20,p.RSocial,p.ApMat,p.ApPat,p.Nom
	) as mbl 
	group by mbl.FecMov,mbl.TipoLinea,mbl.Linea,mbl.Nave,mbl.MBL,mbl.Consig,mbl.Peso,mbl.Volumen,mbl.Total
) As tabla1
left join (		 
		select 
			Isnull(d.PagoNaviera,0) As PagoNaviera,
			Isnull(e.PagoAgente,0) As PagoAgente,
			d.CA01 
		from (
			select 
				Total as PagoNaviera,
				CA01 
			from 
				compra 
			where 
				RucE=@RucE and 
				Ejer=@Ejer and 
				CA20='Naviera') as d left join (
				select 
					Total as PagoAgente,
					CA01 
				from 
					compra 
				where 
					RucE=@RucE and 
					Ejer=@Ejer and 
					CA20='Agente'
				) as e on e.CA01=d.CA01
		) as tabla2 on tabla2.CA01=tabla1.MBL

where FecMov between @FechaIni and @FechaFin
order by ETA


select '' as Fecha,'' as Agente, '' as Tipo, '' as Nave, '' as MBL, '' as Consignatario, '' as ETA,'' As Peso, '' As Volumen, '' as [Total Flete], '' as [Pago Naviera], '' as [Pago Agente],'' as Ganancia
--Creacion
--JA: 14/06/2011  Creacion del SP
--JJ: 15/06/2011  Correcion del SP
--Prueba
--select * from Compra where CA01 like '%888%'
--Exec Rpt_MBL '88888888888','2011','01/10/2011','30/11/2011'
GO
