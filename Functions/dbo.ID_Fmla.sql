SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ID_Fmla](@RucE nvarchar(11))
returns int AS
begin 
      declare @n int
      select @n = count(ID_Fmla) from Formula where RucE=@RucE

      if @n=0
	set @n=1
      else
	begin
	select @n=max(ID_Fmla) from Formula where RucE=@RucE
	set @n = @n+1
	end
      return @n
end


GO
