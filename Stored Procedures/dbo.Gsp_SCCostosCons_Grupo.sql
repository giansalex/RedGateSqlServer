SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SCCostosCons_Grupo]
@RucE nvarchar(11),
@Cadena varchar(8000),
@msj varchar(100) output
as

if(@Cadena = '')
Begin
	Select Cd_CC,Cd_CC as Cd_CC1, Cd_SC, Cd_SC as Cd_SC1,NCorto, Descrip from CCSub where RucE=@RucE
End
Else
Begin

	declare @Cons varchar(max)
	begin
		set @Cons='
			select Cd_CC,Cd_CC as Cd_CC1, Cd_SC, Cd_SC as Cd_SC1,NCorto, Descrip from CCSub where RucE='''+@RucE+''' and'

		exec(@Cons+' Cd_CC in ('+@Cadena+')')

	end
End
-- Leyenda --
-- DI : 15/10/2012 <Creacion del SP>

GO
