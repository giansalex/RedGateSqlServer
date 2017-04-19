SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_SSClaseCons]
@RucE nvarchar(11),
@Cd_CL char(3),
@Cd_CLS char(3),
@TipCons int,
@msj varchar(100) output
as
begin
	if(@TipCons=0)
		select RucE, Cd_CL, Cd_CLS, Cd_CLSS, Nombre, NCorto, CA01, CA02, Estado from ClaseSubSub where RucE=@RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS
	else if(@TipCons=1)
		select Cd_CLSS+'  |  '+Nombre as CodNom, Cd_CLSS,Nombre from ClaseSubSub where RucE=@RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS
	else if(@TipCons=3)
		select Cd_CLSS, Cd_CLSS, Nombre from ClaseSubSub where RucE=@RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS

end
print @msj
GO
