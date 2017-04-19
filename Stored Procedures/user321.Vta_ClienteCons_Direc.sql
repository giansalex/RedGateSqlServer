SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [user321].[Vta_ClienteCons_Direc]
@RucE nvarchar(11),
@Cd_Clt char(10),
@msj varchar(100) output
as

select Direc from Cliente2 where RucE = @RucE and Cd_Clt = @Cd_Clt

-- Leyenda --
-- JU : 2010-09-16 : <Creacion del procedimiento almacenado>
GO
