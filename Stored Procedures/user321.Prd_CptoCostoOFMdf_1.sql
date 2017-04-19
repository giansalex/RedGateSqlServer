SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_CptoCostoOFMdf_1]
@RucE nvarchar(11),
@Cd_OF char(10),
@Id_CCOF int,
@Cd_Cos char(2),
@Costo numeric(15, 7),
@Costo_ME numeric(15, 7),
@msj varchar(100) output
as

	if not exists (select top 1 * from CptoCostoOF where RucE=@RucE and Cd_OF=@Cd_OF and Id_CCOF=@Id_CCOF)
		set @msj='Cpto. Costo no existe'
	else
	begin
		update CptoCostoOF set Cd_Cos=@Cd_Cos,Costo=@Costo,Costo_ME=@Costo_ME
		where RucE=@RucE and Cd_OF=@Cd_OF and Id_CCOF=@Id_CCOF
		if @@rowcount <= 0
		Set @msj = 'Error al modificar formula de orden de fabricacion'
	end
--- leyenda ---
--FL 04/03/2011  : <Creacion del Procedimiento Almacenado>







GO
