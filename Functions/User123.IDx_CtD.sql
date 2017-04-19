SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[IDx_CtD](@RucE nvarchar(11), @Cd_Cot char(10))
returns int AS
begin 
      declare @c int, @n int
      select @c = count(ID_CtD) from CotizacionDet where RucE=@RucE and Cd_Cot=@Cd_Cot
      if @c=0
      	set @c='1'
      else
	begin
		select @c=max(ID_CtD) from CotizacionDet where RucE=@RucE and Cd_Cot=@Cd_Cot
		set @c =@c+1
	end
       return @c
end

GO
