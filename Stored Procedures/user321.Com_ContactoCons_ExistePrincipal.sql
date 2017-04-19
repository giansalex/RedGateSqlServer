SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Com_ContactoCons_ExistePrincipal]
@Cd_Prv char(7),
@existePrincipal bit output,
@msj varchar(100) output
as
	if not exists (select * from Proveedor2 where Cd_Prv = @Cd_Prv)
		set @msj = 'No existe el proveedor'
	else
	begin
		if((select count(*) from contacto where IB_Prin = 1 and Cd_Prv = @Cd_Prv)>0) set @existePrincipal = 1
		else set @existePrincipal = 0
	end
GO
