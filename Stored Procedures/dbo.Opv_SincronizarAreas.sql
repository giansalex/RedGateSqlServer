SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Opv_SincronizarAreas]
@RucE nvarchar(11),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30),
@msj varchar(100) output
as
Declare @SQL varchar(max) 
set @SQL='
			Declare @CodAr char(2), @Nombre nvarchar(100), @RucE char(11)
			
			Declare SincronizarArea_Cursor cursor for
				select RucE,Descrip 
				from OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
								''select RucE,Descrip from ERP.dbo.Area where RucE='''''+@RucE+''''''')
			Open SincronizarArea_Cursor
				Fetch next from SincronizarArea_Cursor
				Into @RucE,@Descrip
			While @@FETCH_STATUS = 0
				Begin
					If exists (select * from CCostos where RucE=@RucECC and Cd_CC=@Cd_CC)
						Begin
							--Delete 
							print ''existe''
						End
					Fetch next from SincronizarArea_Cursor into @RucE,@Descrip
				End
			Close SincronizarArea_Cursor;
			Deallocate SincronizarArea_Cursor;
		 '

--select * from Area where RucE='11111111111'
GO
