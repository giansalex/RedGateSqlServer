SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gfm_PercepcionConsUn] 
@RucE nvarchar(11),
@Cd_PercepItem char(10),
@msj varchar(100) output 
as 
if not exists (select * from MaestraPercepciones where RucE=@RucE and Cd_PercepItem=@Cd_PercepItem)
	set @msj = 'Percepción no existe'
else	select * from MaestraPercepciones where RucE=@RucE and Cd_PercepItem=@Cd_PercepItem
print @msj
GO
