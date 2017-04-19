SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Let_DocsAux3_Vta]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Clt char(10),
@Cd_Vta nvarchar(10),
@msj varchar(100) output

AS
	SELECT 
		v.Cd_Vta,
		'' As Cd_Vou,
		'' As Cd_Ltr,
		v.Cd_TD,
		t.NCorto As NomTD,
		v.NroSre,
		v.NroDoc,
        v.Cd_Mda,
        CASE WHEN v.Cd_TD = '07' THEN - 1 ELSE 1 END * CASE WHEN isnull(v.Cd_Mda, '') = '02' THEN CONVERT(decimal(13, 2), v.Total * v.CamMda) ELSE v.Total END AS SaldoS, 
		CASE WHEN v.Cd_TD = '07' THEN - 1 ELSE 1 END * CASE WHEN isnull(v.Cd_Mda, '') = '02' THEN v.Total ELSE CASE WHEN v.CamMda = 0 THEN 0 ELSE CONVERT(decimal(13,2), v.Total / v.CamMda) END END AS SaldoD
	FROM 
		Venta v
		Left Join TipDoc t On t.Cd_TD=v.Cd_TD
	WHERE 
		v.RucE=@RucE and v.Eje=@Ejer and ISNULL(v.Cd_Clt,'')=@Cd_Clt and Cd_Vta=@Cd_Vta
		
-- Leyenda --
-- DI : 16/08/2012 <Creacion del SP>
GO
