SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudComProvAnexadoxSC]
@RucE nvarchar(11),
@Cd_SCo char(10),
@msj varchar(100) output
as

if exists (select * from SCxProv where ruce=@RucE and Cd_SCo=@Cd_SCo)
begin
	select p.Cd_Prv, p.NDoc as NDoc,
	case(isnull(len(p.RSocial),0)) when 0 then p.ApPat + ' ' + p.ApMat + ', ' + p.Nom else p.RSocial end as RSocial
	from SCxProv sp
	left join Proveedor2 p on p.RucE = sp.RucE and p.Cd_Prv = sp.Cd_Prv 
	where sp.ruce=@RucE and sp.Cd_SCo=@Cd_SCo
	end
else
	set @msj = 'No hay proveedores'
GO
