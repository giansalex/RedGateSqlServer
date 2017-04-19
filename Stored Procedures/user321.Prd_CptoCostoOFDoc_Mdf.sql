SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_CptoCostoOFDoc_Mdf]
@RucE nvarchar(11),
@Cd_OF char(10),
@Id_CCOF int,
@Cd_Com char(10),
@CstAsig numeric(13,2),
@msj varchar(100) output
as
	if not exists (select * from CptoCostoOFDoc where RucE=@RucE and Cd_OF=@Cd_OF and Id_CCOF=@Id_CCOF)
		set @msj='No existe documento asociado'
	else
	begin
		update CptoCostoOFDoc set Cd_Com=@Cd_Com,CstAsig=@CstAsig 
		where RucE=@RucE and Cd_OF=@Cd_OF and Id_CCOF=@Id_CCOF
		if @@rowcount <= 0
		Set @msj = 'Error al modificar documento asociado'
	end

-----leyenda-----------
--FL 05/03/2011: <Creacion del procedimiento almacenado>





GO
