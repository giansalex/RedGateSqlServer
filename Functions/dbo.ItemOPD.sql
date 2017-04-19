SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ItemOPD](@RucE nvarchar(11),@Cd_OP char(10))
returns int AS
begin 
      declare @n int
      select @n = count(Item) from OrdPedidoDet where RucE = @RucE and Cd_OP = @Cd_OP
      if @n=0
	set @n=1
      else
	begin
	select @n= max(Item) from OrdPedidoDet where RucE = @RucE and Cd_OP = @Cd_OP
	set @n = @n+1
	end
       return @n
end
-- Leyenda --
-- JJ -- 2010-08-09	: <Creacion de la Funcion>

GO
