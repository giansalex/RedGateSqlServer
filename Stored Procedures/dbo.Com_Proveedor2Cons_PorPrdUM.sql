SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2Cons_PorPrdUM]
--Consulta Todos los PRV con esos productos y las unidades de medida
@RucE nvarchar(11),
@Dato2 nvarchar(4000),
@NroProd int,
@msj varchar(100) output
as

declare 	
@part1 nvarchar(4000),
	@part2 nvarchar(4000),
	@part3 nvarchar(4000),
	@part4 nvarchar(4000)

set @part1=
'
declare @check bit
set @check=0

select @check as Sel,
P.Cd_Prv,
RucE,
P.NDoc, 
case(isnull(len(RSocial),0))when 0 then ApPat +'' ''+ ApMat + '' '' + Nom else RSocial end as Nombre, TDI.NCorto as descrip 
from (select count(*) as NroProd, Cd_Prv
from ProdProv '
	
set @part2=
' where RucE='+@RucE+' and (Cd_Prod + '''' + convert(nvarchar,Id_UMP)) in'+'('+@Dato2+')'
	
set @part3=
' group by Cd_Prv) as Prov inner join Proveedor2 as P on P.RucE = '+@RucE+' and Prov.Cd_Prv = P.Cd_Prv 
 join TipDocIdn TDI on P.Cd_TDI = TDI.Cd_TDI '

set @part4=
' where NroProd = '+convert(nvarchar,@NroProd)+''

--ejecutamos las 4 variables
exec (@part1+@part2+@part3+@part4)

--mostramos las 4 variables ejecutadas
print @part1+@part2+@part3+@part4


/*select
P.Cd_Prv,
RucE,
case(isnull(len(RSocial),0))when 0 then ApPat +' '+ ApMat + ' ' + Nom else RSocial end as Nombre
from (select count(*) as NroProd, Cd_Prv
from ProdProv 
where RucE=@RucE and (Cd_Prod + '' + convert(nvarchar,Id_UMP)) in (@Dato2)
group by Cd_Prv) as Prov 
inner join Proveedor2 as P on P.RucE = @RucE and Prov.Cd_Prv = P.Cd_Prv
where NroProd = @NroProd*/

--MP -> <creado 20-10-2010>
--ejemplo
--exec Com_Proveedor2Cons_PorPrdUM '11111111111','''PD0002512''', '1',NULL

/*
select * from Producto2 where Cd_Prod = 'PD00025'
select * from Producto2 where Cd_Prod = 'PD00001'
select * from UnidadMedida where Cd_UM = '12'
select * from UnidadMedida where Cd_UM = '01'
select * from ProdProv where Cd_Prod = 'PD00001'
P00025 01		P00001 01
P00001 12		P00025 12

select * from ProdProv where Cd_Prod = 'PD00025' and Id_UMP in ('12','1')
select * from ProdProv where Cd_Prod = 'PD00001' and Id_UMP in ('12','1')

--Otra forma
select count(*), pp.Cd_Prv,
pp.RucE,
case(isnull(len(pv.RSocial),0))when 0 then pv.ApPat +' '+ pv.ApMat + ' ' + pv.Nom else pv.RSocial end as Nombre 
from ProdProv pp
Left Join Proveedor2 pv on pv.RucE = pp.RucE and pv.Cd_Prv = pp.Cd_Prv 
Left Join Prod_UM pum on pum.RucE= pp.RucE and pum.ID_UMP= pp.ID_UMP and pum.Cd_Prod = pp.Cd_Prod
where pp.RucE='11111111111' and (pum.Cd_Prod + '' + convert(nvarchar,pum.Id_UMP)) in ('PD0000112', 'PD000251')
group by pp.Cd_Prv, pp.RucE, pv.ApPat,pv.ApMat,pv.Nom,pv.RSocial
having count(*) = '2'
*/

GO
