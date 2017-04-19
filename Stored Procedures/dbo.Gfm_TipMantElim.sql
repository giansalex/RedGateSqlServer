SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_TipMantElim](
	@Cd_TM char(3),
	@RucE nvarchar(11),
	@msj varchar(100) output
)
AS

declare @nombreTabla varchar(30)
declare @cdTabla  char(4)
set @nombreTabla = (select Descrip from TipMant where RucE = @RucE and Cd_TM = @Cd_TM)

if(not exists(select * from Tabla where Nombre = @nombreTabla))
begin
	set @msj = 'No se puede eliminar tipo de mantenimiento.'
end
else
begin
	set @cdTabla = (select Cd_Tab from Tabla where Nombre = @nombreTabla)
	if	not exists(select * from TipMant where Cd_TM = @Cd_TM and RucE = @RucE )
		set @msj = 'Tipo de mantenimiento no existe'
	else
	begin
		begin transaction
		delete TablaxMod where Cd_Tab = @cdTabla
		delete CampoTabla where Cd_Tab = @cdTabla
		delete Tabla where Cd_Tab = @cdTabla
		if(@@rowcount <=0)
			set @msj = 'Tipo de mantenimiento no pudo ser eliminado'
		else
		begin
			delete TipMant where Cd_TM = @Cd_TM and RucE = @RucE
			if @@rowcount <= 0
			begin
				set @msj = 'Tipo de mantenimiento no pudo ser eliminado'
				rollback transaction
			end
			commit transaction
		end
	end
end
print @msj

--MP: 31/05/2012 <Modificacion del procedimiento almacenado, faltaba agregar RucE a la primera busqueda de la Descrip>
--MP: 20/07/2012 <Modificacion del procedimiento almacenado, para que elimine de otra tabla mas>

GO
