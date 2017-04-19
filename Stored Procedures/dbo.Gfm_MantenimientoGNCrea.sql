SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_MantenimientoGNCrea](
	@RucE		nvarchar(11)			,
	@Cd_TM		char(2)					,
	@Cd_Mnt		char(6)			output	,
	@Codigo		varchar(20)				,
	@Descrip	varchar(4000)			,
	@CA01		varchar(100)			,
	@CA02		varchar(100)			,
	@CA03		varchar(100)			,
	@CA04		varchar(100)			,
	@CA05		varchar(100)			,
	@CA06		varchar(100)			,
	@CA07		varchar(100)			,
	@CA08		varchar(100)			,
	@CA09		varchar(100)			,
	@CA10		varchar(100)			,
	@Estado		bit						,
	@msj		varchar(100)	output
)
AS
SET @Cd_Mnt = dbo.Cd_Mnt(@RucE,@Cd_TM)
INSERT INTO MantenimientoGN(
							RucE,
							Cd_TM,
							Cd_Mnt,
							Codigo,
							Descrip,
							CA01,
							CA02,
							CA03,
							CA04,
							CA05,
							CA06,
							CA07,
							CA08,
							CA09,
							CA10,
							Estado
							)
VALUES(	@RucE,
		@Cd_TM,
		@Cd_Mnt,
		@Codigo,
		@Descrip,
		@CA01,
		@CA02,
		@CA03,
		@CA04,
		@CA05,
		@CA06,
		@CA07,
		@CA08,
		@CA09,
		@CA10,
		@Estado
		)
if @@rowcount <= 0
	set @msj = 'Mantenimiento no pudo ser registrado.'

GO
