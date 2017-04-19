SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_CanjeVerifica_X_RegCtb]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Cnj char(10),
@msj varchar(100) output

AS

Declare @RegCtb nvarchar(15)
Set @RegCtb=(Select RegCtb From Canje Where RucE=@RucE and Cd_Cnj=@Cd_Cnj)

if exists (Select * From Voucher Where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
begin
	Set @msj = 'Registro esta relacionado con un asiento contable '+@RegCtb
end

-- Leyenda --
-- DI : 10/03/2012 <Creacion del SP>

GO
