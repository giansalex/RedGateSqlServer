SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipGastoCrea]
--@Cd_TG nvarchar(2),
@Nombre varchar(50),
@Estado bit,
@msj varchar(100) output
as
if exists (select * from TipGasto where Nombre=@Nombre)
	set @msj = 'Ya existe un Tipo Gasto con ese nombre'
else
begin
	insert into TipGasto(Cd_TG,Nombre,Estado)
		      Values(user123.Cod_TG(),@Nombre,@Estado)
	
	if @@rowcount <= 0
		set @msj = 'Tipo Gasto no pudo ser registrado'
end
print @msj
-- DI 13/02/2009
GO
