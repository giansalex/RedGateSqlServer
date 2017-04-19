SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Doc_ContratoDet_X_Ctt]

@RucE nvarchar(11),
@Cd_Ctt int,
@msj varchar(100) output

AS

Select * from ContratoDet where RucE=@RucE and Cd_Ctt=@Cd_Ctt

GO
