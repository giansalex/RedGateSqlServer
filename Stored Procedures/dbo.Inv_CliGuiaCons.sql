SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CliGuiaCons]
@RucE nvarchar(11),
@Cd_GR char(10),
@Cd_Clt char(10) output,
@msj varchar(100) output
as
begin

	select distinct @Cd_Clt=v.Cd_Clt from Venta v
	inner join GuiaRemisionDet g on g.Cd_Vta=v.Cd_Vta and g.RucE=g.RucE
	where g.Cd_GR=@Cd_GR and g.ruce=@RucE and v.ruce=@RucE
	
	if(@Cd_Clt is null)
	select distinct @Cd_Clt=Cd_Clt from guiaremision g where g.Cd_GR=@Cd_GR and g.ruce=@RucE
	else
	select distinct @Cd_Clt=v.Cd_Clt from Venta v
	inner join GuiaRemisionDet g on g.Cd_Vta=v.Cd_Vta and g.RucE=g.RucE
	where g.Cd_GR=@Cd_GR and g.ruce=@RucE and v.ruce=@RucE
end
print @msj
print @Cd_Clt
--Leyenda--
--FL: 08/11/2010 : <Se creo el procedimiento almacenado>


GO
