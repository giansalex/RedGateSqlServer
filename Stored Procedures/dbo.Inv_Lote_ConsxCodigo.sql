SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_Lote_ConsxCodigo]
@RucE nvarchar(11),
@Cd_Lote char(10),
@msj varchar(100) OUTPUT
as
	SELECT 
	l.RucE,
	l.Cd_Prov,
	l.Cd_Lote,
	l.NroLote,
	l.Descripcion,
	l.FecCaducidad,
	l.UsuCrea,
	l.UsuModf,
	l.FecReg,
	l.FecModf,
	l.FecFabricacion,
	p.Cd_TDI,p.NDoc,case(isnull(len(p.RSocial),0)) when 0 
			then p.ApPat +' '+ p.ApMat +','+ p.Nom else p.RSocial end as NombreProv
	FROM dbo.Lote l 
	left join Proveedor2 p on p.RucE = l.RucE and p.Cd_Prv = l.Cd_Prov
	WHERE l.RucE =@RucE  AND l.Cd_Lote = @Cd_Lote
GO
