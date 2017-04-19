SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_RubrosRptMdf]
@Cd_Rb nvarchar(4),
@Descrip varchar(50),
@Cd_TR nvarchar(2),
@IN_Nivel smallint,
@Formula varchar(30),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from RubrosRpt where Cd_Rb=@Cd_Rb)
	set @msj = 'Rubro no existe'
else
begin
	update RubrosRpt set Descrip=@Descrip, Cd_TR=@Cd_TR, IN_Nivel=@IN_Nivel,
			    Formula=@Formula, Estado=@Estado
	where Cd_Rb=@Cd_Rb
	
	if @@rowcount <= 0
	   set @msj = 'Rubro no pudo ser modificado'
end
print @msj
GO
