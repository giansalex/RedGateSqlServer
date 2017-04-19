SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Itm_SC](@RucE nvarchar(11),@Cd_SC char(10))
returns int AS
begin 
      declare @c int, @n int
      select @c = count(Item) from SolicitudComDet where RucE=@RucE and Cd_SC=@Cd_SC
      if @c=0
      	set @c='1'
      else
	begin
		select @c=max(Item) from SolicitudComDet where RucE=@RucE and Cd_SC=@Cd_SC
		set @c =@c+1
	end
       return @c
end
GO
