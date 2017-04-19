SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipDocCons_conSr]
@RucE nvarchar(11),
@msj varchar(100)  output
as
if not exists (select Cd_TD from Serie where RucE=@RucE)
	set @msj = 'No se encontro tipos de documentos en series, se requiere ingresar una serie.'
else
begin
	select a.Cd_TD,a.Cd_TD+'  |  '+b.Descrip as CodNom
	from Serie a, TipDoc b
	where a.RucE=@RucE and a.Cd_TD=b.Cd_TD group by a.Cd_TD,b.Descrip
end
--PV
--PV
GO
