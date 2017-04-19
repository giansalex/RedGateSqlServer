SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Ctb_ConceptosDetracElim]
@RucE nvarchar(11),
@Cd_CDtr char(4),
@msj varchar(100) output
as

begin 
begin transaction
	if exists (select top 1 *from CptoDetxProv where RucE=@RucE  and Cd_CDtr=@Cd_CDtr)
		set @msj='Error al eliminar Concepto de Detraccion, proveedor relacionado'
	else if exists (select top 1 *from ConceptosDetrac Where RucE=@RucE and Cd_CDtr=@Cd_CDtr)
	begin

		delete ConceptoDetracHist Where RucE=@RucE and Cd_CDtr=@Cd_CDtr
		delete ConceptosDetrac where RucE=@RucE and Cd_CDtr=@Cd_CDtr
		if @@rowcount <=0
		begin
			set @msj='Error al eliminar Concepto de Detraccion'
			rollback transaction
			return
		end
	end
commit transaction
end
-- Leyenda --
-- JJ : 2011-02-07 : <Creacion del procedimiento almacenado>
GO
