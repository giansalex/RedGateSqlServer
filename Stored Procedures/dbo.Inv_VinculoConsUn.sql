SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_VinculoConsUn]--Consulta x vinculo para Persona referencia
@RucE nvarchar(11),
@Cd_Vin char(2),
@msj varchar(100) output
as
if not exists (select * from Vinculo where RucE= @RucE and Cd_Vin=@Cd_Vin)
	set @msj = 'Vinculo no existe'
else	select * from Vinculo where Cd_Vin=@Cd_Vin
GO
