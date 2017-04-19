SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[Cod_Perfil]()
returns nvarchar(3) AS
begin 
      declare @c nvarchar(3), @n int
      select @c = count(Cd_Prf) from Perfil

      if @c=0
	set @c='001'
      else
	begin
	select @c=max(Cd_Prf) from Perfil
--	set @c= right(@c,3)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = right('000'+ltrim(str(@n)), 3 )
	end
       return @c

end





GO
