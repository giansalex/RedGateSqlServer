SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_VentaConsUn]

@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Vta nvarchar(10),
@msj varchar(100) output

AS

Select 
	v.Cd_Vta,
	'' AS Cd_Ltr,
	v.Cd_TD,
	d.NCorto As NomTD,
	v.NroSre,
	v.NroDoc,
	v.Cd_Mda,
	v.CamMda,
	Case When v.Cd_Mda='01' Then v.Total Else Convert(decimal(13,2),v.Total*v.CamMda) End As SaldoS,
	Case When v.Cd_Mda='01' Then Convert(decimal(13,2),v.Total/v.CamMda) Else v.Total End As SaldoD,
	v.Cd_Clt,
	c.Cd_TDI,
	c.NDoc,
	isnull(c.RSocial,isnull(c.Nom,'')+' '+isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')) As NomClt
	,c.direc
From 
	Venta v
	Inner Join TipDoc d On d.Cd_TD=v.Cd_TD
	Left Join Cliente2 c On c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
Where 
	v.RucE=@RucE
	and v.Eje=@Eje
	and v.Cd_Vta=@Cd_Vta

-- Leyenda --
-- DI <19/06/2012 : Creacion del SP>
	
GO
