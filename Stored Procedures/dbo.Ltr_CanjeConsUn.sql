SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Ltr_CanjeConsUn]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Cnj char(10),

@msj varchar(100) output

AS


Select 
	c.RucE,c.Cd_Cnj,c.Ejer,c.RegCtb,c.Prdo,
	Convert(varchar,c.FecMov,103) As FecMov,
	c.Cd_Clt,t.Cd_TDI,t.NDoc As NDocClt,c.Cd_MIS,c.Cd_Mda,c.TipCam,c.CantLtr,c.OtrosImp,c.Total,c.Obs,c.Cd_Area,c.Cd_CC,
	c.Cd_SC,c.Cd_SS,c.FecReg,c.FecMdf,c.UsuReg,c.UsuMdf,
	c.CA01,c.CA02,c.CA03,c.CA04,c.CA05,c.CA06,c.CA07,c.CA08,c.CA09,c.CA10
From 
	Canje c
	Left Join Cliente2 t On t.RucE=c.RucE and t.Cd_Clt=c.Cd_Clt
Where
	c.RucE=@RucE and c.Ejer=@Ejer and c.Cd_Cnj=@Cd_Cnj
	
-- Leyenda --
-- DI : 17/01/2012 <Creacion del SP>
-- Di : 19/02/2012 <Se agrego la columna OtrosImp>

GO
