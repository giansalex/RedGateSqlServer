SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Itm_EEOF](@RucE nvarchar(11),@Cd_OF char(10))
returns int AS
begin 
      declare @c int, @n int
      select @c = max(Item) from EnvEmbOF where RucE=@RucE and Cd_OF=@Cd_OF
      if @c is null
      	set @c='1'
      else
	set @c =@c+1
       return @c
end
GO
