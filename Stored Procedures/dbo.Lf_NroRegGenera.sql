SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lf_NroRegGenera]
@RucE nvarchar(11),
@Prdo nvarchar(2), 
@Cd_MR nvarchar(2),
@Cd_Area nvarchar(6),
@RegCtb nvarchar(15) output, 
@msj varchar(100) output
as

set @RegCtb = dbo.RegCtb_Lf(@RucE, @Cd_MR, @Cd_Area, @Prdo )
print @RegCtb
if @RegCtb = '' or @RegCtb is null
   set @msj = 'No se pudo generar Nro de Registro Contable'
--print @msj
--ESL
GO
