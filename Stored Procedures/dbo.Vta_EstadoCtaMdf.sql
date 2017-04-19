SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Vta_EstadoCtaMdf]
@RucE nvarchar(11),
@Cd_EC int,
@Cd_Clt char(10),
@Cd_TD nvarchar(2),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Cd_Area nvarchar(6),
@Cd_Mda nvarchar(2),
@ReglasMoras varchar(50),
@ReglasPorc varchar(50),
@msj varchar(100) output

as
--print dbo.Cd_SCoEnv('11111111111')

if not exists (select * from EstadoCta where RucE=@RucE and Cd_EC= @Cd_EC)
	Set @msj = 'No existe Estado de Cta.' 
else
begin 
	update EstadoCta 
	set Cd_Clt = @Cd_Clt, Cd_TD = @Cd_TD, Cd_CC = @Cd_CC, Cd_SC = @Cd_SC, 
		Cd_SS = @Cd_SS, Cd_Area = @Cd_Area, Cd_Mda = @Cd_Mda, 
		ReglasMoras = @ReglasMoras, ReglasPorc=@ReglasPorc
	where RucE = @RucE and Cd_EC = @Cd_EC
	if @@rowcount <= 0
		Set @msj = 'Error al modificar Estado de Cta.'
end

-- Leyenda --
-- MP : 2011-05-25 : <Creacion del procedimiento almacenado>
GO
