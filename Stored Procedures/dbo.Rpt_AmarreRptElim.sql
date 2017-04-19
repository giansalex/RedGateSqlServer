SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_AmarreRptElim]
@RucE nvarchar(11),
@NroCta nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from AmarreRpt where RucE=@RucE and NroCta=@NroCta)
	set @msj = 'No se encontro dicha relacion'
else
begin
	delete from AmarreRpt where RucE=@RucE and NroCta=@NroCta
	if @@rowcount <= 0
	   set @msj = 'No se pudo eliminar la relacion'
end
print @msj
GO
