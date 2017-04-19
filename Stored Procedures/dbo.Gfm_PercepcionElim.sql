SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gfm_PercepcionElim] 
@RucE nvarchar(11),
@Cd_PercepItem char(10),
@msj varchar(100) output

as

if not exists (select * from MaestraPercepciones where RucE=@RucE and Cd_PercepItem=@Cd_PercepItem)
	set @msj = 'Percepcion no existe'
else
begin
	
	delete MaestraPercepciones where RucE=@RucE and Cd_PercepItem=@Cd_PercepItem
	if @@rowcount <= 0
		set @msj = 'Percepcion no pudo ser eliminado'
end
print @msj
GO
