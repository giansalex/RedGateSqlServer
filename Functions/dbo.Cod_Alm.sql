SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cod_Alm](@RucE nvarchar(11),@padre nvarchar(20))
returns varchar(20) 
AS
begin
	Declare  @c int, @n nvarchar(20)
	if (isnull(len(@padre),0)=0)
		begin
			if exists (select * from Almacen where RucE = @RucE)
				Select @n = 'A' + right('00'+convert(varchar, convert(int,right(Max(Cd_Alm),2))+1),2) from Almacen Where RucE=@RucE and len(Cd_Alm)=3
				
			else
				set @n = 'A01'
		end
	else
		begin
			if exists (select * from Almacen where RucE = @RucE and Cd_Alm like @padre+'%' and len(Cd_Alm)=len(@padre)+2)
				Select @n = @padre + right('00'+convert(varchar, convert(int,right(Max(Cd_Alm),2))+1),2) from Almacen Where RucE=@RucE and Cd_Alm like @padre+'%' and len(Cd_Alm)=len(@padre)+2
			else
				set @n = @padre+'01'
		end
	return @n
end 


GO
GRANT EXECUTE ON  [dbo].[Cod_Alm] TO [User123]
GO
