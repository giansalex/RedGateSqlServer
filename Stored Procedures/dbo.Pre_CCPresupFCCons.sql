SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Pre_CCPresupFCCons]

@RucE nvarchar(11),
@msj varchar(100) output

AS

(
Select 
	cc.Cd_CC,
	'' As Cd_SC,
	'' As Cd_SS,
	cc.Descrip
From CCostos cc
Where cc.RucE=@RucE and cc.IB_Psp=1

UNION ALL

Select 
	sc.Cd_CC,
	sc.Cd_SC,
	'' As Cd_SS,
	sc.Descrip
From CCSub  sc
Where sc.RucE=@RucE  and sc.IB_Psp=1

UNION ALL

Select
	ss.Cd_CC,
	ss.Cd_SC,
	ss.Cd_SS,
	ss.Descrip
From CCSubSub  ss
Where ss.RucE=@RucE  and ss.IB_Psp=1
)
Order by 1,2,3

-- Leyenda --

-- DI : 27/12/2010 < Creacion del procedimiento almacenado >


GO
