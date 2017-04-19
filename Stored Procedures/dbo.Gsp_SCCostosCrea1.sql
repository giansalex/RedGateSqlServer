SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SCCostosCrea1]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Descrip varchar(50),
@NCorto varchar(6),
@IB_Psp bit,
@msj varchar(100) output
as
if exists (select * from CCSub where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC)
	set @msj = 'Ya existe Sub Centro de Costos'
else
begin
	insert into CCSub(RucE,Cd_CC,Cd_SC,Descrip,NCorto,IB_Psp)
		   values(@RucE,@Cd_CC,@Cd_SC,@Descrip,@NCorto,@IB_Psp)
	if @@rowcount <= 0
	   set @msj = 'Sub Centro de Costos no pudo ser ingresado'
	else
	begin
		insert into CCSubSub values(@RucE,@Cd_CC,@Cd_SC,'01010101','GENERAL','GN',0)
	end
end
print @msj



GO
