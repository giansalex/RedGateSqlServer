SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [User123].[ItemGRP](@RucE nvarchar(11),@Cd_GR char(10))
returns int AS
begin
	declare @c int
	select @c = count(Item) from GRPtoLlegada where RucE=@RucE and Cd_GR=@Cd_GR
	if @c=0
		set @c='1'
      else
	begin
		select @c=max(Item) from GRPtoLlegada where RucE=@RucE and Cd_GR=@Cd_GR
		set @c =@c+1
	end
       return @c
end

GO
