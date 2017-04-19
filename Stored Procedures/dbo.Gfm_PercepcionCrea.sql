SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gfm_PercepcionCrea] 
@RucE nvarchar(11),
@Cd_PercepItem char(10) output,
@Cd_Prod char(7),
@PorcentajePercep numeric(8,7),
@TieneFechaVigencia bit,
@FechaVigenciaInicio smalldatetime,
@FechaVigenciaFin smalldatetime,
@UsuCrea varchar(50),
@UsuMdf varchar(50),
@FecReg datetime,
@FecMdf datetime,
@msj varchar(100) output

as

	if(exists(select * from MaestraPercepciones where RucE=@RucE and Cd_PercepItem=@Cd_PercepItem))
		set @msj='Percepcion ya existe'
	else
	begin
	
		set @Cd_PercepItem= dbo.Cd_PercepItem(@RucE)
	
		insert into MaestraPercepciones VALUES(@RucE,@Cd_PercepItem,@Cd_Prod,@PorcentajePercep,@TieneFechaVigencia,@FechaVigenciaInicio,@FechaVigenciaFin,@UsuCrea,@UsuMdf,@FecReg,@FecMdf)
		
		if @@rowcount <= 0
		set @msj = 'Percepcion no pudo ser ingresado'
		
	end
	

print @msj
GO
