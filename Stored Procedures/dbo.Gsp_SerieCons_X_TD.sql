SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SerieCons_X_TD] --Consulta los tipo de documentos que existe en serie
@RucE nvarchar(11),
@Cd_TD nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from Serie where RucE=@RucE and Cd_TD=@Cd_TD)
	set @msj = 'No hay series asociadas al tipo de documento'
else	select Cd_Sr,NroSerie from Serie where  RucE=@RucE and Cd_TD=@Cd_TD
print @msj
--PV
GO
