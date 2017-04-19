SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrvGuiaCons]
@RucE nvarchar(11),
@Cd_GR char(10),
@Cd_Prv char(10) output,
@msj varchar(100) output
as
begin

	select distinct @Cd_Prv=v.Cd_Prv from Compra v
	inner join GuiaRemisionDet g on g.Cd_Com=v.Cd_Com and g.RucE=g.RucE
	where g.Cd_GR=@Cd_GR and g.ruce=@RucE and v.ruce=@RucE
	
	if(@Cd_Prv is null)
	select distinct @Cd_Prv=Cd_Prv from guiaremision g where g.Cd_GR=@Cd_GR and g.ruce=@RucE
	else
	select distinct @Cd_Prv=v.Cd_Prv from Compra v
	inner join GuiaRemisionDet g on g.Cd_Com=v.Cd_Com and g.RucE=g.RucE
	where g.Cd_GR=@Cd_GR and g.ruce=@RucE and v.ruce=@RucE
end
print @msj
print @Cd_Prv
--Leyenda--
--FL: 06/01/2011 : <Se creo el procedimiento almacenado>




GO
