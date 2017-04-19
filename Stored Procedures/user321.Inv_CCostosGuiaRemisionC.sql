SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_CCostosGuiaRemisionC]
@RucE nvarchar(11),
@Cd_Com char(10),
@Ejer nvarchar(4),
@msj varchar(100) output
as
if not exists (select * from Compra where RucE=@RucE and Ejer=@Ejer and Cd_Com=@Cd_Com)
	set @msj = 'Compra no ha sido creada'
else
begin
	select Cd_CC,Cd_SC,Cd_SS from Compra where RucE=@RucE and Ejer=@Ejer and Cd_Com=@Cd_Com
	
	if @@rowcount <= 0
		set @msj = 'Centros de Costo no pueden ser consultados'
end
print @msj

GO
