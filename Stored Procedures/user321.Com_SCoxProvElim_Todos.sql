SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Com_SCoxProvElim_Todos]
@RucE nvarchar(11),
@Cd_SCo char(10),
@msj varchar(100) output
as

if not exists (select * from SCxProv where RucE = @RucE and Cd_SCo = @Cd_SCo)
	return
else

begin
	delete from SCxProv 
	where RucE = @RucE and Cd_SCo = @Cd_Sco
	
	if @@rowcount <= 0
	begin
		set @msj = 'Los proveedores anexados de la solicitud de compra no pudo ser eliminado'
	end
end
GO
