SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE  view [user321].[VGuiaRemision]
as

select GR.CA01,GR.CA02,GR.CA03,GR.CA04,GR.CA05,GR.CA06,GR.CA07,GR.CA08,GR.CA09,GR.CA10,
                GR.RucE, GR.Cd_GR, convert(nvarchar,GR.FecEmi,103) as FecEmi , convert(nvarchar,GR.FecIniTras,103) as FecIniTras,
                GR.NroSre,GR.NroGR, Gr.AutorizadoPor, GR.PtoPartida,GR.Cd_Tra,GR.DescripTra,GR.Cd_TO,GR.Cd_CC,GR.Cd_SC,GR.Cd_SS,Cd_TD
		,GR.Obs,GR.IC_ES,GR.UsuCrea,Gr.FecFinTras,GR.FecIniTras as FechaIniTras
from GuiaRemision GR 





GO
