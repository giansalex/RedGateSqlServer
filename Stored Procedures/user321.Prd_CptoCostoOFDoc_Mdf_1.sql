SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [user321].[Prd_CptoCostoOFDoc_Mdf_1]
@RucE nvarchar(11),
@Cd_OF char(10),
@Id_CCOF int,
@Cd_Com char(10),
@CstAsig numeric(13,2),
@Cd_Mda char(2),
@CamMda decimal(6,3),
@msj varchar(100) output
as
	if not exists (select * from CptoCostoOFDoc where RucE=@RucE and Cd_OF=@Cd_OF and Id_CCOF=@Id_CCOF)
		set @msj='No existe documento asociado'
	else
	begin
		update CptoCostoOFDoc set Cd_Com=@Cd_Com,CstAsig=@CstAsig, Cd_Mda=@Cd_Mda, CamMda=@CamMda
		where RucE=@RucE and Cd_OF=@Cd_OF and Id_CCOF=@Id_CCOF
		if @@rowcount <= 0
		Set @msj = 'Error al modificar documento asociado'
	end

-----leyenda-----------
--11/02/2012: <cambio>





GO
