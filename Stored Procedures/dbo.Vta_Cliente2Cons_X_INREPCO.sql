SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Vta_Cliente2Cons_X_INREPCO]

@RucE nvarchar(11),
@msj varchar(100) output

AS

Select 
	c.RucE,
	c.Cd_Clt,
	c.Cd_TDI,t.NCorto As NomTDI,
	c.NDoc,
	isnull(c.RSocial,'') As RSocial,
	isnull(c.ApPat,'') As ApPat,
	isnull(c.ApMat,'') As ApMat,
	isnull(c.Nom,'') As Nom,
	Case When isnull(c.RSocial,'')<>'' Then c.RSocial Else isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'') End As NomComp,
	c.Cd_Pais,
	c.CodPost,
	c.Ubigeo,
	c.Direc,
	c.Telf1,
	c.Telf2,
	c.Fax,
	c.Correo,
	c.PWeb,
	c.Obs,
	c.CtaCtb,
	c.DiasCbr,
	c.PerCbr,
	c.CtaCte,
	c.Cd_CGC,
	c.Estado,
	c.CA01,m.Descrip As DescripCA01,
	(select Descrip from MantenimientoGN where RucE = c.RucE AND Codigo = c.CA02) as CA02,
	c.CA03,
	c.CA04,
	c.CA05,
	c.CA06,
	c.CA07,
	c.CA08,
	c.CA09,
	c.CA10,
	c.Cd_TClt,
	0 As Sel
From 
	Cliente2 c
	Left Join TipDocIdn t On t.Cd_TDI=c.Cd_TDI
	Left Join MantenimientoGN m On m.RucE=c.RucE and m.Codigo=c.CA01
Where 
	c.RucE=@RucE and isnull(c.Estado,0)=1 
Order by 
	9

-- Leyenda --
-- DI 10/08/2011 <Creacion del procedimiento almacenado>
-- MP 14/10/2011 <Modificacion del procedimiento almacenado>

GO
