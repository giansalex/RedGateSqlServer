SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Gfm_TipMantMdf](
	@Cd_TM char(2) output,
	@RucE nvarchar(11),
	@Descrip varchar(100),
	@Es_MntGN bit,
	@Estado bit,
	@msj varchar(100) output
)
AS
if not exists(select * from TipMant where Cd_TM = @Cd_TM and RucE = @RucE)
	set @msj='Tipo de mantenimineto no existe.'
else
begin
	declare @Cd_Tab char(4)
	declare @nombreTabla varchar(30)
	set @nombreTabla = (select Descrip from TipMant where Cd_TM = @Cd_TM and RucE = @RucE)
	set @Cd_Tab = (select Cd_Tab from Tabla where Nombre = @nombreTabla)
	begin transaction
	update TipMant
	set		Descrip		= @Descrip,
			Estado		= @Estado,
			Es_MntGN	= @Es_MntGN
	where	Cd_TM		= @Cd_TM and
			RucE		= @RucE
	if @@rowcount	<= 0
	begin
		set @msj	=	'Tipo de mantenimineto no pudo ser modificado.'
	end
	else
	begin
		update Tabla
			set Nombre = @Descrip
		where Cd_Tab = @Cd_Tab
		
		if @@rowcount <=0
		begin
			set @msj = 'Tipo de mantenimiento no pudo ser modificado. ya modifico el primero'
			rollback transaction
		end
		else
		begin
			commit transaction
		end
	end
	
end
GO
