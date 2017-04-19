SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_AmarreCta]
@RucE nvarchar(11),
@Ejer varchar(4)
as
declare @Consulta varchar(4000)
set @Consulta='
declare @Item int
declare @NroCta nvarchar(10)
declare @CtaD nvarchar(10)
declare @CtaH nvarchar(10)
declare @Porc numeric (5,2)
declare @Ejer varchar(4)


Declare _cursor Cursor 
	For SELECT NroCta,CtaD,CtaH,Porc  from OPENROWSET(''SQLOLEDB'',
	 ''netserver'';''Usu123_1'';''user123'',
	 ''SELECT RucE,NroCta,CtaD,CtaH,Porc
	  from dbo.AmarreCta where RucE='''''+@RucE+''''' '')
Open _cursor
	Fetch Next From _cursor Into @NroCta,@CtaD,@CtaH,@Porc
	While @@Fetch_Status = 0
		Begin
			set @Item=dbo.Item_AmarreCta('''+@RucE+''')
			insert into AmarreCta(Item,RucE,Ejer,NroCta,CtaD,CtaH,Porc)
				values(@Item,'''+@RucE+''','''+@Ejer+''',@NroCta,@CtaD,@CtaH,@Porc)
		Fetch Next From _cursor Into @NroCta,@CtaD,@CtaH,@Porc
		End
Close _cursor
Deallocate _cursor
'
print @Consulta
exec(@Consulta)
--Leyenda
--JJ  11/01/2010:<Creacion del Procedimiento>
--MP : 23/10/2011 : <Creacion del procedimiento almacenado>
GO
