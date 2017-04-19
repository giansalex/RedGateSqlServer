SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Com_SolicitudComResp_Cons]

@RucE nvarchar(11),
@msj varchar(100) output

AS

Select 
	s.Cd_SCo,
	s.NroSC,
	s.Asunto
From 
	SolicitudCom s
	Inner Join SCxProv p On p.RucE=s.RucE and p.Cd_SCo=s.Cd_SCo and isnull(p.IB_Env,0)=1
Where 
	s.RucE=@RucE 
	and s.Id_EstSC='04'
Group by
	s.RucE,s.Cd_SCo,s.NroSC,s.FecEmi,s.FecEntR,
	s.Asunto,s.ElaboradoPor,s.AutorizadoPor,s.Id_EstSC
Order by 2

-- Leyenda --
-- DI <04/06/12 : Creacion del SP>

GO
