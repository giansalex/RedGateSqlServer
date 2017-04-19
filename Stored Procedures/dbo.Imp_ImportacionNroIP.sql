SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Imp_ImportacionNroIP]
@RucE nvarchar(11),
@NroImp varchar(25) output,
@msj varchar(100) output
as

if not exists(select * from importacion where RucE=@RucE)
begin
	--set @msj='no tiene importaciones'
	set @NroImp = 'IP000000001'
end
else
	select @NroImp = 'IP'+right('00000000' + convert(varchar, convert(int, right(MAX(NroImp),8))+1),8) from importacion where RucE=@RucE and left(NroImp,2)  = 'IP' and len(NroImp) = 10
GO
