SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Vta_ListaPrecio_Autorizados_Exst] 
@RucE nvarchar(11),
@Cd_LP char(10),
@NomUsu nvarchar(10),
@Existe bit output
As
if(exists(Select 
	RucE,
	Cd_LP	
From ListaPrecio_Autorizados
Where RucE = @RucE And Cd_LP = @Cd_LP And NomUsu = @NomUsu))
Set @Existe = 1
else
Set @Existe = 0
GO
