SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec [Cfg_JalaAsientos_Crea] '11111111111','2011','11111111111','2012',NULL
CREATE procedure [dbo].[Cfg_JalaAsientos_Crea]
@RucEBase nvarchar(11),
@EjerBase varchar(4),
@RucE nvarchar(11),
@Ejer varchar(4),
@msj varchar(100) output
as

declare @Cd_MIS char(3)

declare _Cursor cursor for
select Cd_MIS from MtvoIngSal where RucE=@RucEBase

Open _Cursor
Fetch Next From _Cursor Into @Cd_MIS
while @@fetch_status=0
Begin

	--Importando Asientos
	exec dbo.Cfg_JalaAsientos_Crea_Asientos @RucE,@RucEBase,@Ejer,@EjerBase,@Cd_MIS

	
	Fetch Next From _Cursor Into @Cd_MIS
End

Close _Cursor
Deallocate _Cursor

GO
