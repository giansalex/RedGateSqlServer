SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_RubrosRptCrea]
--@Cd_Rb nvarchar(4),
@Descrip varchar(50),
@Cd_TR nvarchar(2),
@IN_Nivel smallint,
@Formula varchar(30),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from RubrosRpt where Cd_Rb=user123.Cod_Rb())
	set @msj = 'Error en generar codigo de Rubro'
else if exists (select * from RubrosRpt where Descrip=@Descrip)
	set @msj = 'Ya existe un Rubro con la misma descripcion'
else
begin
	insert into RubrosRpt(Cd_Rb,Descrip,Cd_TR,IN_Nivel,Formula,Estado)
		      values(user123.Cd_Rb(),@Descrip,@Cd_TR,@IN_Nivel,@Formula,1)
	
	if @@rowcount <= 0
	   set @msj = 'Rubro no pudo ser registrado'
end
print @msj
GO
