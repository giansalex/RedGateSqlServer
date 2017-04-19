SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionValida_ND]
@RucE nvarchar(11),
@NroSre varchar(5),
@NroGR varchar(15),
@IC_ES char(1),
@msj varchar(100) output,
@Cd_GR char(10) output
as
select @Cd_GR = Cd_GR from GuiaRemision where RucE = @RucE and NroSre = @NroSre and NroGR = @NroGR and IC_ES =@IC_ES
if (isnull(len(@Cd_GR),0) <= 0)
	set @msj = 'Nro Documento no pertenece a ninguna GuiaRemision'
print @msj

-- Leyenda --
-- PP : 2010-06-30 10:36:58.820	: <Creacion del procedimiento almacenado>
GO
