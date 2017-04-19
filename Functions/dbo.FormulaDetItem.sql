SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FormulaDetItem](@RucE nvarchar(11),@ID_Fmla int)
returns int AS
begin 
      declare @n int
      select @n = count(Item) from FormulaDet where RucE=@RucE and ID_Fmla=@ID_Fmla

      if @n=0
	set @n=1
      else
	begin
	select @n=max(Item) from FormulaDet where RucE=@RucE and ID_Fmla=@ID_Fmla
	set @n = @n+1
	end
      return @n
end
GO
