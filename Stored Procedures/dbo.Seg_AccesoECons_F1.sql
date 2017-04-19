SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccesoECons_F1]  --Procedimiento Final
@PrfPri nvarchar(3),
@PrfSec nvarchar(3),
@msj varchar(100) output
as

--EMPRESAS NO ASIGNADAS
select 
	a.RucE,e.RSocial,a.Cd_GA
from AccesoE a, Empresa e
where a.Cd_Prf=@PrfPri and a.RucE=e.Ruc and a.RucE not in (select i.RucE from AccesoE i where i.Cd_Prf=@PrfSec)
Order by 2 

--EMPRESAS ASIGNADAS
select 
	a.RucE,e.RSocial,g.Descrip
from AccesoE a, Empresa e, GrupoAcceso g
where a.Cd_Prf=@PrfSec and a.RucE=e.Ruc and a.Cd_GA=g.Cd_GA
Order by 2 

--Leyenda------
---------------

--DI  28/08/2009 : Creacion del procedimiento almacenado
GO
