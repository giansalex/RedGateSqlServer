SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_CptoCostoOF_Crea]
@RucE nvarchar(11),
@Cd_OF char(10),
@Id_CCOF int output,
@Cd_Cos char(2),
@Costo numeric(13,2),
@msj varchar(100) output
as
	Set @Id_CCOF = dbo.Id_CCOF(@RucE, @Cd_OF)	
	if exists (select top 1 *from CptoCostoOF where RucE=@RucE and Cd_OF=@Cd_OF and Id_CCOF=@Id_CCOF)
		set @msj='Cpto. Costo ya existe'
	else
	begin
		insert into CptoCostoOF(RucE,Cd_OF,Id_CCOF,Cd_Cos,Costo) values(@RucE,@Cd_OF,@Id_CCOF,@Cd_Cos,@Costo)
	end
--- leyenda ---
--JJ 27/02/2011  : <Creacion del Procedimiento Almacenado>
--PP 28/02/2011 : modificacion





GO
