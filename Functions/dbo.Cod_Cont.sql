SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cod_Cont]()
returns int AS
begin 
      declare @cod int,@c int
      select @c = count(ID_Gen) from Contacto

      if @c=0
	set @cod=1
      else
	begin
	select @c=max(ID_Gen) from Contacto
	set @cod =@c+1
	end
       return @cod

end
GO
