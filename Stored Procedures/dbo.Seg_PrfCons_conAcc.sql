SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Seg_PrfCons_conAcc]

@Cd_Prf nvarchar(6),
@msj varchar(100) output

AS

Select 
	p.Cd_Prf,p.NomP 
From 
Perfil p
Inner Join AccesoE a On a.Cd_Prf=p.Cd_Prf
Where p.Cd_Prf<>@Cd_Prf and isnull(p.Estado,0)<>0
Group by p.Cd_Prf,p.NomP
Order by 2

-- Leyenda --
-- DI : 13/07/2011 <Creacion del procedimiento almacenado>

GO
