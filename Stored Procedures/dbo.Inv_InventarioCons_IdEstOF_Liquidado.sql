SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_InventarioCons_IdEstOF_Liquidado]
@RucE nvarchar(11),
@Cd_OF char(10),
@msj varchar(100) output
as
  update OrdFabricacion set Id_EstOF = '04' where RucE = @RucE and Cd_OF = @Cd_OF
GO
