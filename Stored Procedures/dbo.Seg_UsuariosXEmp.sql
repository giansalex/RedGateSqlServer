SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Seg_UsuariosXEmp]

@RucE nvarchar(11),
@msj varchar(100) output

As

Select 
	NomUsu,upper(NomUsu) As Usuario,upper(NomComp) As Nombre
From 
	Usuario 
Where 
	Cd_Prf in (Select Cd_Prf From AccesoE 
				Where RucE=@RucE Group by Cd_Prf)
	and Estado=1

-- Leyenda --
-- DI : 16/02/2012 <Creacion del SP>				
				
GO
