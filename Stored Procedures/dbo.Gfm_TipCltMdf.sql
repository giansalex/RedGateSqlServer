SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_TipCltMdf](
	@Cd_TClt char(3),
	@RucE nvarchar(11),
@Descrip varchar(100),
@Estado bit,
@msj varchar(100)  output
)
as
if not exists(select * from TipClt where Cd_TClt = @Cd_TClt and RucE = @RucE)
	set @msj = 'Tipo de cliente no existe.'
else
begin
	update	TipClt
	set		Descrip	=	@Descrip,
			Estado	=	@Estado
	where	Cd_TClt	=	@Cd_TClt and
			RucE = @RucE
	
	if @@rowcount	<= 0
		set @msj	=	'Tipo de cliente no pudo ser modificado.'
end
print @msj
GO
