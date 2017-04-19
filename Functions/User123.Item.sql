SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Item](@RucE nvarchar(11),@Cd_MIS char(3), @Ejer varchar(4))
returns int AS
begin 
      declare @c int, @n int
      select @c = count(Item) from Asiento where RucE=@RucE and Cd_MIS=@Cd_MIS and Ejer=@Ejer
      if @c=0
      	set @c='1'
      else
	begin
		select @c=max(Item) from Asiento where RucE=@RucE and Cd_MIS=@Cd_MIS and Ejer=@Ejer
		set @c =@c+1
	end
       return @c
end


GO
