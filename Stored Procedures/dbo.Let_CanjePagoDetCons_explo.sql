SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Let_CanjePagoDetCons_explo]
@RucE nvarchar(11),
@Cd_Cnj int,
@msj varchar(100) output
as
select 	
	cd.Cd_Cnj, cd.Cd_Com, cd.Cd_Ltr,
	Case When isnull(cd.Cd_Com,'')<>'' Then vta.Cd_TD Else ltc.Cd_TD End Cd_TD,
	Case When isnull(cd.Cd_Com,'')<>'' Then tdo1.NCorto Else tdo2.NCorto End NomTD,
	Case When isnull(cd.Cd_Com,'')<>'' Then vta.NroSre Else '' End NroSre,
	Case When isnull(cd.Cd_Com,'')<>'' Then vta.NroDoc Else isnull(ltc.NroRenv,'')+ltc.NroLtr End NroDoc,
	cd.Importe, cd.DsctPor, cd.DsctImp,cd.Total, cd.Cd_Mda, Mda.Nombre as NombreMda		
from 	CanjePagoDet cd
 inner join CanjePago can on cd.RucE=can.RucE and can.Cd_Cnj = cd.Cd_Cnj
 inner join Moneda Mda on Mda.Cd_Mda=cd.Cd_Mda
 Left Join Compra vta on vta.RucE=cd.RucE and vta.Cd_Com=cd.Cd_Com
 Left Join TipDoc tdo1 On tdo1.Cd_TD=vta.Cd_TD
 Left Join Letra_Pago ltc on ltc.RucE=cd.RucE and ltc.Cd_Ltr=cd.Cd_Ltr
 Left Join TipDoc tdo2 On tdo2.Cd_TD=ltc.Cd_TD
 
where cd.RucE=@RucE and cd.Cd_Cnj=@Cd_Cnj
	print @msj
	
-- Leyenda --
-- DI : 09/04/2012 <Se agrego las columnas Cd_TD,NomTD,NroSre,NroDoc>
	
GO
