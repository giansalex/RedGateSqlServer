SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Inv_GuiaRemisionDet_Cons]
@RucE nvarchar(11),
@Cd_GR char(10),
@PesoTotalKg numeric(18,3) output,
@PesoxCant numeric(18,3) output,
@msj varchar(100) output
as
	select @PesoxCant = 1
	select GRD.Cd_GR,GRD.Item, P.Cd_Prod, P.Nombre1,UM.Nombre,PU.DescripAlt,GRD.Cd_Vta,GRD.Cd_Com,GRD.ItemPd,GRD.Pend,GRD.Cant,@PesoxCant as PesoxCant,GRD.PesoCantKg,GRD.ID_UMP,GRD.CA01,GRD.CA02,GRD.CA03,GRD.CA04,GRD.CA05,GRD.Descrip,isnull(GRD.Pend,0)+Cant as 'Maximo'  from Producto2 as P inner join 
		UnidadMedida as UM inner join
		Prod_UM as PU on UM.Cd_UM = PU.Cd_UM on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  inner join
		GuiaRemisionDet as GRD on GRD.RucE = PU.RucE and GRD.Cd_Prod = PU.Cd_Prod and GRD.ID_UMP = PU.ID_UMP
		where GRD.RucE = @RucE and GRD.Cd_GR = @Cd_GR
	select @PesoTotalKg = sum(PesoCantKg) from GuiaRemisionDet where RucE = @RucE and Cd_GR =@Cd_GR
	--select @PesoxCant = 1
	update GuiaRemision set PesoTotalKG = @PesoTotalKg where RucE = @RucE and Cd_GR =@Cd_GR

--exec Inv_GuiaRemisionDet_Cons '11111111111','GR00000076',null,null,null
-- Leyenda --
-- FL : 2010-09-12 : <Creacion del procedimiento almacenado>







GO
