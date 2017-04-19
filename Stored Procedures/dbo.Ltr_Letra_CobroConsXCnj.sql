SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Ltr_Letra_CobroConsXCnj]

@RucE nvarchar(11),
@Cd_Cnj char(10),

@msj varchar(100) output

AS

Select 
	RucE,Cd_Ltr,Cd_Cnj,NroRenv,NroLtr,RefGdor,LugGdor,
	Convert(varchar,FecGiro,103) As FecGiro,Convert(varchar,FecVenc,103) As FecVenc,Plazo,Imp,Dsct,Total,
	CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10
From 
	Letra_Cobro
Where
	RucE=@RucE and Cd_Cnj=@Cd_Cnj



-- Leyenda --
-- DI : 17/01/2012 <Creacion del SP>
	
GO
