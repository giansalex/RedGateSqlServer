SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[Rpt_OrdFabricacion5]
@RucE nvarchar(11),@Cd_OF varchar(4000)
as
--datos Generales
select * from Empresa where Ruc = @RucE
--Cabecera

declare @Sql1 varchar(8000)
set @Sql1='
select
op.RucE
,op.Cd_OF
,op.NroOF
,op.FecE as FecEmi
,op.FecEntr
,op.Cd_Prod
,isnull(op.Cant,0) as Cantidad
,p.Nombre1
,p.Nombre2
,p.Descrip
,p.NCorto
,p.CodCo1_
,p.CodCo2_
,p.CodCo3_
,p.CodBarras
,p.FecCaducidad
,p.Img
,pum.ID_UMP
,pum.Cd_UM
,isnull(um.Nombre,'''') as NomUM
,isnull(um.Ncorto,'''') as NCortoUM
,isnull(pum.Factor,0) as Factor
,isnull(pum.PesoKg,0) as Peso
,isnull(pum.volumen,0) as Volumen
,op.Cd_Area
,op.Cd_Alm
,op.Asunto
,op.Obs
,op.Lote
,isnull(op.CosTot,0) as CostoTotal
,isnull(op.CosTot_Me,0) as CostoTotal_ME
,isnull(op.CU,0) as CUnitario
,isnull(op.CU_ME,0) as CUnitario_ME
,op.Cd_Mda
,op.FecReg
,op.FecMdf
,op.UsuCrea
,op.UsuModf
,op.Cd_CC
,op.Cd_SC
,op.Cd_SS
,op.Id_EstOF
,op.TipAut
,op.IB_Aut
,op.AutorizadoPor
,op.CA01
,op.CA02
,op.CA03
,op.CA04
,op.CA05
,op.CA06
,op.CA07
,op.CA08
,op.CA09
,op.CA10
,op.CA11
,op.CA12
,op.CA13
,op.CA14
,op.CA15
,op.CA16
,op.CA17
,op.CA18
,op.CA19
,op.CA20
,op.CA21
,op.CA22
,op.CA23
,op.CA24
,op.CA25

,isnull(f.CA01,'''') as CA01For
,isnull(f.CA02,'''') as CA02For
,isnull(f.CA03,'''') as CA03For
,isnull(f.CA04,'''') as CA04For
--,isnull(f.CA05,'''') as CA05For
,f.CA05 as CA05For
,isnull(f.CA06,'''') as CA06For
,isnull(f.CA07,'''') as CA07For
,isnull(f.CA08,'''') as CA08For
,isnull(f.CA09,'''') as CA09For
,isnull(f.CA10,'''') as CA10For
,isnull(f.CA11,'''') as CA11For
,isnull(f.CA12,'''') as CA12For
,isnull(f.CA13,'''') as CA13For
,isnull(f.CA14,'''') as CA14For
,isnull(f.CA15,'''') as CA15For
,f.Proced as  Proceso
,case when isnull(c.Rsocial,'''')<>'''' then c.RSocial else isnull(c.ApPat,'''') +'' '' + isnull(c.ApMat,'''') +'' '' + isnull(c.Nom,'''') end as NomCli
,c.Cd_Clt as Cd_Clt
,c.NDoc as NDocCli

from OrdFabricacion op 
left join Formula f on f.RucE = op.RucE and f.ID_Fmla = op.ID_Fmla
left join Producto2 p on p.RucE = op.RucE and p.Cd_Prod = op.Cd_Prod
left join Prod_Um pum on pum.RucE = op.RucE and pum.Cd_Prod = op.Cd_Prod and pum.ID_UMP=op.ID_UMP
left join UnidadMedida um on um.Cd_UM = pum.Cd_UM
--left join MantenimientoGN mg on mg.RucE = op.RucE and case when '''+@RucE+''' = ''20536756541'' then mg.Codigo else '''' end = case when '''+@RucE+''' = ''20536756541'' then op.CA25 else '''' end
left join Cliente2 c on c.RucE = op.RucE and c.Cd_Clt = op.Cd_Clt
where op.RucE = '''+@RucE+''' and op.Cd_Of in ('+ @Cd_OF+')'

--Detalle Formula
declare @Sql2 varchar(8000)

set @Sql2 ='
select 
fof.Item
,fof.RucE
,fof.Cd_OF
,isnull(fof.CU,0) as CUnitario
,isnull(fof.CU_ME,0) as CUnitario_ME
,isnull(fof.Costo,0) as Costo
,isnull(fof.Costo_ME,0) as Costo_ME
,isnull(fof.Mer,0) as Merma
,isnull(fof.MerPorc,0) as MermaPorc
,isnull(fof.Obs,'''') as ObsDet
,isnull(fof.Cd_Cos,'''') as Cd_Cost
,fof.Cant * op.Cant as Cant
,p.Cd_Prod
,p.Nombre1
,p.Nombre2
,p.Descrip
,p.NCorto
,p.CodCo1_
,p.CodCo2_
,p.CodCo3_
,p.CodBarras
,p.FecCaducidad
,p.Img
,pum.ID_UMP
,pum.Cd_UM
,isnull(um.Nombre,'''') as NomUM
,isnull(um.Ncorto,'''') as NCortoUM
,isnull(pum.Factor,0) as Factor
,isnull(pum.PesoKg,0) as Peso
,isnull(pum.volumen,0) as Volumen
,op.Cant as CantidadProducida

from FrmlaOf fof
left join OrdFabricacion op on op.RucE = fof.RucE and op.Cd_OF = fof.Cd_OF
left join Producto2 p on p.RucE = fof.RucE and p.Cd_Prod = fof.Cd_Prod
left join Prod_Um pum on pum.RucE = fof.RucE and pum.Cd_Prod = fof.Cd_Prod and pum.ID_UMP=fof.ID_UMP
left join UnidadMedida um on um.Cd_UM = pum.Cd_UM
where fof.RucE = '''+ @RucE +''' and fof.Cd_Of in('+ @Cd_OF+')'

declare @Sql3 varchar(4000)
set @Sql3 = 
'
Select e.RucE,e.Cd_OF,e.Item,e.ID_UMP,e.CU,e.CU_ME,e.Cant,e.Costo,e.Costo_ME
,p.Cd_Prod
,p.Nombre1
,p.Nombre2
,p.Descrip
,p.NCorto
,p.CodCo1_
,p.CodCo2_
,p.CodCo3_
,p.CodBarras
,p.FecCaducidad
,p.Img
,pum.Cd_UM
,isnull(um.Nombre,'''') as NomUM
,isnull(um.Ncorto,'''') as NCortoUM
,isnull(pum.Factor,0) as Factor
,isnull(pum.PesoKg,0) as Peso
,isnull(pum.volumen,0) as Volumen

from EnvEmbOF e 
left join Producto2 p on p.RucE = e.RucE and p.Cd_Prod = e.Cd_Prod
left join Prod_Um pum on pum.RucE = e.RucE and pum.Cd_Prod = e.Cd_Prod and pum.ID_UMP=e.ID_UMP
left join UnidadMedida um on um.Cd_UM = pum.Cd_UM
where e.RucE = '''+ @RucE +''' and e.Cd_Of in('+ @Cd_OF+')'



exec (@Sql1)
print @Sql1
exec (@Sql2)
print (@Sql2)
exec (@Sql3)
print (@Sql3)


--Detalle Costos1
--terminar la implementacion
--Detalle Costos2
--terminar la implementacion

--<creado>: Javier 10/07/2012
--
--exec Rpt_OrdFabricacion5 '20536756541','''OF00000013'''



--select * from OrdFabricacion where RucE = 'OF00000013'
--update OrdFabricacion set Id_Fmla = 53 where RucE = '20536756541' and Cd_OF = 'OF00000014'
GO
