SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_RubrosRptElim]
@Cd_Rb nvarchar(4),
@msj varchar(100) output
as
if not exists (select * from RubrosRpt where Cd_Rb=@Cd_Rb)
	set @msj = 'Rubro no existe'
else
begin
	delete from RubrosRpt where Cd_Rb=@Cd_Rb
	
	if @@rowcount <= 0
	   set @msj = 'Rubro no pudo ser eliminado'
end
print @msj
GO
