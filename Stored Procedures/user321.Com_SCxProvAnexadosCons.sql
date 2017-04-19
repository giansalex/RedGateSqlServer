SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Com_SCxProvAnexadosCons]
@RucE nvarchar(11),
@Cd_SCo char(10),
@msj varchar(100) output
as
if not exists (select top 1 *from SCxProv where RucE = @RucE)
	set @msj='No se encontro proveedores anexados'
else
begin
	if (@Cd_SCo='' or @Cd_SCo is null)
	begin
		select '0' [Sel], p2.RucE, '' Cd_SCo, p2.Cd_Prv, 
		case(isnull(len(p2.RSocial),0)) when 0 then p2.ApPat + ' ' + p2.ApMat + ', '+ p2.Nom else p2.RSocial end as Nombre_Prv, 
		CONVERT (bit, 0)  IB_Env, CONVERT (bit, 0) IB_Impr, p2.Cd_TDI, p2.NDoc
		from Proveedor2 p2
		where p2.RucE = @RucE 
	end
	else
	begin
		select '0' [Sel], sc.RucE, sc.Cd_SCo, sc.Cd_Prv, 
		case(isnull(len(p2.RSocial),0)) when 0 then p2.ApPat + ' ' + p2.ApMat + ', '+ p2.Nom else p2.RSocial end as Nombre_Prv, 
		sc.IB_Env, sc.IB_Impr, p2.Cd_TDI, p2.NDoc
		from SCxProv sc
		left join Proveedor2 p2 on sc.Cd_Prv = p2.Cd_Prv and p2.RucE = sc.RucE
		where sc.RucE = @RucE and sc.Cd_SCo = @Cd_SCo
	end
	
end

-- Leyenda --
-- MP : 2011-01-10 : <Creacion del procedimiento almacenado>
-- MP : 2011-01-11 : <Modificacion del procedimiento almacenado>

GO
