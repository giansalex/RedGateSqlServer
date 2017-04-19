SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocCons_conNum]
@RucE nvarchar(11),
@msj varchar(100)  output
--with encryption
as

select a.Cd_TD,a.Cd_TD+'  |  '+a.Descrip as CodNom
from TipDoc a, Serie b, Numeracion c
where b.RucE=@RucE and b.Cd_TD=a.Cd_TD and b.RucE = c.RucE and b.Cd_Sr=c.Cd_Sr group by a.Cd_TD,a.Descrip
--PV
GO
