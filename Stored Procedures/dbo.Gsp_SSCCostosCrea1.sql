SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SSCCostosCrea1]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Descrip varchar(50),
@NCorto varchar(6),
@IB_Psp bit,
@msj varchar(100) output
as
if not exists (select * from CCSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC)
	set @msj = 'No existe Sub Centro de Costos'
else if exists (select * from CCSubSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS)
	set @msj = 'Ya existe Sub Sub Centro de Costos'
else
begin
	insert into CCSubSub(RucE,Cd_CC,Cd_SC,Cd_SS,Descrip,NCorto,IB_Psp)
	              values(@RucE,@Cd_CC,@Cd_SC,@Cd_SS,@Descrip,@NCorto,@IB_Psp)
	
	if @@rowcount <= 0
	   set @msj = 'Sub Sub Centro de Costos no pudo ser ingresado'
end
print @msj



GO
