SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherCons_X_Vou]
@RucE nvarchar(11),
@RegCtb nvarchar(15),
--@Eje nvarchar(4),
--@PrdoIni nvarchar(2),
--@PrdoFin nvarchar(2),
@msj varchar(100) output
as
--if exists (select top 1 * from Venta where RucE = @RucE and Eje=@Eje) and exists (select * from CampoV where RucE=@RucE)
begin
select 
	vou.RucE, vou.Cd_Vou, vou.Ejer, vou.Prdo, vou.RegCtb, vou.Cd_Fte, 
	convert(varchar(10),vou.FecMov,103) as FecMov,
	convert(varchar(10),vou.FecCbr,103) as FecCbr,
	vou.NroCta,
	vou.Cd_TD, td.Descrip as DescripTD, td.NCorto as NCortoTD,
	vou.NroSre, vou.NroDoc, 
	convert(varchar(10),vou.FecED,103) as FecED,
	convert(varchar(10),vou.FecVD,103) as FecVD,
	vou.Glosa, vou.MtoOr, vou.MtoD, vou.MtoH,
	vou.Cd_MdOr, moor.Simbolo as SimMdOr,
	vou.Cd_MdRg, morg.Simbolo as SimMdRg,
	vou.CamMda, vou.Cd_CC, vou.Cd_SC, 
	vou.Cd_SS, vou.Cd_Area, ar.NCorto as NCortoArea,
	vou.Cd_MR, md.Nombre as NomMR,
	vou.NroChke, 
	vou.Cd_TG, tg.nombre as NomTGasto,
	vou.FecReg, vou.FecMdf,
	vou.UsuCrea, vou.UsuModf, vou.IB_Anulado,

--Codigo Cliente
--Codigo anterior comentado:
	--vou.Cd_Aux,case(isnull(len(au.RSocial),0))
		--         	     when 0 then au.ApPat+' '+au.ApMat+' '+au.Nom
			-- 	     else au.RSocial end as NomComCte
	case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_Prv else c.Cd_Clt end as Cd_Aux,
    	case(isnull(len(vou.Cd_Clt),0)) when 0 then case(isnull(len(p.RSocial),0)) 
		when 0 then isnull(nullif(p.ApPat +' '+p.ApMat+' '+p.Nom,''),'------- SIN NOMBRE ------')
		else p.RSocial  end  else 
          		case(isnull(len(c.RSocial),0)) 
	  		when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------')
	  	else c.RSocial end end as NomComCte
--Fin Codigo Cliente

from Voucher vou
	--left join Auxiliar au on vou.RucE=au.RucE and vou.Cd_Aux=au.Cd_Aux
	left join Proveedor2 as p on vou.Cd_Prv = p.Cd_Prv and vou.RucE = p.RucE
	left join Cliente2 as c on vou.Cd_Clt = c.Cd_Clt and vou.RucE = c.RucE
	left join TipDoc td on vou.Cd_TD=td.Cd_TD	
	left join Area ar on vou.RucE=ar.RucE and vou.Cd_Area=ar.Cd_Area
	left join Modulo md on  vou.Cd_MR=md.Cd_MR
	left join TipGasto tg on  vou.Cd_TG=tg.Cd_TG
	left join Moneda moor on  vou.Cd_MdOr=moor.Cd_Mda
	left join Moneda morg on  vou.Cd_MdRg=morg.Cd_Mda
	where vou.RucE=@RucE and vou.RegCtb=@RegCtb order by Cd_Vou
end
print @msj
GO
