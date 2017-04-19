SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SeriesXAreaCrea]
--@Itm_SA
@RucE nvarchar(11),
@Cd_Area nvarchar(6),
@Cd_Sr nvarchar(4),
@msj varchar(100) output
as
if not exists (select * from Serie where RucE=@RucE and Cd_Sr=@Cd_Sr)
	set @msj = 'No se encontro serie'
else
begin
	if exists (select * from SeriesXArea where RucE=@RucE and Cd_Sr=@Cd_Sr and Cd_Area=@Cd_Area)
	begin
		set @msj = 'Esta area ya existe en esta Serie'
		return 
	end

	Declare @Itm_SA int
	Set @Itm_SA = (select isnull(max(Itm_SA),0)+1 from SeriesXArea Where RucE=@RucE)
	insert into SeriesXArea(Itm_SA,RucE,Cd_Area,Cd_Sr)
		         Values(@Itm_SA,@RucE,@Cd_Area,@Cd_Sr)

	if @@rowcount <= 0
		set @msj = 'Area no pudo ser ingresada a Serie'
end
Print @msj
GO
