SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Prd_FrmlaOFCrea]
        	@RucE nvarchar(11),
        	@Cd_OF char(10),
        	@Item int output,
		@Cd_Prod char(7),
		@ID_UMP int,     
		@CU numeric(13,2),	
		@Cant numeric(13,2),
		@Costo numeric(13,2),
		@Mer numeric(16,2),
		@MerPorc numeric(6,3),
		@Obs varchar(1000),
		@Cd_Cos char(2),
        	@msj varchar(100) output
        	
	as
        
	Set @Item = dbo.ItemFrmlaOF(@RucE,@Cd_OF)	
        	if exists (select * from FrmlaOF where RucE=@RucE and Cd_OF=@Cd_OF and Item=@Item)
	Set @msj = 'Ya existe este item de formula de fabricacion'

	else
	begin 
	insert into FrmlaOF(RucE,Cd_OF,Item,Cd_Prod,ID_UMP,CU,Cant,Costo,Mer,MerPorc,Obs,Cd_Cos)
	values(@RucE,@Cd_OF,@Item,@Cd_Prod,@ID_UMP,@CU,@Cant,@Costo,@Mer,@MerPorc,@Obs,@Cd_Cos)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar formula de orden de fabricacion'
	end
	--- Leyenda ---
	--- FL: 27/02/2011 <creacion del sp>
	--- FL: 02/03/2011 <modificacion del sp>


GO
