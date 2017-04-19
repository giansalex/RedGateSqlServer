SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionDetMdf]
@RucE nvarchar(11),
@Cd_GR char(10),
@Item int,
--@Cd_Prod char(7),
--@Descrip varchar(200),
--@ID_UMP int,
@Cant numeric(13,3),
@PesoCantKg numeric(18,3),
--@Cd_Vta nvarchar(10),
@Pend numeric,
--@FecMdf datetime,
@UsuMdf nvarchar(10),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@msj varchar(100) output,
@PesoTotalKg numeric(18,3) output

as
if not exists (select * from GuiaRemisionDet where RucE = @RucE and Cd_GR=@Cd_GR and Item = @Item)
	set @msj = 'Detalle de Guia de Remision no existe'
else
begin
	update GuiaRemisionDet
		set Cant = @Cant, PesoCantKg = @PesoCantKg, Pend = @Pend, UsuMdf=@UsuMdf, FecMdf= getdate(), CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05
		where RucE = @RucE and Cd_GR=@Cd_GR and Item = @Item
	
	if @@rowcount <= 0
	set @msj = 'Detalle de Guia de Remision no pudo ser modificada'
	select @PesoTotalKg = sum(PesoCantKg) from GuiaRemisionDet where RucE = @RucE and Cd_GR=@Cd_GR
	update GuiaRemision set PesoTotalKg= @PesoTotalKg where RucE = @RucE and Cd_GR=@Cd_GR
			
end
print @msj

-- Leyenda --
-- PP : 2010-04-19 12:44:07.920	: <Creacion del procedimiento almacenado>



GO
