SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_TipProvMdf](
@Cd_TPrv char(3),
@RucE nvarchar(11),
@Descrip varchar(100),
@Estado bit,
@msj varchar(100)  output
)
as
if not exists(select * from TipProv where Cd_TPrv = @Cd_TPrv)
	set @msj = 'Tpo de proveedor no existe.'
else
begin
	update	TipProv
	set		Descrip	=	@Descrip,
			Estado	=	@Estado
	where	Cd_TPrv	=	@Cd_TPrv and
			RucE = @RucE
	
	if @@rowcount	<= 0
		set @msj	=	'Tipo de proveedor no pudo ser modificado.'
end
print @msj
GO
