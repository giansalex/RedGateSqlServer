SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare @RucE nvarchar(11)
--declare @cd_of varchar(4000)
--SET @RucE ='11111111111'
--set @cd_of ='''OF00000058'',''OF00000027'''
--Exec [user321].[Rpt_OrdFabricacion4] '11111111111','''OF00000027'',''OF00000058'''
CREATE Procedure [user321].[Rpt_OrdFabricacion4]
@RucE nvarchar(11),
@cd_of varchar(4000)

as


--Cabecera
declare @sql1 varchar(8000)

set @sql1 = '
select
	
	e.Ruc as RucE, e.RSocial, e.Direccion as DirEmp, e.Telef as TelefEmp,
	convert(varchar,orf.Fece,103) as FechaEmision, orf.Asunto, orf.Obs, 
	orf.Cd_OF as NroOF, 
	
	pr.Cd_Prod,pr.Nombre1, pr.Nombre2, pr.Descrip as DescripcioncCab, 
	
	orf.Id_UMP,
	
	orf.Cant as Cantidad,
	
	orf.CosTot as CostoTotal, orf.Cu as costoUnitario
from
	Empresa e
	left join ordFabricacion orf on orf.ruce = e.ruc
	left join producto2 pr on pr.ruce = orf.ruce and pr.cd_prod = orf.cd_prod

where orf.ruce= '''+@RucE+''' and orf.cd_of in ('
--@cd_of


--Detalle


declare @sql2 varchar(8000)

set @sql2 = ')
select 
t.RucE
,t.Cd_OF
,ISNULL(t.Cd_Prod,'''') as Cd_ProdComp
,ISNULL(p.Nombre1,'''') as NomProd
,ISNULL(p.Descrip,'''') as DescripProd
,ISNULL(t.Costo,'''') as CostoProdComp
,ISNULL(t.Cd_Cos,'''') as Cd_Cos
,ISNULL(t.TotalCompra,0) as TotalCompra
,ccp.CodSNT_ as CodSNT
from 
(
select 
cc.RucE,cc.Cd_OF,ccof.Cd_Com as Cd_Prod,isnull(cc.Costo,0) as Costo, cc.Cd_Cos,
isnull(c.BIM_S,0)+isnull(c.BIM_E,0) + isnull(c.BIM_C,0) as TotalCompra
from CptoCostoOF cc 
inner join cptoCostoOFDoc ccof on cc.cd_of = ccof.cd_of and cc.ruce =ccof.ruce and cc.id_ccof = ccof.id_ccof
inner join Compra c on c.ruce = ccof.ruce and c.cd_com = ccof.cd_com
where cc.ruce = '''+@RucE+''' and cc.cd_of in ('
 --@cd_of
 
declare @sql3 varchar(8000)
set @sql3 = ') 
union all
select RucE,Cd_OF,Cd_Prod,isnull(Costo,0) as Costo, Cd_Cos, 0.00 TotalCompra from frmlaOF where RucE = '''+@RucE+''' and Cd_OF in ('
--@cd_of
declare @sql4 varchar(8000)
set @sql4 = ')
union all
select RucE,Cd_OF,Cd_Prod,isnull(Costo,0) as Costo, Cd_Cos, 0.00 TotalCompra from EnvEmbOF where RucE = '''+@RucE+''' and Cd_OF in ('
--@cd_of

declare @sql5 varchar(8000)
set @sql5 = ')
) as t left join Producto2 p on p.Cd_Prod = t.Cd_Prod and p.RucE = t.RucE
inner join CptoCosto ccp on ccp.Cd_Cos = t.Cd_Cos and t.RucE = ccp.RucE
order by Cd_OF


--Menu de OF
select cc.Cd_Cos,cc.CodSNT_,cc.Descrip,'''' Cd_OF,'''' Cd_ProdComp,''''  NomProd, ''''  DescripProd, ''''  CostoProdComp, '''' TotalCompra
from CptoCosto cc
where ruce = '''+@RucE+'''
order by cc.CodSNT_'

print @sql1 +@cd_Of +@sql2+@Cd_Of+@sql3+@Cd_Of+@sql4+@Cd_Of+@sql5
exec (@sql1 +@cd_Of +@sql2+@Cd_Of+@sql3+@Cd_Of+@sql4+@Cd_Of+@sql5)
GO
