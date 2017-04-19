SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Nro_RegVdt](@RucE nvarchar(11), @Cd_Vta nvarchar(10) )
returns int AS
begin 
/*   declare @n int
      select @n = count(Cd_Pro) from VentaDet where RucE=@RucE  and Cd_Vta=@Cd_Vta
      set @n = @n+1
      return @n
*/
      return (select isnull(Max(Nro_RegVdt),0)+1 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)

end


GO
