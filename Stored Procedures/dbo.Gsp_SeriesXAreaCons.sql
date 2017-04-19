SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SeriesXAreaCons]  ---> deberia llamarse Gsp_AreasXSerieCons
--@Itm_SA int,
@RucE nvarchar(11),
@Cd_Sr nvarchar(4),
@msj varchar(100) output
as
/*if not exists (select * from SeriesXArea where RucE=@RucE and Cd_Sr=@Cd_Sr)
	set @msj = 'No se encontro informacion de area'
else*/	select a.Itm_SA,a.Cd_Area,b.Descrip from SeriesXArea a, Area b where a.RucE=@RucE and a.Cd_Sr=@Cd_Sr and a.RucE=b.RucE and a.Cd_Area=b.Cd_Area
Print @msj
--PV: 13/03/2009 VIE --> Comentado
GO
