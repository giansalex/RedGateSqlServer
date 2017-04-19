SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AmarreCtaConsUn]
@ItmA nvarchar(5),
@msj varchar(100) output
as
if not exists (select * from AmarreCta where ItmA=@ItmA)
	set @msj = 'Amarre Cuenta no existe'
else	select * from AmarreCta where ItmA=@ItmA
print @msj
GO
