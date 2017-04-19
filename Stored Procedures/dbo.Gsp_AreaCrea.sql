SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_AreaCrea]
@RucE nvarchar(11),
@Cd_Area nvarchar(6),
@Descrip varchar(50),
@NCorto varchar(6),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from Area where RucE=@RucE and Cd_Area=@Cd_Area)
	set @msj = 'Area ya existe'
else
begin
	insert into Area(RucE,Cd_Area,Descrip,NCorto,Estado)
		  values(@RucE,@Cd_Area,@Descrip,@NCorto,1)
	
	if @@rowcount <= 0
		set @msj = 'Area no pudo ser ingresado'
end
print @msj
GO
