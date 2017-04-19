SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AmarreCtaConsUn1]
@ItmA nvarchar(5),
@Ejer varchar(4),
@msj varchar(100) output
as
--if not exists (select * from AmarreCta where ItmA=@ItmA)
if not exists (select * from AmarreCta where Item=@ItmA)
	set @msj = 'Amarre Cuenta no existe'
else	select * from AmarreCta where Item=@ItmA and Ejer=@Ejer
print @msj

--MP : 23/10/2011 : <Creacion del procedimiento almacenado>


GO
