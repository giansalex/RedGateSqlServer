SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_SClaseCons]
@RucE nvarchar(11),
@TipCons int,
@Cd_CL char(3),
@msj varchar(100) output
as
begin
	if(@TipCons=0)
		select * from ClaseSub where RucE=@RucE and Cd_CL=@Cd_CL
	else if(@TipCons=1)
		select Cd_CLS+'  |  '+Nombre as CodNomCL,Cd_CLS,Nombre from ClaseSub where RucE=@RucE and Cd_CL=@Cd_CL
	else if(@TipCons=3)
		select Cd_CLS, Cd_CLS, Nombre from ClaseSub where RucE=@RucE and Cd_CL=@Cd_CL

end
print @msj
GO
