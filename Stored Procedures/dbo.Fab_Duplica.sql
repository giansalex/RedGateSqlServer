SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fab_Duplica]
@RucE varchar (11),
@Cd_Flujo char (10)
as
declare @c char(10)
set @c = dbo.Cd_Flujo(@RucE)
insert into FabFlujo
select RucE,
@c as Cd_Flujo,
Nombre,Descrip,Cd_Prod,ID_UMP,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10
from FabFlujo
where RucE = @RucE and Cd_Flujo = @Cd_Flujo
insert into FabProceso
select RucE,
@c as Cd_Flujo,
ID_Prc,Nombre,Descrip,TipPrc,Actividades,Cd_Alm,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10
from FabProceso
where RucE = @RucE and Cd_Flujo = @Cd_Flujo
insert into FabInsumo
select 
RucE,@c as Cd_Flujo,ID_Prc,ID_Ins,Cd_Prod,ID_UMP,Cant,Merma
from FabInsumo
where RucE = @RucE and Cd_Flujo = @Cd_Flujo
insert into FabResultado
select 
RucE,@c as Cd_Flujo,ID_Prc,ID_Rest,Cd_Prod,ID_UMP,Cant
from FabResultado
where RucE = @RucE and Cd_Flujo = @Cd_Flujo
insert into FabProcRel
select 
RucE,@c as Cd_Flujo,ID_PrcPre,ID_PrcPos
from FabProcRel
where RucE = @RucE and Cd_Flujo = @Cd_Flujo

--Leyenda

--BG : 05/03/2013 <se creo el SP>
GO
