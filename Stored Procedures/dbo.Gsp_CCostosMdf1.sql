SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CCostosMdf1]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Descrip varchar(50),
@NCorto varchar(6),
@IB_Psp bit,
@msj varchar(100) output
as
if not exists (select * from CCostos where RucE=@RucE and Cd_CC=@Cd_CC)
	set @msj = 'Centro de Costos no existe'
else
begin
	update CCostos set Descrip=@Descrip, NCorto=@NCorto, IB_Psp=@IB_Psp
	where RucE=@RucE and Cd_CC=@Cd_CC

	if @@rowcount <= 0
	   set @msj = 'Centro de Costos no pudo ser modificado'
end
print @msj



GO
