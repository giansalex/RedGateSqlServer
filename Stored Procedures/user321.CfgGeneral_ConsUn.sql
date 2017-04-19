SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[CfgGeneral_ConsUn]
@RucE varchar(11),
@msj nvarchar(100) output
as
	if not exists (select * from CfgGeneral  where RucE = @RucE)
		set @msj = 'No ha ha realizado configuraciones generales, Verificar'
	else
	begin
		select * from CfgGeneral
		where RucE = @RucE
	end
	

GO
