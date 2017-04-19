SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_ComprobanteElim]

@RucE nvarchar(11),
@Cd_Fab char(10),
@ID_Com int,
@msj varchar(100) output
as
if not exists (select Cd_Fab from FabComprobante where RucE=@RucE and Cd_Fab=@Cd_Fab and ID_Com = @ID_Com)
	set @msj = 'Comprobante de Fabricación no existe'
else
begin
	begin transaction
	delete FabComprobante where RucE=@RucE and Cd_Fab=@Cd_Fab and ID_Com = @ID_Com
	if @@rowcount <= 0
		set @msj = 'Comprobante de Fabricación no pudo ser eliminado'
	commit transaction
end
print @msj

--Leyenda 

--BG : 08/02/2013 <se creo SP>

--exec Fab_ComprobanteElim '11111111111','FAB0000004',2,''
GO
