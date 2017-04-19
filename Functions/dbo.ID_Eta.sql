SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create FUNCTION [dbo].[ID_Eta](@RucE nvarchar(11),@Cd_Fab	char	(10))
returns int AS
begin 
      declare @n int
      select @n = count(ID_Eta) from FabEtapa where RucE=@RucE and Cd_Fab = @Cd_Fab

      if @n=0
	set @n=1
      else
	begin
	select @n=max(ID_Eta) from FabEtapa where RucE=@RucE and Cd_Fab = @Cd_Fab
	set @n = @n+1
	end
      return @n
end

GO
