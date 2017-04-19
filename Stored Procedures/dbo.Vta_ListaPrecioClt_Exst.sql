SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create Proc [dbo].[Vta_ListaPrecioClt_Exst] 
@RucE nvarchar(11),
@Cd_Clt char(10),
@Existe bit output
As

--select * from listaprecio_Cliente

if(exists(Select 
	Cd_LP	
From listaprecio_Cliente
Where RucE = @RucE And Cd_Clt = @Cd_Clt))
Set @Existe = 1
else
Set @Existe = 0
GO
