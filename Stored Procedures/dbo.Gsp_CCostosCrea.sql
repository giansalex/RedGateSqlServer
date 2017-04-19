SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CCostosCrea]
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@Descrip varchar(50),
@NCorto varchar(6),
@msj varchar(100) output
as
if exists (select * from CCostos where RucE=@RucE and Cd_CC=@Cd_CC)
	set @msj = 'Ya existe Centro de Costos'
else
begin
	insert into CCostos(RucE,Cd_CC,Descrip,NCorto)
		     values(@RucE,@Cd_CC,@Descrip,@NCorto)

	if @@rowcount <= 0
	   set @msj = 'Centro de Costos no pudo ser ingresado'
	else
	begin
		insert into CCSub values(@RucE,@Cd_CC,'01010101','GENERAL','GN',0)
		insert into CCSubSub values(@RucE,@Cd_CC,'01010101','01010101','GENERAL','GN',0)
	end
end
print @msj



GO
