SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_LineaConsUn]
@Cd_Ln nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from Linea where Cd_Ln=@Cd_Ln)
	set @msj = 'Linea no existe'
else	select * from Linea where Cd_Ln=@Cd_Ln
print @msj
GO
