SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [user321].[Vta_CobroCons_X_Cbr_explo]
as
declare @RucE nvarchar(11)
set @RucE = '11111111111'



select VE.Cd_Vta,VE.Cd_Mda as Mon_Venta,CO.Cd_Mda as Mon_Cobro,CO.Monto,CO.MC_Soles,CO.MC_Dolares,VE.Total, VE.FecMov from 
(select b.Cd_Vta,b.Monto,b.RucE,b.Cd_Mda ,(select sum(Monto) from Cobro a where(a.FecPag<=b.FecPag) 
and (a.RucE = @RucE and a.Cd_Vta = b.Cd_Vta and a.Cd_Mda = b.Cd_Mda and a.Cd_Mda = '01'))  as MC_Soles,
(select sum(Monto) from Cobro a where(a.FecPag<=b.FecPag) 
and (a.RucE = @RucE and a.Cd_Vta = b.Cd_Vta and a.Cd_Mda = b.Cd_Mda and a.Cd_Mda = '02'))  as MC_Dolares 
from Cobro b 
where b.RucE = @RucE) as CO,(select *from Venta where RucE = @RucE) as VE
where CO.RucE = VE.RucE and CO.Cd_Vta = VE.Cd_Vta

---Ju: Incompleto... Por modificar hasta nuevo aviso xD!



GO
