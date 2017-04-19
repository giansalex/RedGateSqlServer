SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Inv_ProdUMConsUnPrin]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output
as
select * from Prod_UM where RucE = @RucE and 
Cd_Prod = @Cd_Prod and IB_UMPPrin = 1
GO
