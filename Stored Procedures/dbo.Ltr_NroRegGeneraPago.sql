SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ltr_NroRegGeneraPago]
@RucE nvarchar(11),
@Ejer nvarchar(4), 
@Prdo nvarchar(2), 
@Cd_MR nvarchar(2),
@Cd_Area nvarchar(6),
@RegCtb nvarchar(15) output, 
@msj varchar(100) output
as

set @RegCtb = dbo.RegCtb_LtrPago(@RucE, @Cd_MR, @Cd_Area, @Ejer, @Prdo )
print @RegCtb
if @RegCtb = '' or @RegCtb is null
   set @msj = 'No se pudo generar Nro de Regsitro Contable'
--print @msj
--DI
GO
