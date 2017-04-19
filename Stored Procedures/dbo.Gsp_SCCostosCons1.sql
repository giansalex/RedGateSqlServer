SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SCCostosCons1]
@TipCons int,
@RucE nvarchar(11),
@Cd_CC varchar(8000),
@msj varchar(100) output
as

declare @Cons varchar(max)
begin
	if(@TipCons=2)--SOLO PARA LA PANTALLA DE Gfm_CCostos
	begin
	set @Cons='
		select Cd_CC,Cd_CC as Cd_CC1, Cd_SC, Cd_SC as Cd_SC1,NCorto, Descrip from CCSub where RucE='''+@RucE+''' and'
		-- Cd_CC=@Cd_CC
	end
exec(
	@Cons+' Cd_CC in ('''+@Cd_CC
	+''')')

end
print @msj

-- exec Gsp_SCCostosCons1 2,'20543954773','ADMI',null
GO
