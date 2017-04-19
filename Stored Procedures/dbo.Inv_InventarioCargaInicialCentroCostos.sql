SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_InventarioCargaInicialCentroCostos]
@RucE nvarchar(11),
@msj varchar(100) output
as

if not exists (select top 1 cc.RucE,cc.Cd_CC,cc.Descrip, sc.Cd_SC,sc.Descrip,ssc.Cd_SS,ssc.Descrip 
from CCostos cc 
left join CCSub sc on cc.RucE = sc.RucE and cc.Cd_CC = sc.Cd_CC  
left join CCSubSub ssc on sc.RucE = ssc.RucE and sc.Cd_CC = ssc.Cd_CC and sc.Cd_SC = ssc.Cd_SC  
where cc.RucE = @RucE and cc.Cd_CC = '01010101')
	select top 1 cc.RucE,cc.Cd_CC,cc.Descrip, sc.Cd_SC,sc.Descrip,ssc.Cd_SS,ssc.Descrip 
	from CCostos cc 
	left join CCSub sc on cc.RucE = sc.RucE and cc.Cd_CC = sc.Cd_CC  
	left join CCSubSub ssc on sc.RucE = ssc.RucE and sc.Cd_CC = ssc.Cd_CC and sc.Cd_SC = ssc.Cd_SC  
	where cc.RucE = @RucE
else
	select top 1 cc.RucE,cc.Cd_CC,cc.Descrip, sc.Cd_SC,sc.Descrip,ssc.Cd_SS,ssc.Descrip 
	from CCostos cc 
	left join CCSub sc on cc.RucE = sc.RucE and cc.Cd_CC = sc.Cd_CC  
	left join CCSubSub ssc on sc.RucE = ssc.RucE and sc.Cd_CC = ssc.Cd_CC and sc.Cd_SC = ssc.Cd_SC  
	where cc.RucE = @RucE and cc.Cd_CC = '01010101'
	

--CAM: 2010-11-29 <Creacion del procedimiento almacenado>
--MP:	2012-05-30 <Modificacion del procedimiento almacenado>
--select top 1 * from CCSubSub where RucE = @RucE order by Cd_CC,Cd_SC,Cd_SS
GO
