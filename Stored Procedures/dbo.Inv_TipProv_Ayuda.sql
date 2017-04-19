SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipProv_Ayuda]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as 
begin
	if (@TipCons=3)
	begin
		select Cd_TPrv,Cd_TPrv, Descrip
		from TipProv
		where RucE=@RucE and Estado=1

	end
end
print @msj

-- Leyenda --
-- FL : 2011-07-14 : <Creacion del procedimiento almacenado>
GO
