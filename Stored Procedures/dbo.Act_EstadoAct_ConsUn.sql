SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Act_EstadoAct_ConsUn]
@RucE nvarchar(11),
@Cd_EA nvarchar(6),
@msj varchar(100) output
as
if not exists (select * from EstadoAct where RucE=@RucE and Cd_EA=@Cd_EA)
	set @msj = 'Estado Actividad no existe'
else	select * from EstadoAct where RucE=@RucE and Cd_EA=@Cd_EA
print @msj
GO
