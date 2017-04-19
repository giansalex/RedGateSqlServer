SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_VentasXMesEnCant]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FecIni datetime,
@FecFin datetime,
@Order char

as
--set @RucE = '20102028687'
--set @Ejer = '2012'
--set @FecIni = '01/09/2012'
--set @FecFin = '30/09/2012'
--set @Order = '1'

select e.*,'DEL '+Convert(nvarchar,@FecIni,103)+ ' AL '+Convert(nvarchar,@FecFin,103) as FecCons from empresa e where e.Ruc=@RucE

declare @Sql varchar(8000)
set @Sql = '
select
isnull(vd.Cd_Prod,isnull(vd.Cd_Srv,'''')) as CodPrdSrv
,isnull(p.CodCo1_,isnull(s.CodCo,'''')) as CodCoPrdSrv
,isnull(p.Nombre1,isnull(s.Nombre,'''')) as NomPrdSrv
,sum(case v.Prdo when ''01'' then vd.Cant else 0 end) as CantEnero
,sum(case v.Prdo when ''02'' then vd.Cant else 0 end) as CantFebrero
,sum(case v.Prdo when ''03'' then vd.Cant else 0 end) as CantMarzo
,sum(case v.Prdo when ''04'' then vd.Cant else 0 end) as CantAbril
,sum(case v.Prdo when ''05'' then vd.Cant else 0 end) as CantMayo
,sum(case v.Prdo when ''06'' then vd.Cant else 0 end) as CantJunio
,sum(case v.Prdo when ''07'' then vd.Cant else 0 end) as CantJulio
,sum(case v.Prdo when ''08'' then vd.Cant else 0 end) as CantAgosto
,sum(case v.Prdo when ''09'' then vd.Cant else 0 end) as CantSeptiembre
,sum(case v.Prdo when ''10'' then vd.Cant else 0 end) as CantOctubre
,sum(case v.Prdo when ''11'' then vd.Cant else 0 end) as CantNoviembre
,sum(case v.Prdo when ''12'' then vd.Cant else 0 end) as CantDiciembre

from
Venta v
Inner join VentaDet vd on vd.RucE = v.RucE and vd.Cd_Vta = v.Cd_Vta
left join Producto2 p on p.RucE = v.RucE and p.Cd_Prod = vd.Cd_Prod
left join Servicio2 s on s.RucE = v.RucE and s.Cd_Srv = vd.Cd_Srv
where v.RucE = '''+@RucE+''' and v.Eje = '''+@Ejer+''' and v.Fecmov between '''+convert(nvarchar,@FecIni)+''' and '''+convert(nvarchar,@FecFin)+'''
and isnull(vd.Cd_Prod,'''')<>''''
and isnull(v.Ib_Anulado,0)<>1
group by v.Prdo,isnull(vd.Cd_Prod,isnull(vd.Cd_Srv,'''')),isnull(p.CodCo1_,isnull(s.CodCo,'''')),isnull(p.Nombre1,isnull(s.Nombre,''''))
order by '+@Order

print @Sql
exec (@Sql)

--<<Creado>> 'JA' 26/11/2012, Creado para Reymosa
--exec Rpt_VentasXMesEnCant '20102028687','2012','01/09/2012','30/09/2012','1'
GO
