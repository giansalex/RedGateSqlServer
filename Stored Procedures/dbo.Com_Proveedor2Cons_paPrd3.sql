SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2Cons_paPrd3]
--Consulta Todos los PRV con esos productos
@RucE nvarchar(11),
@Dato nvarchar(4000),
@Dato3 nvarchar(4000),
@msj varchar(100) output
as

exec ('
declare @check bit
set @check=0

select	@check as Sel, pv.RucE,pv.Cd_Prv, case(isnull(len(pv.RSocial),@check))when @check then pv.ApPat + '' '' + pv.ApMat + '' '' + pv.Nom 
		else pv.RSocial end as Nombre, TDI.NCorto as descrip , pv.NDoc 
from(
	select count(*) as NroProd, Cd_Prv from(
		select Cd_Prv
		from ProdProv
		where RucE = '''+@RucE+''' and (Cd_Prod) in('+@Dato+')
		union
		select Cd_Prv
		from ServProv  
		where RucE = '''+@RucE+''' and Cd_Srv in('+@Dato3+')
	) as tabla
	group by Cd_Prv
) as pp
left join Proveedor2 pv on pv.Cd_Prv = pp.Cd_Prv 
left join TipDocIdn TDI on pv.Cd_TDI = TDI.Cd_TDI 
where pv.RucE = '''+@RucE+'''
group by pv.RucE, pv.Cd_Prv,pv.ApPat,pv.ApMat,pv.Nom,pv.RSocial,pv.NDoc,TDI.NCorto')
--MP: 25/06/2012 : <Modificacion del procedimiento almacenado>
/*
select	pv.RucE,pv.Cd_Prv, case(isnull(len(pv.RSocial),0))when 0 then pv.ApPat +' '+ pv.ApMat + ' ' + pv.Nom 
		else pv.RSocial end as Nombre, pv.NDoc, TDI.NCorto as descrip  
from(
	select count(*) as NroProd, Cd_Prv from(
		select Cd_Prv
		from ProdProv  
		where RucE = @RucE and (Cd_Prod) in(@Dato) 
		union
		select Cd_Prv
		from ServProv  
		where RucE = @RucE and Cd_Srv in(@Dato3)
	) as tabla
	group by Cd_Prv
) as pp
left join Proveedor2 pv on pv.Cd_Prv = pp.Cd_Prv 
left join TipDocIdn TDI on pv.Cd_TDI = TDI.Cd_TDI 
where pv.RucE = @RucE
group by pv.RucE, pv.Cd_Prv,pv.ApPat,pv.ApMat,pv.Nom,pv.RSocial,pv.NDoc,TDI.NCorto
GO
*/
GO
