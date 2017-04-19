SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SCCostosCons]
@TipCons int,
@RucE nvarchar(11),
@Cd_CC nvarchar(8),
@msj varchar(100) output
as
/*if not exists (select top 1 * from CCSub where RucE=@RucE and Cd_CC=@Cd_CC)
	set @msj = 'No se encontro Sub Centro de Costos'
else	*/
begin
	if(@TipCons=0)
		select * from CCSub where RucE=@RucE and Cd_CC=@Cd_CC
	else if(@TipCons=1)
		select Cd_SC+'  |  '+Descrip as CodNom,Cd_SC,Descrip from CCSub where RucE=@RucE and Cd_CC=@Cd_CC
	else if(@TipCons=2)--SOLO PARA LA PANTALLA DE Gfm_CCostos
		select Cd_SC, Cd_SC,NCorto, Descrip from CCSub where RucE=@RucE and Cd_CC=@Cd_CC -- and Estado=1
	else if(@TipCons=3)
		select Cd_SC, Cd_SC, Descrip from CCSub where RucE=@RucE and Cd_CC=@Cd_CC -- and Estado=1

end
print @msj

--PV: Jue 29/01/09
GO
