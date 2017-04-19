SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SeriesXAreaElim]
@Itm_SA int,
@RucE nvarchar(11),
--@Cd_Area nvarchar(6),
--@Cd_Sr nvarchar(4),
@msj varchar(100) output
as
if not exists (select * from SeriesXArea where RucE=@RucE and Itm_SA=@Itm_SA)
	set @msj = 'No se encontro informacion de area'
else
begin
	delete from SeriesXArea where RucE=@RucE and Itm_SA=@Itm_SA

	if @@rowcount <= 0
		set @msj = 'Informacion no pudo ser eliminado'
end
Print @msj
GO
