SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TasaCon1]
@VerHist bit,
@msj varchar(100) output
as

if(@VerHist=1)
select t.*,th.EjerPrdoVig,th.Porc from tasas t left join tasashist th on th.Cd_Ts=t.Cd_Ts
else
select t.*, t2.EjerPrdoVig, t2.Porc as Tasa1 from Tasas t left join (
select th.Cd_Ts, th.EjerPrdoVig, th.Porc from (
select Cd_Ts, Max(EjerPrdoVig) EjerPrdoVig 
from TasasHist group by Cd_Ts
) as t1 inner join TasasHist th on th.Cd_Ts=t1.Cd_Ts and th.EjerPrdoVig=t1.EjerPrdoVig
) as t2 on t2.Cd_Ts=t.Cd_Ts
--select * from Tasas
print @msj
GO
