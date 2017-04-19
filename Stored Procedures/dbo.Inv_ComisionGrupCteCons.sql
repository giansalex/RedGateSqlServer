SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ComisionGrupCteCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin
	if(@TipCons=0)
		 select * from ComisionGrupCte Where RucE= @RucE
	else if(@TipCons=1)
		select Cd_CGC+'  |  '+Descrip as CodNom,Cd_CGC,Descrip from ComisionGrupCte Where RucE= @RucE and Estado=1
	else if(@TipCons=2)
		select * from ComisionGrupCte Where RucE= @RucE and Estado=1
	else if(@TipCons=3)
		select Cd_CGC, Cd_CGC, Descrip from ComisionGrupCte Where RucE= @RucE and Estado=1

end
print @msj
---J : 04-06-2010 <Modificado : se agrego el campo @RucE>
GO
