SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_EnvEmbOF_Crea]
@RucE nvarchar(11),
@Cd_OF char(10),
@Cd_Prod char(7),
@ID_UMP	int,
@CU numeric(13,2),
@Cant numeric(16,6),
@Costo numeric(13,2),
@Cd_Cos char(2),
@msj varchar(100) output
as
	
		insert into EnvEmbOF(RucE,Cd_OF,Item,Cd_Prod,ID_UMP,CU,Cant,Costo,Cd_Cos) values
		(@RucE,@Cd_OF, user123.Itm_EEOF(@RucE ,@Cd_OF ),@Cd_Prod,@ID_UMP,@CU,@Cant,@Costo,@Cd_Cos)
	

-----leyenda-----------
--JJ 27/02/2011: <Creacion del procedimiento almacenado>
--PP 28/02/2011 modificacion
--FL 02/03/2011: <se agrego el campo @Cd_Cos>




GO
