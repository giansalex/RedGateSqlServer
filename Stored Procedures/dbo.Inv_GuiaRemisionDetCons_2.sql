SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionDetCons_2] 
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output,
@PesoTotalKg numeric(18,3) output,
@PesoxCant numeric(18,3) output
as
	select @PesoxCant = 1
	select GRD.Item, P.Cd_Prod, P.Nombre1,UM.Nombre,PU.DescripAlt,GRD.Cant,GRD.Cant*GRD.PesoCantKg as PesoxCant,GRD.PesoCantKg,GRD.CA01,GRD.CA02,GRD.CA03,GRD.CA04,GRD.CA05,GRD.Pend+Cant as 'Maximo',GRD.Cd_OP,OP.NroOP
		from Producto2 as P inner join 
		UnidadMedida as UM inner join
		Prod_UM as PU on UM.Cd_UM = PU.Cd_UM on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  inner join
		GuiaRemisionDet as GRD on GRD.RucE = PU.RucE and GRD.Cd_Prod = PU.Cd_Prod and GRD.ID_UMP = PU.ID_UMP left join
		OrdPedido as OP on OP.Cd_OP = GRD.Cd_OP
		where GRD.RucE = @RucE and GRD.Cd_GR = @Cd_GR
	select @PesoTotalKg = sum(PesoCantKg) from GuiaRemisionDet where RucE = @RucE and Cd_GR =@Cd_GR
	--select @PesoxCant = 1
	update GuiaRemision set PesoTotalKG = @PesoTotalKg where RucE = @RucE and Cd_GR =@Cd_GR

print @msj
-- Leyenda --
-- PP : 2010-04-10 17:07:33.703	: <Creacion del procedimiento almacenado>
-- JJ : 2010-12-30 17:25:33.703	: <Modificiacion del procedimiento almacenado>
-- KJ : 2012-09-17 11:08:42.000	: <Modificiacion del procedimiento almacenado, se agregó columnas Cd_OP y NroOP>
GO
