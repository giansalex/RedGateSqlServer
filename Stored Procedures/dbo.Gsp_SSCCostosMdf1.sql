SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SSCCostosMdf1]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Descrip varchar(50),
@NCorto varchar(6),
@IB_Psp bit,
@msj varchar(100) output
as
if not exists (select * from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS)
	set @msj = 'Sub Sub Centro de Costos no existe'
else
begin
	update CCSubSub set RucE=@RucE, Cd_CC=@Cd_CC, Cd_SC=@Cd_SC, Cd_SS=@Cd_SS, Descrip=@Descrip, NCorto=@NCorto,
			IB_Psp=@IB_Psp
	where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS
	
	if @@rowcount <= 0
	   set @msj = 'Sub Sub Centro de Costos no pudo ser modificado'
end
print @msj



GO