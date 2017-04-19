SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[TienePercepcionProd]
@RucE nvarchar(11),
@Cd_Prod char(7),
@FecAct smalldatetime,
@TieneFechaVigencia bit,
@FechaVigenciaInicio smalldatetime,
@FechaVigenciaFin smalldatetime,
@msj char(1) output

as

	if(exists(select * from MaestraPercepciones where RucE=@RucE and Cd_Prod=@Cd_Prod))
		begin
			if(@TieneFechaVigencia=1)
				begin
					if(exists(select * from MaestraPercepciones where RucE=@RucE and Cd_Prod=@Cd_Prod and @FecAct BETWEEN FechaVigenciaInicio AND FechaVigenciaFin))
						set @msj='1'
					else
						set @msj='0'
				end
			else
				begin
						set @msj='1'
				end
		end
	else
		begin
				set @msj ='0'
		end
		
print @msj
GO
