SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Prd_FrmlaOFMdf]
        	@RucE nvarchar(11),
        	@Cd_OF char(10),
        	@Item int,
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
        	
       	if not exists (select * from FrmlaOF where RucE=@RucE and Cd_OF=@Cd_OF and Item=@Item)
	Set @msj = 'No existe este item de formula de fabricacion'

	else
	begin 
	update FrmlaOF set
	Cd_Prod=@Cd_Prod,ID_UMP=@ID_UMP,CU=@CU,Cant=@Cant,Costo=@Costo,Mer=@Mer,MerPorc=@MerPorc,Obs=@Obs,Cd_Cos=@Cd_Cos
	where RucE=@RucE and Cd_OF=@Cd_OF and Item=@Item
	if @@rowcount <= 0
		Set @msj = 'Error al modificar formula de orden de fabricacion'
	end
	--- Leyenda ---
	--- FL: 04/03/2011 <creacion del sp>

GO
