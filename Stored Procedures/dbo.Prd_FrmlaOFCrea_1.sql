SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Prd_FrmlaOFCrea_1]
        	@RucE nvarchar(11),
        	@Cd_OF char(10),
        	@Item int output,
		@Cd_Prod char(7),
		@ID_UMP int,     
		@CU numeric(15, 7),	
		@Cant numeric(15, 7),
		@Costo numeric(15, 7),
		@Mer numeric(16,2),
		@MerPorc numeric(6,3),
		@Obs varchar(1000),
		@Cd_Cos char(2),
		@Costo_ME numeric(15, 7),
		@CU_ME numeric(15, 7),
        	@msj varchar(100) output
        	
	as
        
	Set @Item = dbo.ItemFrmlaOF(@RucE,@Cd_OF)	
        	if exists (select * from FrmlaOF where RucE=@RucE and Cd_OF=@Cd_OF and Item=@Item)
	Set @msj = 'Ya existe este item de formula de fabricacion'

	else
	begin 
	insert into FrmlaOF(RucE,Cd_OF,Item,Cd_Prod,ID_UMP,CU,CU_ME,Cant,Costo,Costo_ME,Mer,MerPorc,Obs,Cd_Cos)
	values(@RucE,@Cd_OF,@Item,@Cd_Prod,@ID_UMP,@CU,@CU_ME,@Cant,@Costo,@Costo_ME,@Mer,@MerPorc,@Obs,@Cd_Cos)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar formula de orden de fabricacion'
	end
	--- Leyenda ---
	--- FL: 02/02/2012 <creacion del sp_1>


GO
