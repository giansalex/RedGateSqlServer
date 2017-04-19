SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_TipProvCons](
	@TipCons int,
	@RucE nvarchar(11),
	@msj varchar(100) output
)
as
begin
	if(@TipCons=0)
		select * from TipProv where RucE = @RucE
	else if(@TipCons = 1)
		select Cd_TPrv+'  |  '+Descrip as CodNom from TipProv where Estado = 1 and RucE = @RucE
	else if(@TipCons=3)
		select Cd_TPrv,RucE,Descrip from TipProv where Estado = 1 and RucE = @RucE
end
print @msj
--Leyenda
--JV : 09/07/2011 : <Creación de procedimiento almacenado.>
GO
