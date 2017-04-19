SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccesoECons]
@Cd_Prf nvarchar(3),
@msj varchar(100) output
as
select a.RucE,e.RSocial,1 as Asig from AccesoE a, Empresa e where Cd_Prf=@Cd_Prf and a.RucE=e.Ruc
UNION ALL
select Ruc as RucE,RSocial,0 as ASig from Empresa where Ruc not in (select RucE from AccesoE where Cd_Prf=@Cd_Prf)
Order by 2
GO
