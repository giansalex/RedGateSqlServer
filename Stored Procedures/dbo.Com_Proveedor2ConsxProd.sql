SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2ConsxProd]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output
as
select distinct Pv.Cd_Prv,TD.NCorto,NDoc,
		case(isnull(len(RSocial),0)) when 0 
			then ApPat +' '+ ApMat +','+ Nom 
			else RSocial end as Nom,
		--RSocial, ApPat+' '+ ApMat+', '+ Nom as Nom, 
		P.Nombre, 
		Ubigeo, Direc, Telf1,CtaCtb  
	from ProdProv  as PP 
	inner join Proveedor2 as Pv on Pv.Cd_Prv = PP.Cd_Prv and Pv.RucE = PP.RucE
	inner join TipDocIdn as TD on TD.Cd_TDI = Pv.Cd_TDI 
	inner join Pais as P on P.Cd_Pais= Pv.Cd_Pais --and PP.Cd_Prod = @Cd_Prod and PP.RucE = @RucE
	where PP.Cd_Prod = @Cd_Prod and PP.RucE = @RucE

print @msj

-- Leyenda --
-- PP : 2010-03-26 10:52:56.300	: <Creacion del procedimiento almacenado>
-- MP : 2011-03-03 : <Modificacion del procedimiento almacenado>
--exec Com_Proveedor2ConsxProd '11111111111', 'PD00082', null
GO
