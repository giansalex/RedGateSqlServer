SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionConsUn_Inv2]
@RucE nvarchar(11),
@Cd_GR char(10),
@IC_ES char(1),
@msj varchar(100) output
as
if not exists (select * from GuiaRemision where RucE = @RucE and Cd_GR = @Cd_GR)
	set @msj = 'Guia de Remision no existe'
else
if (@IC_ES = 'E')
begin
	select p2.Cd_Prv as Codigo_Clt_Prv, p2.nDoc as NDoc, p2.Cd_TDI as Cd_TDI, 
	t.Nombre as NombreOperacion,
	case(isnull(len(p2.RSocial),0)) when 0 then p2.ApPat + ' ' + p2.ApMat + ', '+ p2.Nom else p2.RSocial end as Nombre,g.* 
	from GuiaRemision as g 
	left join Proveedor2 as p2 ON g.RucE = p2.RucE and g.Cd_Prv = p2.Cd_Prv 
	left join TipoOperacion as t ON t.Cd_TO = g.Cd_TO
	where g.RucE = @RucE and g.Cd_GR=@Cd_GR and g.IC_ES = 'E'
end
else if(@IC_ES = 'S')
begin
	if (select Cd_Clt from GuiaRemision where RucE = @RucE and Cd_GR = @Cd_GR and IC_ES = @IC_ES) is null
	--Si es de varios Clientes:
		begin 
			declare @Cd_Clt char(10),@Cd_TDI nvarchar(4), @NDoc varchar(15), @NomClt nvarchar(300)
			set @NomClt = 'Varios Clientes'
			set @Cd_Clt = null
			set @Cd_TDI = '00'
			set @NDoc = 'Varios'

			select @Cd_Clt as Codigo_Clt_Prv, @NDoc as nDoc, @Cd_TDI as Cd_TDI, 
			t.Nombre as NombreOperacion, @NomClt as Nombre, g.* 
			from GuiaRemision as g 
			left join Cliente2 as c2 ON g.RucE = c2.RucE and g.Cd_Clt = c2.Cd_Clt 
			left join TipoOperacion as t ON t.Cd_TO = g.Cd_TO
			where g.RucE = @RucE and g.Cd_GR=@Cd_GR and g.IC_ES = 'S'
		end
	--SI es de un solo cliente:
	else 
		begin
			select c2.Cd_Clt as Codigo_Clt_Prv, c2.nDoc as nDoc, c2.Cd_TDI as Cd_TDI, 
			t.Nombre as NombreOperacion,
			case(isnull(len(c2.RSocial),0)) when 0 then c2.ApPat + ' ' + c2.ApMat + ', '+ c2.Nom else c2.RSocial end as Nombre,g.* 
			from GuiaRemision as g 
			left join Cliente2 as c2 ON g.RucE = c2.RucE and g.Cd_Clt = c2.Cd_Clt 
			left join TipoOperacion as t ON t.Cd_TO = g.Cd_TO
			where g.RucE = @RucE and g.Cd_GR=@Cd_GR and g.IC_ES = 'S'
		end 

end
print @msj
-- Leyenda --
-- CAM : 07/01/11 : <Creacion del procedimiento almacenado>
-- exec Inv_GuiaRemisionConsUn_Inv2 '11111111111', 'GR00000019', 'E', ''
-- exec Inv_GuiaRemisionConsUn_Inv2 '11111111111', 'GR00000010', 'S', ''


GO
