SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Id_LC](@RucE nvarchar(11))
returns int AS
begin 
      declare @n int
      select @n = max(Id_LC) from LimiteCredito where RucE=@RucE

      if @n is null
	set @n=1
      else
	set @n = @n+1
      return @n
end
GO
