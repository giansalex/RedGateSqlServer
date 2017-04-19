SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaConsUn_Mov]
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
		v.Cd_FPC,
		Convert(varchar,v.FecMov,103) as FecMov,
		v.Cd_TD, d.Cd_TD+'  |  '+d.Descrip as CodNomTD,
		v.NroDoc,
		-- v.Cd_Sr, s.NroSerie,s.Cd_Sr+'  |  '+s.NroSerie as CodNomSerie,--<<-- Modificado en linea 19
		v.NroSre as Cd_Sr, s.NroSerie,s.Cd_Sr+'  |  '+s.NroSerie as CodNomSerie,--<<-- Nueva
		c.Cd_TDI,i.Cd_TDI+'  |  '+i.Descrip as CodNomTDI,
		--v.Cd_Cte, c.NDoc as NDocCte, case(isnull(len(c.RSocial),0)) when 0 then c.ApPat+' '+c.ApMat+' '+c.Nom else c.RSocial end as NombreCte,--<<-- Modificado en linea 22
		v.Cd_Clt as Cte, c.NDoc as NDocCte, case(isnull(len(c.RSocial),0)) when 0 then c.ApPat+' '+c.ApMat+' '+c.Nom else c.RSocial end as NombreCte,
		v.Cd_Vdr, r.NDoc as NDocVdr, case(isnull(len(r.RSocial),0)) when 0 then r.ApPat+' '+r.ApMat+' '+r.Nom else r.RSocial end as NombreVdr,
		v.Cd_Area,a.Cd_Area+'  |  '+a.Descrip as CodNomArea,
--		e.Cd_MdaP,o.Simbolo as SimboloMP, 
		v.Cd_Mda, m.Simbolo as SimMdRg,m.Cd_Mda+'  |  '+m.Nombre as CodNomMda,
		v.CamMda, v.INF_NETO as INF, v.BIM, v.IGV, v.Obs,
		v.Total

	from Venta v
		left join TipDoc d 	on d.Cd_TD=v.Cd_TD --
		--left join Serie s 	on s.RucE=v.RucE and s.Cd_Sr=v.Cd_Sr --<<-- Modificado en linea 34
		left join Serie s 	on s.RucE=v.RucE and s.Cd_Sr=v.NroSre --<<-- Nueva
		--left join Auxiliar c 	on c.RucE=v.RucE and c.Cd_Aux=v.Cd_Cte --<<-- Modificado en linea 36
		left join Cliente2 c on c.Cd_Clt = v.Cd_Clt --<<-- Nueva
		--left join Auxiliar r 	on r.RucE=v.RucE and r.Cd_Aux=v.Cd_Vdr--<<-- Modificado en linea 38		
		left join Vendedor2 r 	on r.RucE=v.RucE and r.Cd_Vdr=v.Cd_Vdr--<<-- Nueva
		left join TipDocIdn i 	on i.Cd_TDI=c.Cd_TDI
		left join Area a 	on a.RucE = v.RucE  and a.Cd_Area=v.Cd_Area
--		inner join Empresa e 	on e.Ruc=v.RucE 
--		inner join Moneda o 	on o.Cd_Mda=e.Cd_MdaP
--		inner join Moneda u 	on u.Cd_Mda=e.Cd_MdaS
		left join Moneda m 	on m.Cd_Mda=v.Cd_Mda
	where v.RucE=@RucE and v.Cd_Vta=@Cd_Vta

end
print @msj

--Leyenda
--CAM 23/09/2010 MODIFICADO RA01 RV01 : Quite las tablas Auxiliar(Cliente y Vendedor) y agregue las tablas Cliente2 y Vendedor2

--sp_help Vta_VentaConsUn_Mov
/*
select * from Venta where Ruce = '11111111111'
select * from Serie where RucE = '11111111111' 
exec Vta_VentaConsUn_Mov '11111111111','VT00000015',''

sp_help Venta
*/
GO
