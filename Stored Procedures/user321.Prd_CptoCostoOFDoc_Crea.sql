SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_CptoCostoOFDoc_Crea]
@RucE nvarchar(11),
@Cd_OF char(10),
@Id_CCOF int,
@Cd_Com char(10),
@CstAsig numeric(13,2),
@msj varchar(100) output
as
	--if exists (select top 1 * from CptoCostoOFDoc where RucE=@RucE and Cd_OF=@Cd_OF)
	--	set @msj='Registro ya existe'
	--else
	--begin
		insert into CptoCostoOFDoc(RucE,Cd_OF,Id_CCOF,Cd_Com,CstAsig) 
		values(@RucE,@Cd_OF,@Id_CCOF,@Cd_Com,@CstAsig)
	--end

-----leyenda-----------
--JJ 27/02/2011: <Creacion del procedimiento almacenado>
--PP 28/02/2011: <modificacion>


GO
