SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaCons2]     /*PROCEDIMIENTO PARA LA NUEVA VENTANA DE EXPLORADOR*/
/*NO VALE ESTE PROCEDIMIENTO*/
@RucE nvarchar(11),
@Eje nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@msj varchar(100) output
as

begin
	select
		ve.Cd_Vta,
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
		         	     when 0 then ca.ApPat+' '+ca.ApMat+' '+ca.Nom
		 	     else ca.RSocial end as NomComCte,
		va.Cd_TDI as TDIV, div.NCorto as dTDIV,
		va.NDoc as Cd_Vdr,case(isnull(len(va.RSocial),0))
	    		     when 0 then va.ApPat+' '+va.ApMat+' '+va.Nom
	    		     else va.RSocial end as NomComVdr,
		ar.NCorto as NCortoArea,
		md.Nombre as NomMR,
		ve.Obs,
		ve.INF,
		ve.EXO,
		ve.BIM,
		ve.IGV,
		ve.Total,
		mo.Simbolo,
		ve.CamMda,
		ve.IB_Anulado,
		ve.IB_Cbdo as Cobrado,
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
	where ve.RucE=@RucE and ve.Eje=@Eje and ve.Prdo between @PrdoIni and @PrdoFin order by Cd_Vta
end
print @msj
------CODIGO DE MODIFICACION--------
--CM=MG01
GO
