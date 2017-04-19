SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Seg_AccesoECons_conAcc]

@Cd_Prf nvarchar(6),
@msj varchar(100) output

AS

Select 
	0 As Sel, a.RucE,e.RSocial,a.Cd_GA,g.Descrip
From 
	AccesoE a
	Left Join Empresa e On e.Ruc=a.RucE
	Left Join GrupoAcceso g On g.Cd_GA=a.Cd_GA
Where 
	a.Cd_Prf=@Cd_Prf

-- Leyenda --
-- DI : 13/07/2011 <Creacion del procedimiento almacenado>

GO
