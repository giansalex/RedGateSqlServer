SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[fab_EtapaConsCant]
@RucE varchar(11),
@Cd_Fab varchar(10),
@ID_Prc int,
@Cant numeric(15,7)
AS

declare @Cd_Flujo char(10)
declare @ID_Prct int
declare @a int 
declare @tProc table(Cant decimal(13,7), ID_Prc int)
select @Cd_Flujo = Cd_Flujo from fabfabricacion where RucE = @RucE and Cd_Fab=@Cd_Fab
select @ID_Prct = ID_Prc from FabFlujo as f inner join FabResultado as r on f.RucE = r.RucE and f.Cd_Flujo=r.Cd_Flujo and f.Cd_Prod = r.Cd_Prod and f.ID_UMP = r.ID_UMP
where r.RucE = @RucE and r.Cd_Flujo=@Cd_Flujo
insert into @tProc values ((select max(@Cant/Cant) from FabResultado where RucE = @RucE and Cd_Flujo=@Cd_Flujo and ID_Prc = @ID_Prct), @ID_Prct)
set @a = @@rowcount
while (@a != 0 )
begin
	insert into @tProc
	select sum(Cant), ID_Prc from (
	select i.Cant*(select Cant from @tProc where ID_prc = i.ID_Prc )/r.Cant as Cant, r.ID_Prc from FabResultado as r inner join FabInsumo as i 
	on r.RucE = i.RucE and r.Cd_Flujo = i.Cd_Flujo and r.Cd_Prod = i.Cd_Prod and r.ID_UMP = i.ID_UMP
	where r.RucE = @RucE and r.Cd_Flujo = @Cd_Flujo 
	and r.ID_Prc in (select distinct ID_PrcPre from FabProcREl where RucE = @RucE and Cd_Flujo=@Cd_Flujo and ID_PrcPos in (select Id_Prc from @tProc) and ID_PrcPre not in (select Id_Prc from @tProc) and ID_PrcPre not in (select distinct ID_PrcPre from FabProcREl where RucE = @RucE and Cd_Flujo=@Cd_Flujo and ID_PrcPos not in (select Id_Prc from @tProc))) 
	and i.ID_Prc in (select Id_Prc from @tProc)) as T
	group by ID_Prc
	set @a = @@rowcount
end

declare @CantExist numeric(15,7) = (select sum(CantEta) as Cant from fabetapa where ruce=@RucE and Cd_Fab=@Cd_Fab and ID_Prc=@ID_Prc)
select Cant-isnull(@CantExist,0) as Cant from @tProc where ID_Prc = @ID_Prc
print @CantExist
--buscar todas las etapas q tenga ese proceso y restar
--Leyenda:
--CE : 13/03/2013 <creacion del SP>

-- exec fab_EtapaConsCant '11111111111','FAB0000037', 1, 1000
GO
