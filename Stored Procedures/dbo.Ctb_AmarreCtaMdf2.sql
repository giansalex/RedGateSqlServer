SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AmarreCtaMdf2]
@ItmA nvarchar(5),
--@RucE nvarchar(11),
--@NroCta nvarchar(10),
@CtaD nvarchar(15),
@CtaH nvarchar(15),
@Porc numeric(6,2),
@Ejer varchar(4),
@msj varchar(100) output
as
--if not exists (select * from AmarreCta where ItmA=@ItmA and Ejer=@Ejer)
if not exists (select * from AmarreCta where Item=@ItmA and Ejer=@Ejer)
	set @msj = 'Amarre Cuenta no existe'
begin
	update AmarreCta set CtaD=@CtaD, CtaH=@CtaH, Porc=@Porc
	where Item=@ItmA and Ejer=@Ejer
	--where ItmA=@ItmA and Ejer=@Ejer
	if @@rowcount <= 0
	   set @msj = 'Amarre Cuenta no pudo ser modificado'
end
print @msj

--MP : 23/10/2011 : <Creacion del procedimiento almacenado>
GO
