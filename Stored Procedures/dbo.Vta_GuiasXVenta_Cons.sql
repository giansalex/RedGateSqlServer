SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Vta_GuiasXVenta_Cons]
@RucE nvarchar(11),
@Cd_Vta char(10)
As
Select [RucE]
      ,[Cd_GR]
      ,[Cd_Vta]
      From [GuiaXVenta]
      Where RucE = @RucE And Cd_Vta = @Cd_Vta
GO
