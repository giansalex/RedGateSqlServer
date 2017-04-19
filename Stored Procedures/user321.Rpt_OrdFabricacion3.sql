SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Rpt_OrdFabricacion3]
/*
declare @RucE nvarchar(11)
declare @Ejer nvarchar(4)
declare @cd_of char(10)
SET @RucE ='11111111111'
set @Ejer ='2010'
set @cd_of ='OF00000027'
*/
@RucE nvarchar(11),
@cd_of char(10),
@msj varchar(100) output
as

if not exists (select top 1 *from OrdFabricacion where RucE=@RucE and Cd_OF=@Cd_OF)
	set @msj='no contiene informacion'
else 
begin

/***********************************CABECERA************************************/
select
	/****************EMPRESA**************************/
	e.Ruc as RucE, e.RSocial, e.Direccion as DirEmp, e.Telef as TelefEmp,
	convert(varchar,orf.Fece,103) as FechaEmision, orf.Asunto, orf.Obs, 
	orf.NroOF, 
	/****************Producto*************************/
	pr.Cd_Prod,pr.Nombre1, pr.Nombre2, pr.Descrip as Descripcion, 
	/****************Unidad de producto***************/
	orf.Id_UMP,
	/****************Cantidad*************************/
	orf.Cant as Cantidad,
	/****************Costos***************************/
	orf.CosTot as CostoTotal, orf.Cu as costoUnitario
from
	Empresa e
	left join ordFabricacion orf on orf.ruce = e.ruc
	left join producto2 pr on pr.ruce = orf.ruce and pr.cd_prod = orf.cd_prod

where orf.ruce=@RucE and orf.cd_of = @cd_of


/*****************DETALLE - ConceptoCosto de la OF**************************************************/

select 	RucE, case(len(CodSNT_)) when 4 then '' + Descrip else Descrip end as Descrip, 
	Ncorto, 
	cd_cos,CodSNT_
from 
	cptocosto 
where 
	ruce= @RucE and 
	cd_cos in
	(select cd_cos 
	from 
		cptocostoOF 
	where 
		ruce= @RucE and 
		cd_of = @cd_of 
		union all 
		select 
			Cd_cos 
		from 
			frmlaOF 
		where 
			RucE =@RucE and 
			Cd_OF =@Cd_OF union all 
		select 
			Cd_cos 
		from EnvEmbOF 
		where RucE =@RucE and 
		Cd_OF =@Cd_OF)
	 order by 
		CodSNT_

/****************DETALLE - DetalleConceptoCosto 1******productos****************************************/

select t1.RucE, t1.Cd_OF,t1.Item,t1.Cd_Prod, t1.Cd_Alm,t1.Nombre1, t1.Descrip,t1.ID_UMP,t1.DescripAlt, t1.Cant,
t1.Costo, t1.CU,t2.cd_cos, null as TotalCompra_SumaBIM, null as cd_com
from 
(
select       
                f.Ruce,ordf.Cd_OF, Item, f.Cd_Prod, ordf.Cd_Alm,P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,f.Cant, 
                ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = f.RucE and i.Cd_OF = f.Cd_OF and i.Cd_Prod=f.Cd_Prod and i.Item = f.Item),0 ))as Cant_Ing,
                f.Costo as Costo,f.CU --, null as cd_cos
                from FrmlaOF f 
                left join OrdFabricacion as ordf on ordf.RucE = f.RucE and ordf.Cd_OF = f.Cd_OF
                left join Producto2 as P on P.RucE = f.RucE and P.Cd_Prod = f.Cd_Prod  
                left join Prod_UM as UMP on UMP.RucE = f.RucE and UMP.Cd_Prod = f.Cd_Prod and UMP.ID_UMP = f.ID_UMP
                where f.RucE = @ruce and f.Cd_OF = @cd_of  and f.Cd_Prod is not null

union

select 
                f.ruce,ordf.Cd_OF, Item, f.Cd_Prod,ordf.Cd_Alm,P.Nombre1,P.Descrip,UMP.ID_UMP,UMP.DescripAlt,f.Cant, 
                ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = f.RucE and i.Cd_OF = f.Cd_OF and i.Cd_Prod=f.Cd_Prod and i.Item = f.Item),0 ))as Cant_Ing,
                f.Costo as Costo,f.CU--,null as cd_cos
                from EnvEmbOF f 
                left join OrdFabricacion as ordf on ordf.RucE = f.RucE and ordf.Cd_OF = f.Cd_OF
                left join Producto2 as P on P.RucE = f.RucE and P.Cd_Prod = f.Cd_Prod  
                left join Prod_UM as UMP on UMP.RucE = f.RucE and UMP.Cd_Prod = f.Cd_Prod and UMP.ID_UMP = f.ID_UMP
                where f.RucE = @ruce and f.Cd_OF = @cd_of  and f.Cd_Prod is not null
) as t1

left join 

--select * from 
(
select Cd_Cos, Cd_Prod
	from frmlaOF where ruce= @rucE and cd_of = @cd_of
union
select Cd_Cos, Cd_Prod from EnvEmbOF where RucE =@RucE and Cd_OF =@Cd_OF
) as t2

on t1.Cd_Prod = t2.Cd_Prod


union all  /**************************DETALLE - DetalleConceptoCosto -- Otros Conceptos***************************************************/

select t1.Ruce, t1.cd_of, null as Item, null as Cd_Prod, null as Cd_Alm, null as Nombre1, null as Descrip, null as ID_UMP, null as DescriptAlt, null as Cant, t1.Costo,null as CU, t1.cd_cos, t2.TotalCompra_SumaBIM, t1.cd_com
from
(
select  c.Ruce , c.cd_com, ccof.cd_of, ccof.cd_cos, ccof.Costo
	from CptoCostoOF ccof
	left join cptoCostoOFDoc ccofDoc on ccof.ruce= ccofDoc.rucE and ccof.cd_of = ccofDoc.cd_of and ccof.Id_CCof = ccofDoc.Id_CCof
	left join Compra c on c.ruce = ccof.ruce  and c.cd_com = ccofDoc.cd_com
where ccof.RucE =@RucE and ccof.Cd_OF =@Cd_OF
)as t1

left join 
(
select isnull(BIM_S,0)+isnull(BIM_E,0) + isnull(BIM_C,0) as TotalCompra_SumaBIM,cd_com 
	from compra 
where ruce = @ruce and cd_com in 
				(
				select c.cd_com
					from CptoCostoOF ccof 
					left join CptoCostoOFDoc ccofDoc on ccof.ruce = ccofDoc.ruce and ccof.cd_of = ccofDoc.cd_of and ccof.id_ccof=ccofDoc.id_ccof
					left join Compra c on c.ruce = ccof.ruce and c.cd_com = ccofDoc.cd_com
				where ccof.ruce = @RucE and ccof.cd_of = @Cd_Of
				)
) as t2
on t1.cd_com = t2.cd_com
end


/*Ejemplo
declare @msj varchar(100)
--no data
--exec Rpt_OrdFabricacion2 '11111111111','OF00000050',@msj out 
--print @msj
--data
exec Rpt_OrdFabricacion3 '11111111111','OF00000027',@msj out 
print @msj
*/
/*****Leyenda**************/
--Creado Javier: --> 12/03/2011
--Modificado JJ: --> 14/03/2011








GO
