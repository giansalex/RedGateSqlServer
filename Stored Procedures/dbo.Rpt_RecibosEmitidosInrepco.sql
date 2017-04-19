SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Declare 
CREATE procedure [dbo].[Rpt_RecibosEmitidosInrepco]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RucEdi nvarchar(11),
@EjerEdi nvarchar(4),
@Prdo nvarchar(2)
as 

--set @RucE = '20111175382'
--set @Ejer = '2011'
--set @RucEdi = '00000000010'
--set @EjerEdi = '2011'
--select * from venta where RucE in (select Ruc from Empresa e


--cabecera Empresa
select RSocial,Direccion,Ruc,Telef
,case when (select top 1 CD_Mda from Venta where RucE = @RucEdi and Eje = @EjerEdi and Prdo = @Prdo )='01' then 'Nuevos Soles' else 'Dolares Americanos' end as NombreMoneda

from Empresa where Ruc = @RucE
--cabecera Edificio
select e.RSocial as Edificio ,e.Direccion,e.Telef 

from 
Empresa e
where Ruc = @RucEdi




-- Detalle de la venta


--Detalle
select 
v.RegCtb
,v.Prdo
,convert(nvarchar,v.Fecmov,103) as FecMov
,v.Cd_Vta
,v.Cd_Clt
,case when isnull(cl.RSocial,'')<>''then cl.RSocial else cl.ApPat + ' ' + cl.ApMat + ' ' + cl.Nom end as Dpto
,mg.Descrip
,case when isnull(cl.CA01,'')<>''then cl.CA01 else cl.CA02 end as Cliente
,v.Cd_Td
,v.NroSre
,v.NroDoc 
,v.Total
from venta v
left join Cliente2 cl on v.RucE = cl.RucE and v.Cd_clt = cl.Cd_Clt
left join MantenimientoGN mg on v.RucE = mg.RucE and mg.Codigo = case when isnull(cl.CA01,'')<>''then cl.CA01 else cl.CA02 end
where v.RucE = @RucEdi and v.Eje = @EjerEdi and isnull(v.IB_Anulado,0)<>1 and v.Prdo = @Prdo




--Servicios

Select 
	v.Cd_Vta
	,v.RegCtb
	,v.Prdo
	,convert(nvarchar,v.Fecmov,103) as FecMov
	,v.Cd_TD
	,v.NroSre,v.NroDoc,d.Nro_RegVdt,
	d.Cd_Srv,isnull(s.CA01,'') As IndSrv,
	s.Nombre As NomSrv,
	d.Total
From 
	Venta v
	Left Join VentaDet d On d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta
	Left Join Servicio2 s On s.RucE=d.RucE and s.Cd_Srv=d.Cd_Srv
Where v.RucE=@RucEdi and v.Eje=@EjerEdi and isnull(v.IB_Anulado,0)<>1 and v.Prdo = @Prdo



--Creado Ja: <15/11/2011> 
--Prueba exec Rpt_RecibosEmitidosInrepco '20111175382','2011','20518936973','2011','12'
GO
