SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_CfgCajaConsxVendedor]
@RucE nvarchar(11),
@NomUsu nvarchar(20),
@msj varchar(100) output
as

declare @Cd_Caja nvarchar(20)

if exists(select * from Vendedor2 where RucE = @RucE and UsuVdr = @NomUsu)
	set @Cd_Caja = (select top (1) Cd_Caja from Vendedor2 where RucE = @RucE and UsuVdr = @NomUsu)
else
begin
	set @msj = 'No hay vendedor asociado al usuario'
	return;
end

select cj.RucE, cj.Cd_Area, cj.Nombre, cj.Numero, cfg.Cd_Caja, cfg.Cd_MIS, cfg.Cd_Alm, cfg.Cd_CC, cfg.Cd_SC, cfg.Cd_SS, 
vnd.Cd_Vdr, cfg.CtaBco,cfg.CtaClt, cfg.Cd_MIS_Inv
from Caja cj
inner join CfgCaja cfg on cfg.RucE = cj.RucE and cfg.Cd_Caja = cj.Cd_Caja
inner join Vendedor2 vnd on vnd.RucE = cj.RucE and cj.Cd_Caja = vnd.Cd_Caja
where cj.RucE = @RucE and cj.Cd_Caja = @Cd_Caja and cj.Estado = 1

--MP: 06/02/2012 : <Creacion del procedimiento almacenado> 
--MP: 13/03/2012 : <Modificacion del procedimiento almacenado> 

--select * from CfgCaja
GO
