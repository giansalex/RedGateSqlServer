SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  view [user321].[VGuiaRemisionLLegada]
as
select  RucE,Cd_GR, Obs, Direc as PuntoLlegada
                from GRPtoLlegada

GO
