SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cod_Mca](@RucE nvarchar(11))
returns char(3) AS
begin 
    declare @c char(3), @n int
    select @c = count(Cd_Mca) from Marca where RucE=@RucE
    if @c=0
		set @c='001'
    else
			begin
			select @c=max(convert(int,Cd_Mca))from Marca where RucE=@RucE
		--	set @c= right(@c,2)  --> solo es necesario si lleva una letra adelante
			set @n = 0
			set @n =convert(int, @c)
			set @n =@n+1
			set @c = right('00'+ltrim(str(@n)), 3)
	end
       return @c
end
GO
