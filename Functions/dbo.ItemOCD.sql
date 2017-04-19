SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ItemOCD](@RucE nvarchar(11),@Cd_OC char(10))
returns int AS
begin 
      declare @n int
      select @n = count(Item) from OrdCompraDet where RucE = @RucE and Cd_OC = @Cd_OC
      if @n=0
	set @n=1
      else
	begin
	select @n= max(Item) from OrdCompraDet where RucE = @RucE and Cd_OC = @Cd_OC
	set @n = @n+1
	end
       return @n
end
-- Leyenda --
-- JU -- 2010-07-01	: <Creacion de la Funcion>

GO
