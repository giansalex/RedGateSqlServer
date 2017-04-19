SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[Id_Niv]()
returns int AS
begin 
      declare @n int
      select @n = count(Id_Niv) from CfgNivelAut
      if @n=0
	set @n=1
      else
	begin
	select @n=max(Id_Niv) from CfgNivelAut
	set @n = @n+1
	end
      return @n
end
GO
