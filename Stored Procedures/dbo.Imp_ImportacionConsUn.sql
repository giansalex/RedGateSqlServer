SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImportacionConsUn]
@RucE nvarchar(11),
@Cd_IP char(7),
@msj varchar(100) output
as
if not exists(select * from importacion where RucE=@RucE and Cd_IP=@Cd_IP)
	set @msj='Importacion no existe.'
else
begin
	select 
		*,convert(numeric(18,3),(importacion.Total / importacion.Total_ME)) as CamMda
	from 
		importacion 
	where 
		RucE=@RucE 
		and Cd_IP=@Cd_IP
end
-- LEYENDA
-- NO SE QUIEN LO CREO
-- CAM 12/10/2012 AGREGUE CAMMDA
GO
