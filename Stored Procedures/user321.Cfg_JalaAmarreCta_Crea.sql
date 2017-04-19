SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--[user321].[Cfg_JalaAmarreCta_Crea] '11111111111','11111111111','2010','2011',null
CREATE procedure [user321].[Cfg_JalaAmarreCta_Crea]
@RucE nvarchar(11),
@RucBase nvarchar(11),
@EjerBase varchar(4),
@Ejer varchar(4),
@msj varchar(100) output
as
declare @Item int
declare @NroCta nvarchar(10)
declare @CtaD nvarchar(10)
declare @CtaH nvarchar(10)
declare @Porc numeric (5,2)
declare @Consulta varchar(max)
Declare _cursor Cursor 
	For SELECT NroCta,CtaD,CtaH,Porc from dbo.AmarreCta where RucE=@RucBase and Ejer=@EjerBase
Open _cursor
	Fetch Next From _cursor Into @NroCta,@CtaD,@CtaH,@Porc--,@Ejer
	While @@Fetch_Status = 0
		Begin
			set @Item=dbo.Item_AmarreCta(@RucE)
			--print Isnull(@Item,0)
			insert into AmarreCta(Item,RucE,NroCta,CtaD,CtaH,Porc,Ejer)
				values(@Item,@RucE,@NroCta,@CtaD,@CtaH,@Porc,@Ejer)
				
			set @Consulta='insert into AmarreCta(Item,RucE,NroCta,CtaD,CtaH,Porc,Ejer)
							values('+Convert(Varchar,@Item)+','''+@RucE+''','''+@NroCta+''','''+@CtaD+''','''+@CtaH+''','+Convert(Varchar,@Porc)+','''+@Ejer+''')'
			--print @Consulta
		Fetch Next From _cursor Into @NroCta,@CtaD,@CtaH,@Porc--,@Ejer
		End
Close _cursor
Deallocate _cursor

--if @@rowcount <= 0
	   --set @msj = 'No se pudo efectuar los cambios'	
--Leyenda
--JJ  11/01/2010:<Creacion del Procedimiento>
--MP : 23/10/2011 : <Creacion del procedimiento almacenado>
GO
