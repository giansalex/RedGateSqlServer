SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AmarreCtaCons]
@RucE nvarchar(11),
@msj varchar(100) output
as
/*if not exists (select top 1 * from AmarreCta where RucE=@RucE)
	set @msj = 'No hay Amarre Cuentas'
else*/	select * from AmarreCta where RucE=@RucE
print @msj
GO
