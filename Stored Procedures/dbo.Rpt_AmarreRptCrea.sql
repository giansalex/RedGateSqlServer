SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_AmarreRptCrea]
@RucE nvarchar(11),
@NroCta nvarchar(10),
@Cd_Rb nvarchar(4),
@msj varchar(100) output
as
if not exists (select * from RubrosRpt where Cd_Rb=@Cd_Rb)
	set @msj = 'Rubro no existe'
else
begin
	insert into AmarreRpt(RucE,NroCta,Cd_Rb)
		      values(@RucE,@NroCta,@Cd_Rb)
	if @@rowcount <= 0
	   set @msj = 'No se pudo registrar la relacion'
end
print @msj
GO
