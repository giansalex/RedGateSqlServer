SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_TipCltCons](
	@TipCons int,
	@RucE nvarchar(11),
	@msj varchar(100) output
	)
	as
	begin
	if(@TipCons=0)
		select * from TipClt where RucE = @RucE
	else if(@TipCons = 1)
		select Cd_TClt+'  |  '+Descrip as CodNom from TipClt where Estado = 1 and RucE = @RucE
	else if(@TipCons=3)
		select Cd_TClt,RucE,Descrip from TipClt where Estado = 1	and RucE = @RucE
end
print @msj
--Leyenda
--JV : 13/07/2011 : <Creación de procedimiento almacenado.>
--JV : 20/07/2011 : <Modificación - Se agrega RucE.>
GO
