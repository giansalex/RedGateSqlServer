SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Nro_RegVtaRM](@RucE nvarchar(11))
returns int AS
begin 
/*    declare @n int
      select @n = count(NroReg) from VentaRM where RucE=@RucE
      set @n = @n+1
      return @n
*/
      return (select isnull(Max(NroReg),0)+1 from VentaRM where RucE=@RucE)

end




GO
