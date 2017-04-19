SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Id_PHist](@RucE nvarchar(11))
returns int AS
begin 
      declare @n int
      select @n = max(Id_PHist) from PrecioHist where RucE=@RucE

      if @n is null
	set @n=1
      else
	set @n = @n+1
      return @n
end
GO
