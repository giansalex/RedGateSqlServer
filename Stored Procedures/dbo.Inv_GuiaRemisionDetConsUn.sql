SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionDetConsUn]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output,
@PesoxCant numeric(18,3) output
as
--if not exists (select * from GuiaRemisionDet where Cd_GR=@Cd_GR and RucE = @RucE)
	--set @msj = 'No existen detalles de la guia de remision'
--else
begin
	select @PesoxCant = 1
	select GRD.Item, P.Cd_Prod, P.Nombre1,UM.Nombre,PU.DescripAlt,GRD.Cant,@PesoxCant as PesoxCant,GRD.PesoCantKg,GRD.CA01,GRD.CA02,GRD.CA03,GRD.CA04,GRD.CA05,GRD.Pend+Cant as Maximo  from Producto2 as P inner join 
		UnidadMedida as UM inner join
		Prod_UM as PU on UM.Cd_UM = PU.Cd_UM on P.RucE = PU.RucE and P.Cd_Prod = PU.Cd_Prod  inner join
		GuiaRemisionDet as GRD on GRD.RucE = PU.RucE and GRD.Cd_Prod = PU.Cd_Prod and GRD.ID_UMP = PU.ID_UMP
		where GRD.RucE = @RucE and GRD.Cd_GR = @Cd_GR
end
print @msj
GO
