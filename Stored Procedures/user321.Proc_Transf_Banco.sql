SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_Banco]
@RucE nvarchar(11),
@Ejer varchar(4)
as

declare @Consulta varchar(4000)
set @Consulta='
declare @Itm_BC nvarchar(10)
declare @NroCta nvarchar(10)
declare @NCtaB nvarchar(50)
declare @NCorto varchar(6)
declare @Cd_Mda nvarchar(2)
declare @Estado bit

Declare _cursor Cursor 
	For  SELECT Itm_BC, NroCta, NCtaB, NCorto, Cd_Mda, Estado from OPENROWSET(''SQLOLEDB'',
		  ''netserver'';''Usu123_1'';''user123'',
		  ''SELECT RucE, Itm_BC, NroCta, NCtaB, NCorto, Cd_Mda, Estado
		   from dbo.Banco where RucE='''''+@RucE+''''' '')

Open _cursor
	Fetch Next From _cursor Into @Itm_BC,@NroCta,@NCtaB,@NCorto,@Cd_Mda,@Estado
	While @@Fetch_Status = 0
		Begin
			set @Itm_BC=user123.Itm_BC('''+@RucE+''')
			insert into Banco(RucE,Itm_BC,Ejer,NroCta,NCtaB,NCorto,Cd_Mda,Estado,Cd_EF)
				values('''+@RucE+''',@Itm_BC,'''+@Ejer+''',@NroCta,@NCtaB,@NCorto,@Cd_Mda,@Estado,''33'')
		Fetch Next From _cursor Into @Itm_BC,@NroCta,@NCtaB,@NCorto,@Cd_Mda,@Estado
		End
Close _cursor
Deallocate _cursor
'
print @Consulta
exec(@Consulta)
--[user321].[Proc_Transf_Banco] '11111111111','2001'
--Leyenda
--JJ  11/01/2010:<Creacion del Procedimiento>
GO
