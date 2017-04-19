SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Lf_LiqFondoDetCons]
@RucE nvarchar(11),
@Cd_Liq char(10),
@msj varchar(100) output
as
	if not exists (select * from LiquidacionDet where RucE=@RucE and Cd_Liq=@Cd_Liq)
	set @msj = 'Liquidacion de Fondo no existe.'
else	
	select ld.RucE,ld.Cd_Liq,ld.Item,ld.FecMov,ld.Cd_TD,ld.NroSre,ld.NroDoc,ld.FecED,ld.FecVD,ld.Itm_BC,ld.Cd_Prod,p2.Nombre1 as Nom_Prod, p2.Descrip as Descripcion,
		ld.ID_UMP,um.DescripAlt as Descripcion,
		ld.Cd_Srv,s2.Nombre,ld.ValorU,ld.DsctoP,ld.DsctoI,ld.BIMU,ld.IGVU,ld.TotalU,ld.Cantidad,ld.BIM,ld.IGV,ld.Total,
		ld.Cd_Prv,ISNULL(pr.RSocial,pr.ApPat+pr.ApMat+','+pr.Nom)as NombrePrv,ld.Cd_Clt,ISNULL(cl.RSocial,cl.ApPat+cl.ApMat+','+cl.Nom) as NombreClt,
		ld.Cd_Area,ae.Descrip as DescripcionAE,ld.Cd_CC,cc.Descrip as DescripcionCC,ld.Cd_SC,cs.Descrip as DescripcionSC,ld.Cd_SS,ss.Descrip as DescripcionSS,
		ld.Cd_Mda,ld.CamMda,ld.FecReg,ld.FecMdf,ld.UsuCrea,ld.UsuModf,
		ld.CA01,ld.CA02,ld.CA03,ld.CA04,ld.CA05,ld.CA06,ld.CA07,ld.CA08,ld.CA09,ld.CA10
 from LiquidacionDet ld
		inner join Producto2 p2 on p2.RucE=ld.RucE and p2.Cd_Prod = ld.Cd_Prod 
		inner join Prod_UM um on um.RucE=ld.RucE and um.Cd_Prod=ld.Cd_Prod and um.ID_UMP=ld.ID_UMP
		inner join Servicio2 s2 on s2.RucE = ld.RucE and s2.Cd_Srv = ld.Cd_Srv
		inner join Proveedor2 pr on pr.RucE = ld.RucE and pr.Cd_Prv = ld.Cd_Prv
		inner join Cliente2 cl on cl.RucE = ld.RucE and cl.Cd_Clt = ld.Cd_Clt
		inner join CCostos cc on cc.RucE=ld.RucE and cc.Cd_CC = ld.Cd_CC
		inner join CCSub cs on cs.RucE=ld.RucE and cs.Cd_SC = ld.Cd_SC and cs.Cd_CC = cc.Cd_CC
		inner join CCSubSub ss on ss.RucE=ld.RucE and ss.Cd_SS =ld.Cd_SS and ss.Cd_SC = cs.cd_sc and ss.cd_cc = cc.cd_cc
		inner join Area ae on ae.RucE =ld.RucE and ae.Cd_Area = ld.Cd_Area
		where ld.RucE = @RucE and ld.Cd_Liq=@Cd_Liq
	 
print @msj
--Leyenda
--BG : 28/02/2013 <se creo el SP--(°)> >
--bg:01/03/2013 <se modifico mi error>
-- Lf_LiqFondoDetCons '11111111111','LF00000001',null
GO
