SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[Gfm_PercepcionConsUnProd]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output 
as 
if(not exists(select * from MaestraPercepciones where RucE=@RucE and Cd_Prod=@Cd_Prod))
begin
	set @msj = 'Percepción no existe'
end
else
begin
	select * from MaestraPercepciones where RucE=@RucE and Cd_Prod=@Cd_Prod
end
print @msj
GO
