SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Ctb_CCostosRelacion]

@RucE nvarchar(11),
@msj varchar(100) output

AS

Select Cd_CC,'' As Cd_SC,'' As Cd_SS, Upper(NCorto) As NCorto From CCostos Where RucE=@RucE
UNION ALL
Select s.Cd_CC,s.Cd_SC,'' As Cd_SS, Upper(c.NCorto)+'_'+Upper(s.NCorto) As NCorto 
From CCostos c 
Inner Join CCSub s On s.RucE=c.RucE and s.Cd_CC=c.Cd_CC
Where s.RucE=@RucE
UNION ALL
Select b.Cd_CC,b.Cd_SC,b.Cd_SS, Upper(c.NCorto)+'_'+Upper(s.NCorto)+'_'+Upper(b.NCorto) As NCorto 
From CCostos c 
Inner Join CCSub s On s.RucE=c.RucE and s.Cd_CC=c.Cd_CC
Inner Join CCSubSub b On b.RucE=s.RucE and b.Cd_CC=s.Cd_CC and b.Cd_SC=s.Cd_SC
Where s.RucE=@RucE

-- Leyenda --
-- DI : 30/11/2011 <Creacion del SP>

GO
