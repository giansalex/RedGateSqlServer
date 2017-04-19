SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_AmarreRptMdf]
@RucE nvarchar(11),
@NroCta nvarchar(10),
@Cd_Rb nvarchar(4),
@msj varchar(100) output
as
if not exists (select * from AmarreRpt where RucE=@RucE and NroCta=@NroCta)
	set @msj = 'No se encontro dicha relacion'
else
begin
	update AmarreRpt set Cd_Rb=@Cd_Rb
	where RucE=@RucE and NroCta=@NroCta
	if @@rowcount <= 0
	   set @msj = 'No se pudo modificar la relacion'
end
print @msj
GO
