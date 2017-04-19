SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[Vta_ListaPrecio_Productos_Exst] 
@RucE nvarchar(11),
@Cd_LP char(10),
@Cd_Prod char(7),
@UMP int,
@Existe bit output
As
if(exists(Select 
	RucE,
	Cd_LP	
From ListaPrecioDet
Where RucE = @RucE And Cd_LP = @Cd_LP And UMP = @UMP And Cd_Prod = @Cd_Prod))
Set @Existe = 1
else
Set @Existe = 0
GO
