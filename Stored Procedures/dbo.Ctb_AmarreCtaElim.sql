SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AmarreCtaElim]
@ItmA nvarchar(5),
@msj varchar(100) output
as
if not exists (select * from AmarreCta where ItmA=@ItmA)
	set @msj = 'Amarre Cuenta no existe'
begin
	delete from AmarreCta where ItmA=@ItmA
	if @@rowcount <= 0
	   set @msj = 'Amarre Cuenta no pudo ser eliminado'
end
print @msj
GO
