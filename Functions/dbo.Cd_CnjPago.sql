SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_CnjPago](@RucE nvarchar(11))
returns char(10) AS
begin 
    declare @c nvarchar(10), @n int
    select @c = count(Cd_Cnj) from CanjePago where RucE=@RucE
    if @c=0
		set @c='0000000001'
    else
	begin
		select @c=max(Cd_Cnj) from CanjePago where RucE=@RucE
		set @n =convert(int, @c)+1
		set @c = right('0000000000'+ltrim(str(@n)), 10)
	end
      
    return @c

end

GO
