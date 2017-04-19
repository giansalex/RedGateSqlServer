SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Id_ComisionConf]()
returns int AS
begin 
      declare @n int
      select @n = count(Id_CC) from ComisionConfig

      if @n=0
	set @n=1
      else
	begin
	select @n=max(Id_CC) from ComisionConfig
	set @n = @n+1
	end
      return @n
end
GO
