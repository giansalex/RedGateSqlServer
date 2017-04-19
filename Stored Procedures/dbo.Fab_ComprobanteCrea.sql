SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_ComprobanteCrea]
@RucE nvarchar(11),
@Cd_Fab char(10),
@ID_Com int output,
@Ejer nvarchar(8),
@RegCtb nvarchar(30),
@NroCta nvarchar(20),
@CostoAsig numeric(15,7),
@CostoAsig_ME numeric(15,7),
--@Estado bit,
@msj varchar(100) output
as
set @ID_Com = dbo.ID_FabComp(@RucE, @Cd_Fab)
--declare @cost decimal(15,7)
declare @iCom int
--set @cost = (select CostoAsig from FabComprobante where RucE=@RucE and Cd_Fab=@Cd_Fab and RegCtb=@RegCtb and NroCta=@NroCta)

if exists (select ID_Com from FabComprobante where RucE=@RucE and Cd_Fab=@Cd_Fab and RegCtb=@RegCtb and NroCta=@NroCta)
	begin
		set @iCom = (select ID_Com from FabComprobante where RucE=@RucE and Cd_Fab=@Cd_Fab and RegCtb=@RegCtb and NroCta=@NroCta)
		--if(@cost = 0.00 )
		--begin 
		--	delete FabComprobante where RucE = @RucE and Cd_Fab=@Cd_Fab and ID_Com=@iCom and RegCtb=@RegCtb and NroCta=@NroCta and Ejer =@Ejer
		--	if @@rowcount <= 0
		--		set @msj = 'Comprobante de Fabricacion no pudo ser eliminado'
		--end
		--else 
		--begin 
			update FabComprobante set CostoAsig = @CostoAsig, CostoAsig_ME=@CostoAsig_ME
			where Ruce=@RucE and Cd_Fab=@Cd_Fab and ID_Com=@iCom and RegCtb=@RegCtb and NroCta=@NroCta
			if @@rowcount <= 0
				Set @msj = 'Error al modificar la Comprobante de Fabricacion'
		--end
		--set @msj = 'Comprobante ya existe'
	end
else
begin
	insert into FabComprobante(RucE,Cd_Fab,ID_Com,Ejer,RegCtb,NroCta,CostoAsig,CostoAsig_ME)
		  values(@RucE,@Cd_Fab,@ID_Com,@Ejer,@RegCtb,@NroCta,@CostoAsig,@CostoAsig_ME)
	
	if @@rowcount <= 0
		set @msj = 'Comprobante de fabricacion no pudo ser ingresado'
end
print @msj

--Leyenda

--BG : 06/02/2013 <se creo el SP--lalala(♪)>
--CE : 19/05/2013 <Se actualizo SP>


GO
