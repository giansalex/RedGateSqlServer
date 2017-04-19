SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_RubrosRptConsUn]
@Cd_Rb nvarchar(4),
@msj varchar(100) output
as
if not exists (select * from RubrosRpt where Cd_Rb=@Cd_Rb)
	set @msj = 'Rubro no existe'
else	select * from RubrosRpt where Cd_Rb=@Cd_Rb
print @msj
GO
