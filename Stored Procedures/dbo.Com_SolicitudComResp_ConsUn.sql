SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Com_SolicitudComResp_ConsUn]

@RucE nvarchar(11),
@Cd_SC char(10),
@msj varchar(100) output

AS

Select 
	s.RucE,
	s.Cd_SCo,
	s.NroSC,
	Convert(varchar,s.FecEmi,103) As FecEmi,
	Convert(varchar,s.FecEntR,103) As FecEntR,
	s.Asunto,
	s.ElaboradoPor,s.AutorizadoPor,
	s.Obs
From 
	SolicitudCom s
	Inner Join SCxProv p On p.RucE=s.RucE and p.Cd_SCo=s.Cd_SCo and isnull(p.IB_Env,0)=1
Where 
	s.RucE=@RucE 
	and s.Cd_SCo = @Cd_SC
	and s.Id_EstSC='04'
Group by
	s.RucE,s.Cd_SCo,s.NroSC,s.FecEmi,s.FecEntR,
	s.Asunto,s.ElaboradoPor,s.AutorizadoPor,s.Obs
Order by 3

-- Leyenda --
-- DI <04/06/12 : Creacion del SP>

GO
