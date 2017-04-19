SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Nro_OC](@RucE nvarchar(11))
returns char(10) AS
begin 
      declare @c char(10), @n int
      select @c = count(NroOC) from OrdCompra where RucE=@RucE
      if @c=0
	set @c='OC00000001'
      else
	begin
	select @c=max(NroOC) from OrdCompra where RucE=@RucE
	set @c= right(@c,8)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'OC'+right('00000000'+ltrim(str(@n)), 8 )
	end
       return @c
end

--LEYENDA
--CAM 02/09/2011 Creacion
GO
