SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_EnvEmbOFMdf_1]
@RucE nvarchar(11),
@Cd_OF char(10),
@Item int,
@Cd_Prod char(7),
@ID_UMP	int,
@CU numeric(15, 7),
@Cant numeric(15, 7),
@Costo numeric(15, 7),
@Cd_Cos char(2),
@CU_ME numeric(15, 7),
@Costo_ME numeric(15, 7),
@msj varchar(100) output
as
		if not exists (select top 1 * from EnvEmbOF where RucE=@RucE and Cd_OF=@Cd_OF and Item=@Item)
		set @msj='Env. y Emb. no existe'
		else
		begin
			update EnvEmbOF set Cd_Prod=@Cd_Prod,ID_UMP=@ID_UMP,CU=@CU,CU_ME=@CU_ME,Cant=@Cant,Costo=@Costo,Costo_ME=@Costo_ME,Cd_Cos=@Cd_Cos
			where RucE=@RucE and Cd_OF=@Cd_OF and Item=@Item
			if @@rowcount <= 0	
			Set @msj = 'Error al modificar env. y emb.'
		end
	

-----leyenda-----------
--FL 04/03/2011: <se creo procedimiento almacenado>
--Act: 02/02/2012 <se agrego @CU_ME @Costo_ME>







GO
