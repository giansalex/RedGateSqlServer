SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CCostosConsUn]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@msj varchar(100) output
as
if not exists (select * from CCostos where RucE=@RucE and Cd_CC=@Cd_CC)
	set @msj = 'Centro de Costos no existe'
else	select * from CCostos where RucE=@RucE and Cd_CC=@Cd_CC
print @msj
GO
