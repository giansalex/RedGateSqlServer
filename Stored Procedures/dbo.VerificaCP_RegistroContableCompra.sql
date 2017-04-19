SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[VerificaCP_RegistroContableCompra]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
@msj varchar(100) output
as
if exists (select * from Compra where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
	Set @msj = 'Ya existe registro contable en compra'
GO
