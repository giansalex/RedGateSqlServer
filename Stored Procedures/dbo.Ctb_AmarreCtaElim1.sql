SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AmarreCtaElim1]
@ItmA nvarchar(5),
@Ejer varchar(4),
@msj varchar(100) output
as
--if not exists (select * from AmarreCta where ItmA=@ItmA and Ejer=@Ejer)
if not exists (select * from AmarreCta where Item=@ItmA and Ejer=@Ejer)
	set @msj = 'Amarre Cuenta no existe'
begin
	--delete from AmarreCta where ItmA=@ItmA and Ejer=@Ejer
	delete from AmarreCta where Item=@ItmA and Ejer=@Ejer
	if @@rowcount <= 0
	   set @msj = 'Amarre Cuenta no pudo ser eliminado'
end
print @msj

--MP : 23/10/2011 : <Creacion del procedimiento almacenado>

GO
