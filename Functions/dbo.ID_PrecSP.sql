SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ID_PrecSP] (@RucE nvarchar(11))
returns int AS
begin 
      declare @n int
      select @n = count(ID_PrecSP) from ServProvPrecio where RucE = @RucE
      if @n=0
	set @n=1
      else
	begin
	select @n= max(ID_PrecSP ) from ServProvPrecio where RucE = @RucE
	set @n = @n+1
	end
       return @n
end
-- Leyenda --
-- FL -- 2010-08-26	: <Creacion de la Funcion>
GO
