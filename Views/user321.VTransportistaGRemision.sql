SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [user321].[VTransportistaGRemision]
as
select tr.RucE, tr.Cd_Tra, tr.NDoc as RucT,tr.LicCond,tr.NroPlaca,tr.McaVeh,tr.Direc,tr.CA01,tr.CA02,tr.CA03,tr.CA04,tr.CA05,
                case(isnull(len(tr.RSocial),0)) when 0 then tr.ApPat + ' ' + tr.ApMat + ', ' + tr.Nom else tr.RSocial end as Sres
                from      transportista tr


GO
