SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_CtasXPresupCons_X_Dscrip]
@RucE nvarchar(11),
@Descrip nvarchar(50),
@msj varchar(100) output
as
select c.NroCta,c.NomCta, Case(isnull(len(Cd_CPr),0)) when '0' then 0 else 1 end Asignado 
from PlanCtas c
left join Presupuesto p  on c.RucE=p.RucE and c.NroCta=p.NroCta
where c.RucE=@RucE and c.IB_Psp=1 and (c.NroCta like '%'+@Descrip+'%' or c.NomCta like '%'+@Descrip+'%')
Order by 1
GO
