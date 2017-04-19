SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Vta_ListaPrecio_Area_Exst] 
@RucE nvarchar(11),
@Cd_LP char(10),
@Cd_Area nvarchar(6),
@Existe bit output
As
if(exists(Select 
	RucE,
	Cd_LP	
From ListaPrecio_Area
Where RucE = @RucE And Cd_LP = @Cd_LP And Cd_Area = @Cd_Area))
Set @Existe = 1
else
Set @Existe = 0
GO
