SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Cfg_JalaAsientos_Crea_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@Ejer varchar(4),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as

declare @EjerBase varchar(4)
set @EjerBase=@Ejer
declare @Consulta varchar(8000)

set @Consulta='
declare @Cd_MIS char(3)
declare @Descrip varchar(150)
declare @Cd_TM char(2)
declare @Estado bit
declare @IC_ES char(1)

declare _Cursor cursor for

select Cd_MIS,Descrip,Cd_TM,Estado,IC_ES from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
    ''select Cd_MIS,Descrip,Cd_TM,Estado,IC_ES
    from MtvoIngSal where RucE='''''+@RucEBase+''''' '')

Open _Cursor
Fetch Next From _Cursor Into @Cd_MIS,@Descrip,@Cd_TM,@Estado,@IC_ES
while @@fetch_status=0
Begin

	if not exists (select top 1 *from MtvoIngSal where RucE='''+@RucE+''' and Cd_MIS=@Cd_MIS)
	insert into MtvoIngSal(RucE,Cd_MIS,Descrip,Cd_TM,Estado,IC_ES) values ('''+@RucE+''',@Cd_MIS,@Descrip,@Cd_TM,@Estado,@IC_ES)
	
	--Importando Asientos
	exec dbo.Cfg_JalaAsientos_Crea_Asientos '''+@RucE+''','''+@RucEBase+''','''+@Ejer+''','''+@EjerBase+''',@Cd_MIS

	
	Fetch Next From _Cursor Into @Cd_MIS,@Descrip,@Cd_TM,@Estado,@IC_ES
End

Close _Cursor
Deallocate _Cursor
'
print @Consulta
exec (@Consulta)
GO
