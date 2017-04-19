SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Vta_VendedorConsUn_X_Cd]
@RucE nvarchar(11),
@Cd_Clt char(10)
As 
Select * From Cliente2 Where RucE = @RucE And Cd_Clt = @Cd_Clt
GO
