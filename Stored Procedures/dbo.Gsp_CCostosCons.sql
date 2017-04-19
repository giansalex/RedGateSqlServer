SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CCostosCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from CCostos where RucE=@RucE)
	set @msj = 'No se encontro Centro de Costos'
else	*/
begin
	if(@TipCons=0)
		 select * from CCostos where RucE=@RucE
	else if(@TipCons=1)
		select Cd_CC+'  |  '+Descrip as CodNom,Cd_CC,Descrip from CCostos where RucE=@RucE
	else if(@TipCons=2)--SOLO PARA LA PANTALLA DE Gfm_CCostos
		select Cd_CC, Cd_CC, NCorto, Descrip  from CCostos where RucE=@RucE -- and Estado=1
	else if(@TipCons=3)
		select Cd_CC, Cd_CC, Descrip  from CCostos where RucE=@RucE -- and Estado=1
end
print @msj

--PV: Jue 29/01/09
--PP: 2010-08-22 15:12:00.687	:<Modicacion del procedimiento almacenado>
GO
