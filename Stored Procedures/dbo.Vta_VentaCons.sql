SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaCons]
@RucE nvarchar(11),
@Eje nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@UsuCons nvarchar(10),
@msj varchar(100) output
as
if exists (select top 1 * from Venta where RucE = @RucE and Eje=@Eje) and exists (select * from CampoV where RucE=@RucE)
begin
    exec Vta_TemporalCons @RucE,@PrdoIni,@PrdoFin,null
--//////////////////////////////////////////////
    if @RucE='20518906390' and @UsuCons in ('JANNET','emer1','jguillen','SCUBILLAS','karenp','conta','B.MARIN','FIORE','g.marlene')
    begin
	
	exec (	'select
		--ve.Cd_Vta,
		ve.RegCtb,
		ve.Prdo,
		convert(varchar(10),ve.FecMov,103) as FecMov,
		convert(varchar(10),ve.FecCbr,103) as FecCbr,
		ve.Cd_TD,
		td.Descrip as DescripTD,
		ve.NroDoc,
		se.NroSerie,
		convert(varchar(10),ve.FecED,103) as FecED,
		convert(varchar(10),ve.FecVD,103) as FecVD,
		ca.Cd_TDI as TDIC, dic.NCorto as dTDIC,
		ca.NDoc as Cd_Cte,case(isnull(len(ca.RSocial),0))
		         	     when 0 then ca.ApPat+'' ''+ca.ApMat+'' ''+ca.Nom
		 	     else ca.RSocial end as NomComCte,
		va.Cd_TDI as TDIV, div.NCorto as dTDIV,
		va.NDoc as Cd_Vdr,case(isnull(len(va.RSocial),0))
	    		     when 0 then va.ApPat+'' ''+va.ApMat+'' ''+va.Nom
	    		     else va.RSocial end as NomComVdr,
		ar.NCorto as NCortoArea,
		md.Nombre as NomMR,
		ve.Obs,
		case(ve.IB_Anulado) when 1 then 0 else ve.INF end as INF,
		case(ve.IB_Anulado) when 1 then 0 else ve.EXO end as EXO,
		case(ve.IB_Anulado) when 1 then 0 else ve.BIM end as BIM,
		case(ve.IB_Anulado) when 1 then 0 else ve.IGV end as IGV,
		case(ve.IB_Anulado) when 1 then 0 else ve.Total end as Total,
		mo.Simbolo,
		ve.CamMda,
		ve.IB_Anulado,
		ve.IB_Cbdo as Cobrado,
		tm.*,
		ve.UsuCrea as Usuario,convert(varchar,ve.FecReg,103) AS Fecha,convert(varchar,ve.FecReg,8) AS Hora
	from Venta ve
	left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	left join TipDocIdn dic on dic.Cd_TDI=ca.Cd_TDI
	left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux
	left join TipDocIdn div on div.Cd_TDI=va.Cd_TDI
	left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Modulo md on  ve.Cd_MR=md.Cd_MR
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
	left join Temporal'+@RucE+' tm on ve.cd_Vta=tm.Cd_VtaX 
	where ve.RucE='''+@RucE+''' and ve.Eje='''+@Eje+''' and ve.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''  and SubString(ve.RegCtb,3,2)=''CH'' order by Cd_Vta'
	)
    end
--//////////////////////////////////////////////
    else if (@UsuCons='gigi' or @UsuCons='admin' or @UsuCons in ('PABLO','JANNET','GACOSTA','SESPINOZA','JACKIE','Rocio','JOSELUIS','emer1','diego','jguillen','SCUBILLAS','karenp','conta','B.MARIN','jesus','alzatec','FIORE','g.marlene','B.CECILIA'))
    begin
	Print '1'
	exec (	'select
		--ve.Cd_Vta,
		ve.RegCtb,
		ve.Prdo,
		convert(varchar(10),ve.FecMov,103) as FecMov,
		convert(varchar(10),ve.FecCbr,103) as FecCbr,
		ve.Cd_TD,
		td.Descrip as DescripTD,
		ve.NroDoc,
		se.NroSerie,
		convert(varchar(10),ve.FecED,103) as FecED,
		convert(varchar(10),ve.FecVD,103) as FecVD,
		ca.Cd_TDI as TDIC, dic.NCorto as dTDIC,
		ca.NDoc as Cd_Cte,case(isnull(len(ca.RSocial),0))
		         	     when 0 then ca.ApPat+'' ''+ca.ApMat+'' ''+ca.Nom
		 	     else ca.RSocial end as NomComCte,
		va.Cd_TDI as TDIV, div.NCorto as dTDIV,
		va.NDoc as Cd_Vdr,case(isnull(len(va.RSocial),0))
	    		     when 0 then va.ApPat+'' ''+va.ApMat+'' ''+va.Nom
	    		     else va.RSocial end as NomComVdr,
		ar.NCorto as NCortoArea,
		md.Nombre as NomMR,
		ve.Obs,
		case(ve.IB_Anulado) when 1 then 0 else ve.INF end as INF,
		case(ve.IB_Anulado) when 1 then 0 else ve.EXO end as EXO,
		case(ve.IB_Anulado) when 1 then 0 else ve.BIM end as BIM,
		case(ve.IB_Anulado) when 1 then 0 else ve.IGV end as IGV,
		case(ve.IB_Anulado) when 1 then 0 else ve.Total end as Total,
		mo.Simbolo,
		ve.CamMda,
		ve.IB_Anulado,
		ve.IB_Cbdo as Cobrado,
		tm.*,
		ve.UsuCrea as Usuario,convert(varchar,ve.FecReg,103) AS Fecha,convert(varchar,ve.FecReg,8) AS Hora
	from Venta ve
	left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	left join TipDocIdn dic on dic.Cd_TDI=ca.Cd_TDI
	left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux
	left join TipDocIdn div on div.Cd_TDI=va.Cd_TDI
	left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Modulo md on  ve.Cd_MR=md.Cd_MR
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
	left join Temporal'+@RucE+' tm on ve.cd_Vta=tm.Cd_VtaX 
	where ve.RucE='''+@RucE+''' and ve.Eje='''+@Eje+''' and ve.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' order by Cd_Vta'
	)
    end
    else 
    begin
	Print '2'
	exec (	'select
		--ve.Cd_Vta,
		ve.RegCtb,
		ve.Prdo,
		convert(varchar(10),ve.FecMov,103) as FecMov,
		convert(varchar(10),ve.FecCbr,103) as FecCbr,
		ve.Cd_TD,
		td.Descrip as DescripTD,
		ve.NroDoc,
		se.NroSerie,
		convert(varchar(10),ve.FecED,103) as FecED,
		convert(varchar(10),ve.FecVD,103) as FecVD,
		ca.Cd_TDI as TDIC, dic.NCorto as dTDIC,
		ca.NDoc as Cd_Cte,case(isnull(len(ca.RSocial),0))
		         	     when 0 then ca.ApPat+'' ''+ca.ApMat+'' ''+ca.Nom
		 	     else ca.RSocial end as NomComCte,
		va.Cd_TDI as TDIV, div.NCorto as dTDIV,
		va.NDoc as Cd_Vdr,case(isnull(len(va.RSocial),0))
	    		     when 0 then va.ApPat+'' ''+va.ApMat+'' ''+va.Nom
	    		     else va.RSocial end as NomComVdr,
		ar.NCorto as NCortoArea,
		md.Nombre as NomMR,
		ve.Obs,
		case(ve.IB_Anulado) when 1 then 0 else ve.INF end as INF,
		case(ve.IB_Anulado) when 1 then 0 else ve.EXO end as EXO,
		case(ve.IB_Anulado) when 1 then 0 else ve.BIM end as BIM,
		case(ve.IB_Anulado) when 1 then 0 else ve.IGV end as IGV,
		case(ve.IB_Anulado) when 1 then 0 else ve.Total end as Total,
		mo.Simbolo,
		ve.CamMda,
		ve.IB_Anulado,
		ve.IB_Cbdo as Cobrado,
		tm.*,
		ve.UsuCrea as Usuario,convert(varchar,ve.FecReg,103) AS Fecha,convert(varchar,ve.FecReg,8) AS Hora
	from Venta ve
	left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	left join TipDocIdn dic on dic.Cd_TDI=ca.Cd_TDI
	left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux
	left join TipDocIdn div on div.Cd_TDI=va.Cd_TDI
	left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Modulo md on  ve.Cd_MR=md.Cd_MR
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
	left join Temporal'+@RucE+' tm on ve.cd_Vta=tm.Cd_VtaX 
	where ve.RucE='''+@RucE+''' and ve.Eje='''+@Eje+''' and ve.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and ve.UsuCrea ='''+@UsuCons+'''  order by Cd_Vta'
	)
    end
exec ('DROP TABLE Temporal'+@RucE)
end
else 
begin
    if @UsuCons in('admin','gigi','JANNET','emer1','jguillen','SCUBILLAS','karenp','B.MARIN','Conta','Diego','pablo','jesus','FIORE','g.marlene','B.CECILIA')
    begin
	Print '3'
	select
		ve.Cd_Vta as Cd_VtaX,
		ve.RegCtb,
		ve.Prdo,
		convert(varchar(10),ve.FecMov,103) as FecMov,
		convert(varchar(10),ve.FecCbr,103) as FecCbr,
		td.Descrip as DescripTD,
		ve.Cd_TD,
		se.NroSerie,
		ve.NroDoc,
		convert(varchar(10),ve.FecED,103) as FecED,
		convert(varchar(10),ve.FecVD,103) as FecVD,
		ca.Cd_TDI as TDIC, dic.descrip as dTDIC,
		ve.Cd_Cte,case(isnull(len(ca.RSocial),0))
		         	     when 0 then ca.ApPat+' '+ca.ApMat+' '+ca.Nom
			 	     else ca.RSocial end as NomComCte,
		va.Cd_TDI as TDIV, div.descrip as dTDIV,
		ve.Cd_Vdr,case(isnull(len(va.RSocial),0))
			     when 0 then va.ApPat+' '+va.ApMat+' '+va.Nom
		    		     else va.RSocial end as NomComVdr,
		ar.NCorto as NCortoArea,md.Nombre as NomMR,ve.Obs,
		case(ve.IB_Anulado) when 1 then 0 else ve.INF end as INF,
		case(ve.IB_Anulado) when 1 then 0 else ve.EXO end as EXO,
		case(ve.IB_Anulado) when 1 then 0 else ve.BIM end as BIM,
		case(ve.IB_Anulado) when 1 then 0 else ve.IGV end as IGV,
		case(ve.IB_Anulado) when 1 then 0 else ve.Total end as Total,
		mo.Simbolo,	ve.CamMda,
		ve.IB_Anulado,
		ve.IB_Cbdo as Cobrado,
	             ve.UsuCrea as Usuario,convert(varchar,ve.FecReg,103) AS Fecha,convert(varchar,ve.FecReg,8) AS Hora
	from Venta ve
	left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	left join TipDocIdn dic on ca.Cd_TDI=dic.Cd_TDI
	left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux
	left join TipDocIdn div on div.Cd_TDI=va.Cd_TDI
	left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Modulo md on  ve.Cd_MR=md.Cd_MR
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
	where ve.RucE=@RucE and ve.Eje=@Eje and ve.Prdo between @PrdoIni and @PrdoFin order by Cd_Vta
    end
    else
    begin
	select
		ve.Cd_Vta as Cd_VtaX,
		ve.RegCtb,
		ve.Prdo,
		convert(varchar(10),ve.FecMov,103) as FecMov,
		convert(varchar(10),ve.FecCbr,103) as FecCbr,
		td.Descrip as DescripTD,
		ve.Cd_TD,
		se.NroSerie,
		ve.NroDoc,
		convert(varchar(10),ve.FecED,103) as FecED,
		convert(varchar(10),ve.FecVD,103) as FecVD,
		ca.Cd_TDI as TDIC, dic.descrip as dTDIC,
		ve.Cd_Cte,case(isnull(len(ca.RSocial),0))
		         	     when 0 then ca.ApPat+' '+ca.ApMat+' '+ca.Nom
			 	     else ca.RSocial end as NomComCte,
		va.Cd_TDI as TDIV, div.descrip as dTDIV,
		ve.Cd_Vdr,case(isnull(len(va.RSocial),0))
			     when 0 then va.ApPat+' '+va.ApMat+' '+va.Nom
		    		     else va.RSocial end as NomComVdr,
		ar.NCorto as NCortoArea,md.Nombre as NomMR,ve.Obs,
		case(ve.IB_Anulado) when 1 then 0 else ve.INF end as INF,
		case(ve.IB_Anulado) when 1 then 0 else ve.EXO end as EXO,
		case(ve.IB_Anulado) when 1 then 0 else ve.BIM end as BIM,
		case(ve.IB_Anulado) when 1 then 0 else ve.IGV end as IGV,
		case(ve.IB_Anulado) when 1 then 0 else ve.Total end as Total,
		mo.Simbolo,	ve.CamMda,ve.IB_Anulado,
		ve.IB_Cbdo as Cobrado,
		ve.UsuCrea as Usuario ,convert(varchar,ve.FecReg,103) AS Fecha,convert(varchar,ve.FecReg,8) AS Hora
	from Venta ve
	left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	left join TipDocIdn dic on ca.Cd_TDI=dic.Cd_TDI
	left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux
	left join TipDocIdn div on div.Cd_TDI=va.Cd_TDI
	left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Modulo md on  ve.Cd_MR=md.Cd_MR
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
	where ve.RucE=@RucE and ve.Eje=@Eje and ve.Prdo between @PrdoIni and @PrdoFin and ve.UsuCrea =@UsuCons order by Cd_Vta
    end
end
print @msj


--PV: Lun 10/08/2009  Mdf:  Nombres columnas no coincidian con dgv .net
GO
