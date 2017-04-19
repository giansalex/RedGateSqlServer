SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ItemCD](@RucE nvarchar(11),@Cd_Com char(10))
returns int AS
begin 
      declare @n int
      select @n = count(Item) from CompraDet where RucE = @RucE and Cd_Com = @Cd_Com
      if @n=0
	set @n=1
      else
	begin
	select @n= max(Item) from CompraDet where RucE = @RucE and Cd_Com = @Cd_Com
	set @n = @n+1
	end
       return @n
end
-- Leyenda --
-- JJ -- 2010-08-24	: <Creacion de la Funcion>


GO
