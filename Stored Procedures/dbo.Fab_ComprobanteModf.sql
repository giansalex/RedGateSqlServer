SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Fab_ComprobanteModf]
@RucE nvarchar(11),
@Cd_Fab char(10),
@ID_Com int,
@Ejer nvarchar(8),
@RegCtb nvarchar(30),
@NroCta nvarchar(20),
@CostoAsig numeric(15,7),
@CostoAsig_ME numeric(15,7),
--@Estado bit,
@msj varchar(100) output
as
if not exists (select * from FabComprobante where RucE=@RucE and Cd_Fab=@Cd_Fab)
	set @msj = 'Comprobante no existe'
else

update FabComprobante set ID_Com = @ID_Com, RegCtb = @RegCtb, NroCta = @NroCta, CostoAsig = @CostoAsig,CostoAsig_ME = @CostoAsig_ME

print @msj

--Leyenda

--BG : 06/02/2013 <se creo el SP modificar--(°)>

GO
