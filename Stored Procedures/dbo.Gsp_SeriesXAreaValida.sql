SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SeriesXAreaValida]
--@Itm_SA int,
@RucE nvarchar(11),
@Cd_Area nvarchar(6),
@Cd_Sr nvarchar(4),
@msj varchar(100) output
as
if not exists (select * from SeriesXArea where RucE=@RucE and Cd_Sr=@Cd_Sr and Cd_Area=@Cd_Area )
	set @msj = 'Serie no pertenece a Pto de emisión o Area establecida'

Print @msj
--PV: 13/03/2009 VIE --> Creado
GO
