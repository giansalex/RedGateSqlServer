SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec [user321].[Proc_Transf_SeriesXArea] '20512635025'
CREATE procedure [user321].[Proc_Transf_SeriesXArea]
@RucE nvarchar(11)
as


--set @RucE='20266194324'
declare @Consulta varchar(MAX) 

set @Consulta='

declare @Cd_Area nvarchar(6)
declare @Cd_Sr nvarchar(4)

Declare _cursor Cursor 
	For SELECT Cd_Area,Cd_Sr from OPENROWSET(''SQLOLEDB'',
 		  ''netserver'';''Usu123_1'';''user123'',
		  ''SELECT Itm_SA,RucE,Cd_Area,Cd_Sr 
		   from dbo.SeriesXArea where RucE='''''+@RucE+''''' '')
Open _cursor

	Fetch Next From _cursor Into @Cd_Area,@Cd_Sr
	While @@Fetch_Status = 0
		Begin
			Declare @Itm_SA int
			Set @Itm_SA = (select isnull(max(Itm_SA),0)+1 from SeriesXArea Where RucE=''' +@RucE+''')
			if not exists (select top 1 *from SeriesXArea where RucE='''+@RucE+''' and Cd_Area=@Cd_Area and Cd_Sr=@Cd_Sr)
				insert into SeriesXArea(Itm_SA,RucE,Cd_Area,Cd_Sr)
					values(@Itm_SA,'''+@RucE+''',@Cd_Area,@Cd_Sr)
		Fetch Next From _cursor Into @Cd_Area,@Cd_Sr
		End
Close _cursor
Deallocate _cursor'

print @Consulta
exec (@Consulta)
-- Leyenda
--JJ <11/01/2011>: creacion de procedimiento
GO
