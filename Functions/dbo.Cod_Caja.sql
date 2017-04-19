SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cod_Caja](@RucE nvarchar(11))
returns varchar(20) 
AS
begin
Declare  @c int, @n nvarchar(20)

if exists (select * from Caja where RucE = @RucE)
	Select @c = convert(int,right(Max(Cd_Caja),4))+1 from Caja Where RucE=@RucE
	
	if(LEN(@c) = 4)
		set @n = 'CJ' + convert(nvarchar(20), @c) 
	else if(LEN(@c) = 3)
		set @n = 'CJ0' + convert(nvarchar(20), @c) 
	else if(LEN(@c) = 2)
		set @n = 'CJ00' + convert(nvarchar(20), @c)  
	else if(LEN(@c) = 1)
		set @n = 'CJ000' + convert(nvarchar(20), @c) 

else
	set @n = 'CJ0001'
return @n

end

/*
Declare  @c int, @n nvarchar(20)
Select @c = convert(int,right(Max(Cd_Caja),4))+1 from Caja Where RucE='11111111111'
print @c

declare @c nvarchar(20)
set @c = dbo.Cod_Caja('11111111111')
print @c
*/
GO
