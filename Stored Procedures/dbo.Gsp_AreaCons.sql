SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_AreaCons]
@RucE nvarchar(11),
@TipCons int, 
@msj varchar(100) output
as
/*if not exists (select top 1 * from Area where RucE=@RucE)
	set @msj = 'No se encontro Area'
else */	
--	select * from Area where RucE=@RucE
	
	if(@TipCons=0)
	   select * from Area where RucE=@RucE
	else 
	begin
		Declare @lmax int
		Set @lmax = (select Max(len(Cd_Area)) from Area where RucE=@RucE and Estado=1)
		select left(Cd_Area+'__________',@lmax)+'  |  '+Descrip as CodNom, Cd_Area, Descrip, NCorto from Area where  RucE=@RucE and Estado=1
	end

print @msj
--PV
--DI : 08/03/2010 <Modificacion : Agrego longitud de codigo + barra separadora + descripcion>
GO
