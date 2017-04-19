SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Act_GeneraNroAct]

@NroDoc nvarchar(8) output,
@msj nvarchar(100) output
as

Declare @Nro nvarchar(8)

set @Nro = convert(nvarchar,((select Max(Cd_Act) from actividad) + 1)) 
set @NroDoc = right('00000000'+@Nro,8)


print @NroDoc

--exec Act_GeneraNroAct null



GO
