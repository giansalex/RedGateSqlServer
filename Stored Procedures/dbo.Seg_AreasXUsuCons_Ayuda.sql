SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Seg_AreasXUsuCons_Ayuda]

@RucE nvarchar(11),
@NomUsu nvarchar(10),
@msj varchar(100) output

AS

Select 
	u.Cd_Area,
	u.Cd_Area As NroArea,
	a.Descrip
From 
	AreaXUsuario u
	Inner Join Area a On a.RucE=u.RucE and a.Cd_Area=u.Cd_Area
Where u.RucE=@RucE and lower(u.NomUsu)=@NomUsu and u.Estado=1

-- Leyenda --
-- DI : 17/02/2012 <Creacion del SP>

GO
