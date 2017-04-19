SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Id_CTb]()
returns int AS
begin 
      declare @n int
      select @n = count(Id_CTb) from CampoTabla

      if @n=0
	set @n=1
      else
	begin
	select @n=max(Id_CTb) from CampoTabla

	set @n = @n+1
	end
      return @n
end
GO
