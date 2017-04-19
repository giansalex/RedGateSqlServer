SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Id_CCOF](@RucE nvarchar(11), @Cd_OF char(10))
returns char(10) AS
begin
      declare @n int
      select @n = max(Id_CCOF) from CptoCostoOF where RucE=@RucE and Cd_OF = @Cd_OF
      if @n is null
	set @n=1
      else
	set @n = @n+1
      return @n
end
GO
