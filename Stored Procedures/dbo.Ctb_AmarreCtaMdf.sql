SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AmarreCtaMdf]
@ItmA nvarchar(5),
--@RucE nvarchar(11),
--@NroCta nvarchar(10),
@CtaD nvarchar(10),
@CtaH nvarchar(10),
@Porc numeric(6,2),
@msj varchar(100) output
as
if not exists (select * from AmarreCta where ItmA=@ItmA)
	set @msj = 'Amarre Cuenta no existe'
begin
	update AmarreCta set CtaD=@CtaD, CtaH=@CtaH, Porc=@Porc
	where ItmA=@ItmA
	if @@rowcount <= 0
	   set @msj = 'Amarre Cuenta no pudo ser modificado'
end
print @msj
GO
