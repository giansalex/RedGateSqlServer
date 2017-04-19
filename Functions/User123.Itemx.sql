SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Itemx](@RucE nvarchar(11), @Cd_Cot char(10), @ID_CtD int)
returns int AS
begin 
      declare @c int, @n int
      select @c = count(Item) from CotizacionProdDet where RucE=@RucE and Cd_Cot=@Cd_Cot and ID_CtD=@ID_CtD
      if @c=0
      	set @c='1'
      else
	begin
		select @c=max(Item) from CotizacionProdDet where RucE=@RucE and Cd_Cot=@Cd_Cot and ID_CtD=@ID_CtD
		set @c =@c+1
	end
       return @c
end

GO
