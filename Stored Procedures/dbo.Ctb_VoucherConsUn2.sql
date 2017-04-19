SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherConsUn2]
@RucE nvarchar(11),
@Cd_Vou int,
@RegCtb nvarchar(15),
@msj varchar(100) output
as
if not exists (select * from Voucher where RucE=@RucE and Cd_Vou=@Cd_Vou and RegCtb = @RegCtb)
	set @msj = 'Voucher no existe'
else	select vou.*,
	--Codigo antiguo comentado
	--aux.NDoc,isnull(aux.RSocial,'Sin Razon Social') as RSocial
	--Datos del Cliente/Proveedor
	case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_TDI else c.Cd_TDI end as Cd_TDI,
	case(isnull(len(vou.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end as NDoc,
	case(isnull(len(vou.Cd_Clt),0)) when 0 then case(isnull(len(p.RSocial),0)) 
		when 0 then isnull(nullif(p.ApPat +' '+p.ApMat+' '+p.Nom,''),'------- SIN RAZON SOCIAL ------')
		else p.RSocial  end  else 
          	case(isnull(len(c.RSocial),0)) 
	  	when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN RAZON SOCIAL ------')
	  	else c.RSocial end end as RSocial
	--
	from Voucher vou 
		left join Proveedor2 as p on vou.Cd_Prv = p.Cd_Prv and vou.RucE = p.RucE
		left join Cliente2 as c on vou.Cd_Clt = c.Cd_Clt and vou.RucE = c.RucE
		--Left Join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
		where vou.RucE=@RucE and vou.Cd_Vou=@Cd_Vou and  vou.RegCtb = @RegCtb
print @msj

--Leyenda:
--PV: Vie 30/01/09
--J : Vie 26/03/2010 - <Modificado , Se agregaron los campos NDoc,RSocial para visualizarlos>
--CAM: JUE 16/09/2010 MODIFICADO > Se elimino la tabla Auxiliar y se agrego las tablas Proveedor2 y Cliente2




GO
