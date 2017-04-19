SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SerieCrea]
@RucE nvarchar(11),
--@Cd_Sr nvarchar(4),
@Cd_TD nvarchar(2),
@NroSerie nvarchar(5),
@PtoEmision varchar(50),
@msj varchar(100) output
as 
if exists (select * from Serie where RucE=@RucE and NroSerie=@NroSerie and Cd_TD=@Cd_TD)
	set @msj = 'Ya existe una Serie con el mismo numero'
else
begin
	insert into Serie(RucE,Cd_Sr,Cd_TD,NroSerie,PtoEmision)
		   values(@RucE,user123.Cod_Sr(@RucE),@Cd_TD,@NroSerie,@PtoEmision)
	if @@rowcount <= 0
	   set @msj = 'Serie no pudo ser registrado'
end
print @msj
GO
