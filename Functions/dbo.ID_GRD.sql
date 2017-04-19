SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ID_GRD](@RucE nvarchar(11),@Cd_GR char(10))
returns int AS
begin 
	declare @c int
	select @c=count(*) from GuiaRemisionDet where RucE = @RucE and Cd_GR = @Cd_GR
	if @c=0
		set @c=1
	else
		begin
			select @c=max(item) from GuiaRemisionDet where RucE = @RucE and Cd_GR = @Cd_GR
			set @c =@c+1
		end
	return @c
end

-- Leyenda --
-- PP : 2010-03-31 11:00:14.040	: <Creacion del funcition>

GO
