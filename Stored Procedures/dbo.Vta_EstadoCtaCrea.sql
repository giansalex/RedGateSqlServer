SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_EstadoCtaCrea]
@RucE nvarchar(11),
@Cd_Clt char(10),
@Cd_TD nvarchar(2),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Cd_Area nvarchar(6),
@Cd_Mda nvarchar(2),
@ReglasMoras varchar(50),
@ReglasPorc varchar(50),
@msj varchar(100) output
as
if exists (select * from EstadoCta where RucE=@RucE and Cd_EC=dbo.Cod_EstadoCta(@RucE))
	set @msj = 'Estado de Cta. ya existe'
else 
begin
	insert into EstadoCta(RucE,Cd_EC,Cd_Clt,Cd_TD,Cd_CC,Cd_SC,Cd_SS,Cd_Area,Cd_Mda,ReglasMoras,ReglasPorc)
	               values(@RucE,dbo.Cod_EstadoCta(@RucE),@Cd_Clt,@Cd_TD,@Cd_CC,@Cd_SC,@Cd_SS,@Cd_Area,@Cd_Mda,@ReglasMoras,@ReglasPorc)
	if @@rowcount <= 0
	   set @msj = 'Estado de Cta. no pudo ser registrado'
end
print @msj


----------------------LEYENDA----------------------
--MP: 25/05/2011 <Creacion del Procedimiento Almacenado>

GO
