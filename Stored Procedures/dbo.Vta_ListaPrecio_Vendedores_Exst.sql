SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Vta_ListaPrecio_Vendedores_Exst] 
@RucE nvarchar(11),
@Cd_LP char(10),
@Cd_Vdr char(7),
@Existe bit output
As
if(exists(Select 
	RucE,
	Cd_LP	
From ListaPrecio_Vendedores
Where RucE = @RucE And Cd_LP = @Cd_LP And Cd_Vdr = @Cd_Vdr))
Set @Existe = 1
else
Set @Existe = 0
GO
