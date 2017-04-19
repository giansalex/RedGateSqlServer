SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cd_SC](@RucE nvarchar(11))---> Funcion que genera codigo de Solicitud de Compra
returns char(10) AS
begin 
      declare @c char(10), @n int
      select @c = count(Cd_SCo) from SolicitudCom where RucE=@RucE
      if @c=0
	set @c='SC00000001'
      else
	begin
	select @c=max(Cd_SCo) from SolicitudCom where RucE=@RucE
	set @c= right(@c,8)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'SC'+right('00000000'+ltrim(str(@n)), 8 )
	end
       return @c
end

GO
