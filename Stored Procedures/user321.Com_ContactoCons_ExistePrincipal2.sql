SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
create procedure [user321].[Com_ContactoCons_ExistePrincipal2]
@Cd_Prv char(7),
@Cd_Clt char(10),
@existePrincipal bit output,
@msj varchar(100) output
as
	if not exists (select * from Proveedor2 where Cd_Prv = @Cd_Prv) and not exists (select * from Cliente2 where Cd_Clt = @Cd_Clt)
	begin
		if(@Cd_Clt is null)
			set @msj = 'No existe el proveedor'
		else
			set @msj = 'No existe el cliente'
	end
	else
	begin
		if((select count(*) from contacto where IB_Prin = 1 and 
			case when isnull(Cd_prv,isnull(Cd_Clt,'')) <> '' 
				then isnull(Cd_prv,isnull(Cd_Clt,'')) else '' end = isnull(@Cd_Prv,isnull(@Cd_Clt,'')))>0) 
			set @existePrincipal = 1
		else set @existePrincipal = 0
	end
GO
