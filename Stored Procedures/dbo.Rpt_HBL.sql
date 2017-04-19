SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_HBL]
@RucE nvarchar(11),
@Ejer varchar(4),
@FechaIni datetime,
@FechaFin datetime,
@Cd_Clt nvarchar(10)
as

--Cabecera
select RSocial,Ruc,'Del '+convert(nvarchar,@FechaIni,103)+' al '+ convert(nvarchar,@FechaFin,103)as Fecha from Empresa where Ruc = @RucE


--Detalle
select 
	HBL.FecMov as Fecha,
	Case(Isnull(len(p.RSocial),0))  when 0 then Isnull(p.ApPat,'')+' '+Isnull(p.ApMat,'')+', '+Isnull(p.Nom,'') else Isnull(p.RSocial,'') end As Agente,
	HBL.TipoLinea, HBL.Linea,HBL.NaveEmbarque,HBL.NaveTransborde,
	HBL.CA02 HBL,Case(Isnull(len(c.RSocial),0))  when 0 then Isnull(c.ApPat,'')+' '+Isnull(c.ApMat,'')+', '+Isnull(c.Nom,'') else Isnull(c.RSocial,'') end As Consignatario,
	Convert(varchar,HBL.ETA,103) As ETA,HBL.TipoF
	,isnull(Totales.Flete,0) as Flete
	,isnull(Totales.Handli,0) as Handli
	,HBL.Peso,HBL.Volumen,
	HBL.CA01 MBL,
	Case when ISNULL(HBL.Cd_Vdr,'')='' then null else Case(Isnull(len(vend.RSocial),0))  when 0 then Isnull(vend.ApPat,'')+' '+Isnull(vend.ApMat,'')+', '+Isnull(vend.Nom,'') else Isnull(vend.RSocial,'') end End As Vendedor
from(
	select
		c.RucE,Convert(varchar,c.FecMov,103) FecMov,
		c.CA02 As TipoLinea,c.CA03 As Linea,c.CA10 As NaveEmbarque,c.CA11 As NaveTransborde,
		Convert(datetime,c.CA13) As ETA,
		c.Cd_Prv,v.Cd_Clt,v.Cd_Vdr,v.CA01,v.CA02 ,v.CA03 as TipoF,Isnull(cast(v.CA04 as decimal(13,2)),0) Peso,Isnull(cast(v.CA05 as decimal(13,2)),0) Volumen,v.CA06,v.CA07,v.CA08,v.CA09,v.CA10,v.CA11,v.CA12,v.CA13,v.CA14,v.CA15,
		v.CA16,v.CA17,v.CA18,v.CA19,v.CA20,v.CA21,v.CA22,v.CA23,v.CA24,v.CA25
	from 
		Venta v inner join
		compra c on c.RucE=v.RucE and c.Ejer=v.Eje and c.CA01=v.CA01 and c.CA20='Agente'
	where 
		v.RucE=@RucE and v.Eje=@Ejer
		and case when ISNULL(@Cd_Clt,'')<>'' then v.Cd_Clt else '' end = ISNULL(@Cd_Clt,'')
) As HBL
left join proveedor2 p on p.RucE=HBL.RucE and p.Cd_Prv=HBL.Cd_Prv
left join Cliente2 c on c.RucE=HBL.RucE and c.Cd_Clt=HBL.Cd_Clt
left join vendedor2 vend on vend.RucE=HBL.RucE and vend.Cd_Vdr=HBL.Cd_Vdr
left join 
(
				select Flete,Handli,p.cd_clt,p.CA01,p.CA02 from 
				(
					select
					RucE,
					Eje, 
					isnull(Total,0) as Flete,
					cd_clt,
					CA01,
					CA02
					from 
					venta where RucE = @RucE and Eje = @Ejer and /*CA01 = @MBL and*/ IGV is null
				) as p
				left join
				(
					select
					RucE,
					Eje, 
					isnull(Total,0) as Handli,
					cd_clt,
					CA01,
					CA02
					from 
					venta where RucE = @RucE and Eje = @Ejer and /*CA01 = @MBL and*/ IGV is not null
				) as p1  on p1.RucE=p.RucE  and p1.Eje=p.Eje and  p1.cd_Clt = p.cd_clt
)Totales on HBL.CA02 = Totales.CA02
where Convert(varchar,HBL.ETA,103) between Convert(varchar,@FechaIni,103) and Convert(varchar,@FechaFin,103)
order by ETA

select '' As Fecha,'' As Agente, '' As TipoLinea, '' As Linea, '' as NaveEmbarque,'' as NaveTransborde,
'' as HBL, '' as Consignatario, '' as ETA, '' as TipoF
,0.0 as Flete
,0.0 as Handli
, 0.0 as Peso, 0.0 as Volumen, '' MBL, '' as Vendedor
--select 
--	*
--from(
--	select 
--	MAx(Fecha) as Fecha,
--	Max(case when isnull(ca20,'') = 'Agente' then Agente else '' end) as Agente,
--	Max(Tipo) as Tipo,
--	Max(Nave) as Nave,
--	HBL,
--	Max(Consig) as Consignatario, 
--	max(ETA) as ETA,
--	max(TipoF) as TipoF,
--	max(Flete)as Flete,
--	max(Handli) as Handli, 
--	max(Peso) as Peso,
--	max(Volumen) as Volumen,
--	max(Vendedor) as Vendedor


--	from 
--	(
--			select
--			Fecha,
--			Proveedor as Agente,
--			TipoLinea + '-' + Linea as Tipo,
--			NaveEmbarque as Nave,
--			HBL,
--			Cliente as Consig,
--			ETA,
--			TipoF,
--			Flete,
--			Handli,
--			Peso,
--			Volumen,
--			Cd_Prv,CA20,
--			Vendedor
--			from
--			(
--				select 
--				Convert(nvarchar,max(c.Fecmov),103) as Fecha,
--				case(isnull(len(p.RSocial),0)) when 0 then p.ApPat +' '+ p.ApMat +' '+ p.Nom else p.RSocial end as Proveedor,
--				max(c.CA02) as TipoLinea,
--				max(c.CA03) as Linea,
--				max(c.CA08) as NaveEmbarque,
--				max(c.CA08) as NaveTransborde,
--				v.CA02 as HBL,
--				case(isnull(len(clt.RSocial),0)) when 0 then clt.ApPat +' '+ clt.ApMat +' '+ clt.Nom else clt.RSocial end as Cliente,
--				max(c.CA11) as ETA,
--				max(v.CA06) as TipoF,
--				max(v.CA04) as Peso,
--				max(v.CA05) as Volumen,
--				c.Cd_Prv,
--				max(c.CA20) as CA20,
--				case(isnull(len(max(vdr.RSocial)),0)) when 0 then max(vdr.ApPat) +' '+ max(vdr.ApMat) +' '+ max(vdr.Nom) else max(vdr.RSocial) end as Vendedor
--				--max(v.cd_clt) as Cd_Clt
--				--,mAX(c.ca01) as MBL


--				from Venta v
--				inner join Compra c on c.RucE = v.RucE and c.Ejer = v.Eje and c.CA01 = v.CA01
--				inner join proveedor2 p on p.RucE = c.RucE and p.cd_prv = c.Cd_Prv
--				inner join cliente2 clt on clt.RucE = c.RucE and clt.Cd_clt = v.Cd_clt
--				inner join vendedor2 vdr on vdr.RucE = c.RucE and vdr.cd_Vdr = v.cd_vdr
--				where c.RucE = @RucE 
--				and c.Ejer = @Ejer 
--				and case when ISNULL(@Cd_Clt,'')<>'' then clt.Cd_Clt else '' end = ISNULL(@Cd_Clt,'')
--				/*and c.CA01 = @MBL */ --and c.CA16 = 'Agente'
--				--and convert(nvarchar,c.CA11,103) between convert(nvarchar,@FechaIni,103) and convert(nvarchar,@FechaFin,103)
--				--group by clt.Rsocial,clt.ApPat,clt.ApMat,clt.Nom,p.ApMat,p.ApPat,p.Nom,p.RSocial,v.CA02,
--				--		vdr.RSocial,vdr.ApMat,vdr.ApPat,vdr.Nom
--				group by v.CA02,clt.Rsocial,clt.ApPat,clt.ApMat,clt.Nom ,c.Cd_Prv,p.ApMat,p.ApPat,p.Nom,p.RSocial
--			) as tabla1


--			inner join
--			(
--				select Flete,Handli,p.cd_clt,p.CA01,p.CA02 from 
--				(
--					select
--					RucE,
--					Eje, 
--					Total as Flete,
--					cd_clt,
--					CA01,
--					CA02
--					from 
--					venta where RucE = @RucE and Eje = @Ejer and /*CA01 = @MBL and*/ IGV is null
--				) as p
--				left join
--				(
--					select
--					RucE,
--					Eje, 
--					Total as Handli,
--					cd_clt,
--					CA01,
--					CA02
--					from 
--					venta where RucE = @RucE and Eje = @Ejer and /*CA01 = @MBL and*/ IGV is not null
--				) as p1  on p1.RucE=p.RucE  and p1.Eje=p.Eje and  p1.cd_Clt = p.cd_clt
--			)as tabla2
--			on tabla1.HBL = tabla2.CA02
--	) as t
--	group by HBL
--) as t
--where Convert(datetime,t.ETA) between @FechaIni and @FechaFin
--order by Convert(datetime,t.ETA)


--------------Totales----------
--select '' as Fecha,'' as Agente, '' as Tipo, '' as Nave,'' as HBL, '' as Consignatario, '' as ETA, '' as TipoF, '' as Flete, '' as Handli, '' as Paso, '' as Volumen, '' as Vendedor

--Creacion
--JA: 14/06/2011  Creacion del SP
--Prueba
--Exec Rpt_HBL '888888888888','2011','01/01/2011','30/11/2011',''
--select CA01,CA02 from Venta where CA01 like '%MB4545%'
GO
