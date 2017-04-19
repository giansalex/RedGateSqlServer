SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Doc_Contratos_PorVencer]
@Ruce nvarchar(11),
@FechaFin datetime,
@msj varchar(100) output
as
select	Cd_Ctt, Cd_Clt, FecIni, FecFin, ct.Descrip, Obs, FecReg, Estado, cc.Cd_CC, cc.Descrip as 'Distrito',
		cs.Cd_SC, cs.Descrip as 'Direccion', ss.Cd_SS, ss.Descrip as 'Departamento'
from Contrato ct
left join CCostos cc on cc.RucE = ct.RucE and cc.Cd_CC = ct.Cd_CC
left join CCSub cs on cs.RucE = ct.RucE and cs.Cd_CC = ct.Cd_CC and cs.Cd_SC = ct.Cd_SC
left join CCSubSub ss on ss.RucE = ct.RucE and ss.Cd_CC = ct.Cd_CC and ss.Cd_SC = ct.Cd_SC and ss.Cd_SS = ct.Cd_SS
where ct.RucE = @Ruce and (FecFin between GETDATE() and @FechaFin)	and Estado = 1 
GO
