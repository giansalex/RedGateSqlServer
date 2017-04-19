SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionDetCreaVta]
@RucE nvarchar(11),
@Cd_GR char(10),
@Cd_Vta nvarchar(10),
@Nro_RegVdt int,
@msj varchar(100) output
as

	declare @Cd_Prod char(7)
	declare @ID_UMP int
	declare @Cant numeric(13,3)
	declare @PesoCantKg numeric(18,3)
	declare @PesoTotalKg numeric(18,3)

	select @Cd_Prod=Cd_Prod,@ID_UMP=ID_UMP, @Cant = Cant from VentaDet where RucE= @RucE and Cd_Vta= @Cd_Vta and Nro_RegVdt = @Nro_RegVdt

	set @Cant = @Cant - (select sum(isnull(GRD.Cant,0)) from Producto2 as P  	
	inner join Prod_UM as PU on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod
	inner join VentaDet as VD on PU.RucE = VD.RucE and PU.Cd_Prod = VD.Cd_Prod and PU.ID_UMP = VD.ID_UMP 
	left join GuiaRemisionDet as GRD on GRD.RucE= VD.RucE and GRD.Cd_Vta=VD.Cd_Vta and GRD.Cd_Prod=VD.Cd_Prod and GRD.ID_UMP=VD.ID_UMP and VD.Nro_RegVdt =ItemPd
	Where  VD.Cd_Vta = @Cd_Vta and  VD.RucE = @RucE and P.Cd_Prod = @Cd_Prod and PU.ID_UMP = @ID_UMP and VD.Nro_RegVdt = @Nro_RegVdt)

	select @PesoCantKg = isnull(PesoKg,0) from Prod_UM where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP
	--select @PesoCantKg = isnull(PesoKg,0)*@Cant from Prod_UM where RucE = @RucE and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP
	--if exists(select * from GuiaRemisionDet where RucE = @RucE and Cd_GR= @Cd_GR and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP and Cd_Vta = @Cd_Vta)
	--	update GuiaRemisionDet set Cant = @Cant , PesoCantKg =@PesoCantKg where  RucE = @RucE and Cd_GR= @Cd_GR and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP and Cd_Vta = @Cd_Vta
	--else
		insert into GuiaRemisionDet(RucE,Cd_GR,Item,Cd_Prod,ID_UMP,Cant,PesoCantKg, Cd_Vta, Pend, ItemPd)
			values(@RucE,@Cd_GR,dbo.ID_GRD(@RucE,@Cd_GR),@Cd_Prod,@ID_UMP,@Cant,@PesoCantKg,@Cd_Vta, 0, @Nro_RegVdt)
	if @@rowcount <= 0
	   set @msj = 'Detalle Guia de Remision no pudo ser registrada'

	select @PesoTotalKg = sum(PesoCantKg) from GuiaRemisionDet where RucE = @RucE and Cd_GR =@Cd_GR

	update GuiaRemision set PesoTotalKG = @PesoTotalKg where RucE = @RucE and Cd_GR =@Cd_GR
			
print @msj
-- Leyenda --
-- PP : 2010-08-27 15:23:37.687	: <Creacion del procedimiento almacenado>
GO
