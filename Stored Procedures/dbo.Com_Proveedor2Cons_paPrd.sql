SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2Cons_paPrd]
--Consulta Todos los PRV con esos productos
@RucE nvarchar(11),
@Dato nvarchar(4000),
@msj varchar(100) output
as

/*
select pp.RucE,pp.Cd_Prv,case(isnull(len(pv.RSocial),0)) when 0 then pv.ApPat+' '+pv.ApMat+' '+pv.Nom 
else pv.RSocial end as Nombre 
from ProdProv pp
Left Join Proveedor2 pv on pv.RucE = pp.RucE and pv.Cd_Prv = pp.Cd_Prv
Left Join Prod_UM pum on pum.RucE= pp.RucE and pum.ID_UMP= pp.ID_UMP and pum.Cd_Prod = pp.Cd_Prod
where pp.RucE=@RucE and pp.Cd_Prod in (@Dato) 
group by pp.RucE, pp.Cd_Prv,pv.ApPat,pv.ApMat,pv.Nom,pv.RSocial
*/
--Declaramos 4 variables para dividir las sentencias
declare 	@part1 nvarchar(4000),
	@part2 nvarchar(4000),
	@part3 nvarchar(4000),
	@part4 nvarchar(4000)

	set @part1=
	'select pp.RucE,pp.Cd_Prv,
	case(isnull(len(pv.RSocial),0))
	when 0 then pv.ApPat +'' ''+ pv.ApMat + '' '' + pv.Nom 
	else pv.RSocial end as Nombre, pv.NDoc, TDI.NCorto as descrip  '
	
	set @part2=
	'from ProdProv pp Left Join Proveedor2 pv on pv.RucE = pp.RucE and pv.Cd_Prv = pp.Cd_Prv 
	 Left Join Prod_UM pum on pum.RucE= pp.RucE and pum.ID_UMP= pp.ID_UMP and pum.Cd_Prod = pp.Cd_Prod
	 left Join TipDocIdn TDI on pv.Cd_TDI = TDI.Cd_TDI'
	
	set @part3=
	' where pp.RucE='+@RucE+' and pp.Cd_Prod in'+'('+@Dato+')'
	
	set @part4=
	' group by pp.RucE, pp.Cd_Prv,pv.ApPat,pv.ApMat,pv.Nom,pv.RSocial,pv.NDoc,TDI.NCorto'
--ejecutamos las 4 variables
exec (@part1+@part2+@part3+@part4)
--mostramos las 4 variables ejecutadas
print @part1+@part2+@part3+@part4
--print @msj
--J -> <creado 01-09-2010>
--MP : 10-02-2011 - <Modificacion del procedimiento almacenado>

--ejemplo
--exec Com_Proveedor2Cons_paPrd '11111111111','''PD00001'',''PD00002'',''PD00020''',NULL


GO
