SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_EtapaModf]

@RucE	nvarchar	(11),
@Cd_Fab	char	(10),
@ID_Eta	int	output,
@Cd_Flujo	char	(10),
@ID_Prc	int	,
@Cd_Alm	varchar	(20),
@FecIni	datetime	,
@FecFin	datetime	,
@Cd_CC	nvarchar	(8),
@Cd_SC	nvarchar	(8),
@Cd_SS	nvarchar	(8),
@Descrip	varchar	(150),
@Trab	varchar	(100),
@UsuModf	nvarchar	(10),
@CA01	varchar	(100),
@CA02	varchar	(100),
@CA03	varchar	(100),
@CA04	varchar	(100),
@CA05	varchar	(100),
@CA06	varchar	(100),
@CA07	varchar	(100),
@CA08	varchar	(100),
@CA09	varchar	(300),
@CA10	varchar	(300),
@IC_Estado	char	(1),
@Porc int,
@CantEta decimal(13,7),
@HorasTrab decimal(13,7),
@msj varchar(100) output
as
if not exists (select ID_Eta from FabEtapa where RucE=@RucE and ID_Eta= @ID_Eta and Cd_Fab=@Cd_Fab and Cd_Flujo=@Cd_Flujo )
	set @msj = 'Etapa no existe'
else
begin
	update FabEtapa set Cd_Alm = @Cd_Alm, FecIni = @FecIni, FecFin = @FecFin, Cd_CC = @Cd_CC, Cd_SC = @Cd_SC, Cd_SS = @Cd_SS, 
		Descrip = @Descrip, Trab = @Trab, UsuModf = @UsuModf, FecMdf = GETDATE(),
		CA01 = @CA01, CA02 = @CA02, CA03 = @CA03, CA04 = @CA04, CA05 = @CA05, 
		CA06 = @CA06, CA07 = @CA07, CA08 = @CA08, CA09 = @CA09, CA10 = @CA10,
		IC_Estado=@IC_Estado, Porc = @Porc,CantEta=@CantEta,HorasTrab=@HorasTrab
	where RucE = @RucE and Cd_Flujo = @Cd_Flujo and ID_Eta= @ID_Eta and Cd_Fab=@Cd_Fab
	if @@rowcount <= 0
		set @msj = 'Etapa no pudo ser modificado'
end
GO
