SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Seg_AreasXUsuCons]

@RucE nvarchar(11),
@NomUsu nvarchar(10),
@msj varchar(100) output

As

(			
Select Convert(bit,0) As Sel,Cd_Area,Descrip,NCorto,'' As Acc From Area Where RucE=@RucE
and Cd_Area not in (Select Cd_Area From AreaXUsuario Where RucE=@RucE and NomUsu=@NomUsu and Estado=1)
UNION ALL
Select 
	Convert(bit,1) As Sel,u.Cd_Area,a.Descrip,a.NCorto,'' As Acc
From 
	AreaXUsuario u
	Inner Join Area a On a.RucE=u.RucE and a.Cd_Area=u.Cd_Area
Where u.RucE=@RucE and u.NomUsu=@NomUsu and u.Estado=1
)
Order by 3			


-- Leyenda --
-- DI : 16/02/2012 <Creacion del SP>	

GO
