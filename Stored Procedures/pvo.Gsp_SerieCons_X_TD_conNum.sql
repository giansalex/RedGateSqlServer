SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [pvo].[Gsp_SerieCons_X_TD_conNum] --Consulta solo las series  que tienen numeracion
@RucE nvarchar(11),
@Cd_TD nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from Serie where RucE=@RucE and Cd_TD=@Cd_TD)
	set @msj = 'No hay series asociadas al tipo de documento'
else select a.Cd_Sr, a.NroSerie from Serie a, Numeracion b where a.Cd_TD=@Cd_TD and a.RucE=@RucE and a.RucE = b.RucE and a.Cd_Sr=b.Cd_Sr group by a.Cd_Sr, a.NroSerie
--else	select Cd_Sr,NroSerie from Serie a, Numeracion b where  RucE=@RucE and Cd_TD=@Cd_TD
print @msj
--PV
GO
