SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Producto2_ListUM]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_Prod char(7),
@msj varchar(100) output
as

declare @check bit
	set @check=0
if (@Cd_Prv='' or @Cd_Prv is null)
begin
	SELECT @check as Sel,pu.Id_UMP as Item,pu.Cd_Prod as CodPro,pu.Cd_UM as CodUM,pu.DescripAlt as Descrip, pu.EstadoUMP,-- Estado,
		pu.Factor
	 from prod_um pu 
	--inner join prodprov pp on pp.RucE = pu.RucE and pp.cd_prod = pu.cd_prod and pp.ID_UMP = pu.ID_UMP
	where pu.RucE=@RucE  and pu.Cd_Prod = @Cd_Prod and pu.EstadoUMP=1
end
else
begin
	SELECT @check as Sel,pu.Id_UMP as Item,pu.Cd_Prod as CodPro,pu.Cd_UM as CodUM,pu.DescripAlt as Descrip, pu.EstadoUMP,-- Estado,
		pu.Factor
	 from prod_um pu inner join prodprov pp on pp.RucE = pu.RucE and pp.cd_prod = pu.cd_prod and pp.ID_UMP = pu.ID_UMP
	where pp.RucE=@RucE and pp.Cd_Prv = @Cd_Prv and pp.Cd_Prod = @Cd_Prod and pu.EstadoUMP=1
end

--MP: 10/01/2011 : <Modificacion del procedimiento almacenado>
--CE: 16/08/2012 : <Modificacion del procedimiento almacenado>
GO
