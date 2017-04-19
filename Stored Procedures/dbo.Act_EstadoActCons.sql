SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Act_EstadoActCons]
@RucE nvarchar(11),
@TipCons int, 
@msj varchar(100) output
as
	if(@TipCons=0)
	   select * from EstadoAct where RucE=@RucE
	else 
	begin
		Declare @lmax int
		Set @lmax = (select Max(len(Cd_EA)) from EstadoAct where RucE=@RucE and Estado=1)
		select left(Cd_EA+'__________',@lmax)+'  |  '+Descrip as CodNom, Cd_EA, Descrip from EstadoAct where  RucE=@RucE and Estado=1
	end

print @msj
GO
