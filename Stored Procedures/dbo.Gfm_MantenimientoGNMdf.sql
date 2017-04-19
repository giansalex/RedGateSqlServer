SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_MantenimientoGNMdf](
	@RucE		nvarchar(11)			,
	@Cd_TM		char(2)					,
	@Cd_Mnt		char(6)					,
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
If not exists(select * from MantenimientoGN where RucE = @RucE and Cd_TM = @Cd_TM and Cd_Mnt = @Cd_Mnt)
	set @msj = 'Mantenimiento no existe.'
else
begin
	update MantenimientoGN
	set		Codigo	=	@Codigo		,
			Descrip	=	@Descrip	,
			CA01	=	@CA01		,
			CA02	=	@CA02		,
			CA03	=	@CA03		,
			CA04	=	@CA04		,
			CA05	=	@CA05		,
			CA06	=	@CA06		,
			CA07	=	@CA07		,
			CA08	=	@CA08		,
			CA09	=	@CA09		,
			CA10	=	@CA10		,
			Estado	=	@Estado
	where	RucE	=	@RucE	and
			Cd_TM	=	@Cd_TM	and
			Cd_Mnt	=	@Cd_Mnt
	if @@rowcount <= 0
		set @msj = 'Mantenimiento no pudo ser modificado.'
end
print @msj
GO
