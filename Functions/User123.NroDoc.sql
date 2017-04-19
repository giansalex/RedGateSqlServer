SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [User123].[NroDoc](@RucE nvarchar(11), @Cd_Sr nvarchar(4))
returns nvarchar(7) AS
begin 
      declare @c nvarchar(7), @n int
      select @c = count(NroDoc) from Venta where RucE=@RucE and Cd_Sr=@Cd_Sr
      if @c=0
	set @c='0000001'
      else
	begin
	select @c=max(NroDoc) from Venta where RucE=@RucE and Cd_Sr=@Cd_Sr
--	set @c= right(@c,2)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = right('0000000'+ltrim(str(@n)), 7)
	end
       return @c

end




GO
