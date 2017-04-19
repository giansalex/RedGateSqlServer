SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionCons_Ultimo]
@RucE nvarchar(11),
@msj varchar(100) output
as
declare @Cd_GR char(10)
set @Cd_GR = (select isnull(max(Cd_GR),0) as Maximo from guiaRemision where RucE=@RucE)
if(@Cd_GR = '0')
begin
	set @msj = 'No se encontraron Guias de Remision'
	return
end
select gr.Cd_GR,gr.NroSre,gr.NroGR from guiaRemision gr where
 gr.RucE=@RucE and gr.Cd_GR=@Cd_GR
GO
