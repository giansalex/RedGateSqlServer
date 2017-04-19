SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupVdrCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin
	if(@TipCons=0)
		 select * from ComisionGrupVdr  Where RucE=@RucE
	else if(@TipCons=1)
		select Cd_CGV+'  |  '+Descrip as CodNom,Cd_CGV,Descrip from ComisionGrupVdr Where RucE=@RucE and Estado=1
	else if(@TipCons=2)
		select * from ComisionGrupVdr Where RucE=@RucE and Estado=1
	else if(@TipCons=3)
		select Cd_CGV, Cd_CGV, Descrip from ComisionGrupVdr Where RucE=@RucE and Estado=1

end
print @msj
GO
