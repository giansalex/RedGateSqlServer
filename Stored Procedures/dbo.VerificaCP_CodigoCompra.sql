SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[VerificaCP_CodigoCompra]
@RucE nvarchar(11),
@Cd_Com char(10),
@msj varchar(100) output
as
if exists (select * from Compra where RucE=@RucE and Cd_Com=@Cd_Com)
	Set @msj = 'Ya existe codigo de compra'
GO
