SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaConsUnX]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
IF not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no existe'
else
begin

	select 
		v.RegCtb,
		v.Prdo,
		Convert(varchar,v.FecMov,103) as FecMov,
		v.Cd_TD, d.Descrip as NomTD, 
		v.NroDoc,
		--v.Cd_Sr, s.NroSerie, --<<-- Modificado en linea 18 
		v.NroSre as Cd_Sr, s.NroSerie, --<<-- Nueva
		c.Cd_TDI, i.Descrip as NomTDI,
		--v.Cd_Cte, c.NDoc as NDocCte, case(isnull(len(c.RSocial),0)) when 0 then c.ApPat+' '+c.ApMat+' '+c.Nom else c.RSocial end as NombreCte, --<<-- Modificado en linea 21
		v.Cd_Clt as Cd_Cte, c.NDoc as NDocCte, case(isnull(len(c.RSocial),0)) when 0 then c.ApPat+' '+c.ApMat+' '+c.Nom else c.RSocial end as NombreCte,
		v.Cd_Vdr, r.NDoc as NDocVdr, case(isnull(len(r.RSocial),0)) when 0 then r.ApPat+' '+r.ApMat+' '+r.Nom else r.RSocial end as NombreVdr,
		v.Cd_Area,a.NCorto as NomArea,
		e.Cd_MdaP,o.Simbolo as SimboloMP, 
		v.CamMda,
		e.Cd_MdaS, u.Simbolo as SimboloMS,
		v.Total


	from Venta v
--<<-- TODOS LOS INNER SE CONVIRTIERON EN LEFT
		left join TipDoc d 	on d.Cd_TD=v.Cd_TD
		left join Serie s 	on s.RucE=v.RucE and s.Cd_Sr=v.NroSre
		--inner join Auxiliar c 	on c.RucE=v.RucE and c.Cd_Aux=v.Cd_Cte --<<-- Modificado en linea 32
		left join Cliente2 c 	on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt --<<-- Nueva
		--inner join Auxiliar r 	on r.RucE=v.RucE and r.Cd_Aux=v.Cd_Vdr --<<-- Modificado en linea 34
		left join Vendedor2 r 	on r.RucE=v.RucE and r.Cd_Vdr=v.Cd_Vdr --<<-- Nueva
		left join TipDocIdn i 	on i.Cd_TDI=c.Cd_TDI
		left join Area a 	on a.RucE = v.RucE  and a.Cd_Area=v.Cd_Area
		left join Empresa e 	on e.Ruc=v.RucE 
		left join Moneda o 	on o.Cd_Mda=e.Cd_MdaP
		left join Moneda u 	on u.Cd_Mda=e.Cd_MdaS

	where v.RucE=@RucE and v.Cd_Vta=@Cd_Vta
end
print @msj


--Leyenda
--CAM -> 23/09/2010 Modificado  RA01 -> Eliminacion de la Tabla Auxiliar, reemplazada por Cliente2 y Vendedor2
--				RV01 -> Reestructuracion de la tabla Venta

--select * from Venta where RucE = '11111111111'
--exec Vta_VentaConsUnX '11111111111','VT00000120',''
GO
