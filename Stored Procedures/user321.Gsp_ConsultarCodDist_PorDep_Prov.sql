SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Gsp_ConsultarCodDist_PorDep_Prov]
@NombreDep varchar(50),
@NombreProv varchar(50),
@NombreDist varchar(50),
@Cd_UDt nvarchar(6) output
AS
set @Cd_UDt = ( SELECT top 1 udt.cd_udt FROM UDepa udp
join UProv upr ON udp.Nombre like '%'+@NombreDep and Cd_UPv like Cd_UDp+'%' and upr.nombre = @NombreProv
join UDist udt ON udt.Cd_UDt like Cd_UPv+'%' and udt.nombre = SUBSTRING(@NombreDist, 1, LEN(udt.nombre)))

-- MM : CRACION SP - 14/04/11

GO
