SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SerieMdf]
@RucE nvarchar(11),
@Cd_Sr nvarchar(4),
@Cd_TD nvarchar(2),
@NroSerie nvarchar(5),
@PtoEmision varchar(50),
@msj varchar(100) output
as 
if not exists (select * from Serie where RucE=@RucE and Cd_Sr=@Cd_Sr)
	set @msj = 'Serie no existe'
else
begin
	update Serie set Cd_TD=@Cd_TD, NroSerie=@NroSerie  --, PtoEmision=@PtoEmision
	where RucE=@RucE and Cd_Sr=@Cd_Sr
	if @@rowcount <= 0
	   set @msj = 'Serie no pudo ser modificado'
end
print @msj
GO
