SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_SSCCostosCons_Grupo]
@RucE nvarchar(11),
@Cadena varchar(8000),
@msj varchar(100) output
as

if(@Cadena = '')
Begin
	Select Cd_CC, Cd_CC as Cd_CC1, Cd_SC, Cd_SC as Cd_SC1, Cd_SS, Cd_SS as Cd_SS1,NCorto,Descrip from CCSubSub where RucE=@RucE
End
Else
Begin
	Declare @Cons varchar(2000)
	
	set @Cons='
	Select Cd_CC, Cd_CC as Cd_CC1, Cd_SC, Cd_SC as Cd_SC1, Cd_SS, Cd_SS as Cd_SS1,NCorto,Descrip
	From CCSubSub
	Where RucE='''+@RucE+''''
		  
	exec(@Cons+' and Cd_CC+''_''+Cd_SC in ('+@Cadena+')')
End

-- Leyenda --
-- DI : 15/10/2012 <Creacion del SP>

GO
