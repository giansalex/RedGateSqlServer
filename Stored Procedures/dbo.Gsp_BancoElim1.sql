SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_BancoElim1]
@Itm_BC nvarchar(10),
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as
if not exists (select * from Banco where Itm_BC=@Itm_BC and RucE=@RucE and Ejer=@Ejer)
	set @msj = 'Banco no existe'
else
begin
	delete from Banco
	where Itm_BC=@Itm_BC and RucE=@RucE and Ejer=@Ejer

	if @@rowcount <= 0
	   set @msj = 'Banco no pudo ser eliminado'
end
print @msj


GO
