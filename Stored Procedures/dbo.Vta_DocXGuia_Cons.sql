SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[Vta_DocXGuia_Cons]
	@RucE nvarchar(11),
	@Cd_GR char(10)
As
Select 
			* 
From 
			Venta As Vta 
Inner Join 
			GuiaXVenta As Gr 
On 
			Vta.RucE = Gr.RucE 
			And 
			Vta.Cd_Vta = Gr.Cd_Vta
Where
			Vta.RucE = @RucE
			And
			Gr.Cd_GR = @Cd_GR
GO
