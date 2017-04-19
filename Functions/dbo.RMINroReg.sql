SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[RMINroReg]()
returns int AS
begin 
	declare @n int
	select @n = count(NroReg) from RMInterno
	if @n=0
		set @n=1
	else
		select @n=max(NroReg)+1 from RMInterno
	return @n
end
GO
