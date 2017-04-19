SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_NroSreNroDoc]
@RucE nvarchar(11),
@Codigo nvarchar(10),
@Cd_TDES nchar(2),
@msj varchar(100) output
as
if(@Cd_TDES = 'VT')
begin
	select NroSre + '-' + NroDoc as Nro, Cd_Clt from Venta where RucE = @RucE and Cd_Vta = @Codigo
end
else if(@Cd_TDES = 'CP')
begin
	select NroSre + '-' + NroDoc as Nro, Cd_Prv from Compra where RucE = @RucE and Cd_Com = @Codigo
end
-- Leyenda --
-- CAM : 16/12/2010 : <Creacion del procedimiento almacenado>
-- exec Inv_NroSreNroDoc '11111111111','VT00000386','VT',''
-- exec Inv_NroSreNroDoc '11111111111','CM00000087','CP',''

GO
