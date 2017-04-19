SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ClaseCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin
	if(@TipCons=0)
		 select * from Clase where RucE=@RucE
	else if(@TipCons=1)
		select Cd_CL+'  |  '+Nombre as CodNomCL,Cd_CL,Nombre from Clase where RucE=@RucE
	else if(@TipCons=3)
		select Cd_CL, Cd_CL, Nombre from Clase where RucE=@RucE -- and Estado=1

end
print @msj
GO
