SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [pvo].[Ctb_NroRegGenera]
@RucE nvarchar(11),
@Eje nvarchar(4), 
@Prdo nvarchar(2), 
@Cd_MR nvarchar(2),
@Cd_Area nvarchar(6),
@Cd_Fte nvarchar(2),
@RegCtb nvarchar(15) output, 
@msj varchar(100) output
as

set @RegCtb = dbo.RegCtb_Ctb(@RucE, @Cd_MR, @Cd_Fte, @Cd_Area, @Eje, @Prdo )
print @RegCtb
if @RegCtb = '' or @RegCtb is null
   set @msj = 'No se pudo generar Nro de Regsitro Contable'
--print @msj
--PV
GO
