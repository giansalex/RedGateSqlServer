SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_VinculoCrea]--Creacion de vinculos para Persona referencia
@RucE nvarchar(11),
@Descrip varchar(100),
@msj varchar(100) output
as
if exists (select * from Vinculo where RucE=@RucE and Descrip = @Descrip)
	set @msj = 'Ya existe una Vínculo con la descripción:['+@Descrip+']'
else
begin
	insert into Vinculo(RucE,Cd_Vin,Descrip,Estado)
		   Values(@RucE,user123.Cd_Vin(@RucE),@Descrip,1)
	
	if @@rowcount <= 0
	set @msj = 'Vínculo no pudo ser registrado'	
end
print @msj
GO
