SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gfm_PercepcionMdf] 
@RucE nvarchar(11),
@Cd_PercepItem char(10),
@Cd_Prod char(7),
@PorcentajePercep numeric(8,7),
@TieneFechaVigencia bit,
@FechaVigenciaInicio smalldatetime,
@FechaVigenciaFin smalldatetime,
@UsuMdf varchar(50),
@FecMdf datetime,
@msj varchar(100) output

as

if not exists (select * from MaestraPercepciones where RucE=@RucE and Cd_PercepItem=@Cd_PercepItem)
	set @msj = 'Percepcion no existe'
else
begin
	update MaestraPercepciones set Cd_PercepItem=@Cd_PercepItem, Cd_Prod=@Cd_Prod, PorcentajePercep=@PorcentajePercep, TieneFechaVigencia=@TieneFechaVigencia, FechaVigenciaInicio=@FechaVigenciaInicio, FechaVigenciaFin=@FechaVigenciaFin, UsuMdf=@UsuMdf, FecMdf=@FecMdf
		where RucE=@RucE and Cd_PercepItem=@Cd_PercepItem
	if @@rowcount <= 0
		set @msj = 'Percepcion no pudo ser modificado'
end
print @msj
GO
