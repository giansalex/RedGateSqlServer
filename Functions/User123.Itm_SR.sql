SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Itm_SR](@RucE nvarchar(11),@Cd_SR char(10))
returns int AS
begin 
      declare @c int, @n int
      select @c = count(Item) from SolicitudReqDet where RucE=@RucE and Cd_SR=@Cd_SR
      if @c=0
      	set @c='1'
      else
	begin
		select @c=max(Item) from SolicitudReqDet where RucE=@RucE and Cd_SR=@Cd_SR
		set @c =@c+1
	end
       return @c
end

GO
