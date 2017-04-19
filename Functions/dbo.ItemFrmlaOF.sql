SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ItemFrmlaOF](@RucE nvarchar(11),@Cd_OF char(10))
returns int AS
begin 
      declare @c int, @n int
      select @c = count(Item) from FrmlaOF where RucE=@RucE and Cd_OF=@Cd_OF
      if @c=0
      	set @c='1'
      else
	begin
		select @c=max(Item) from FrmlaOF where RucE=@RucE and Cd_OF=@Cd_OF
		set @c =@c+1
	end
       return @c
end
GO
