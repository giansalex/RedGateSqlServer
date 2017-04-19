SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Itm_CC](@RucE nvarchar(11), @Cd_Caja	nvarchar (20))
returns int AS
begin 
      declare @n int
      select @n = count(Itm_CC) from CfgCaja where RucE = @RucE and Cd_Caja = @Cd_Caja
      if @n=0
	set @n=1
      else
	begin
	select @n= max(Itm_CC) from CfgCaja where RucE = @RucE and Cd_Caja = @Cd_Caja
	set @n = @n+1
	end
       return @n
end
GO
