SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create Proc [dbo].[Vta_ElimListaPrecioXClt] 
@RucE nvarchar(11),
@Cd_Clt char(10)

As

--select * from listaprecio_Cliente

delete	
listaprecio_Cliente
Where RucE = @RucE And Cd_Clt = @Cd_Clt
GO
