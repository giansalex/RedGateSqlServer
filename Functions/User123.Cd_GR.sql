SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cd_GR](@RucE nvarchar(11))
returns char(10) AS
begin 
      declare @c char(10), @n int
      select @c = count(Cd_GR) from GuiaRemision where RucE=@RucE
      if @c=0
	set @c='GR00000001'
      else
	begin
	      select @c=max(Cd_GR) from GuiaRemision where RucE=@RucE
      	      set @c= right(@c,8)  --> solo es necesario si lleva una letra adelante
	      set @n =convert(int, @c)+1
	      set @c = 'GR'+right('0000000'+ltrim(str(@n)), 8)
	end
       return @c
end
-- Leyenda --
-- PP : 2010-04-05 10:52:56.900	: <Creacion del funcition>
GO
