SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_CodTablaCons](
	@RucE nvarchar(11),
	@Cd_TM char(2),
	@Cd_Tab char(4) output,
	@msj nvarchar(100) output
)
as
if not exists(select * from TipMant where RucE = @RucE and Cd_TM = @Cd_TM)
	set @msj ='Tipo de mantenimiento solicitado no existe.'
else
begin
	declare @nombreTabla varchar(30)
	set @nombreTabla = (select Convert(varchar(30),Descrip) from TipMant where  RucE = @RucE and Cd_TM = @Cd_TM)
	if not exists(select Cd_Tab from Tabla where Nombre = @nombreTabla)
		set @msj = 'Tabla solicitada no existe.'
	else
	begin
		set @Cd_Tab = (select Cd_Tab from Tabla where Nombre = @nombreTabla)
		select * from Tabla where Cd_Tab = @Cd_Tab
	end
end
GO
