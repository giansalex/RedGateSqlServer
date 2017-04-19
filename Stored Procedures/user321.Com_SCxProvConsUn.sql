SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Com_SCxProvConsUn]
@RucE nvarchar(11),
@Cd_SCoEnv int,
@msj varchar(100) output
as

select--* from SCxProv
RucE, Cd_SCoEnv, Cd_SCo, Cd_Prv, 
IB_Env, convert(Nvarchar, FecEnv,103), 
IB_Impr, convert(Nvarchar, FecImpr,103), 
convert(Nvarchar, Prv_FecEnt,103), Prv_Obs
from SCxProv
where RucE = @RucE and Cd_SCoEnv = @Cd_SCoEnv
--order by convert(Nvarchar,  co.FecMov,102) desc
order by year(FecEnv), month(FecEnv) desc ,day(FecEnv) desc, Cd_SCoEnv desc
print @msj
-- Leyenda --
-- MP : 2010-12-15 : <Creacion del procedimiento almacenado>
-- exec Com_SCxProvConsUn '11111111111', null

GO
