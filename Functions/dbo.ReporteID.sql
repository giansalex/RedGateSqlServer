SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[ReporteID](@RucE nvarchar(11))
returns char(10) As
BEGIN
	declare @n char(10)
	Select @n = COUNT(RucE) from Reportes Where RucE = @RucE
	if @n = 0
		set @n = '000000001'
	else
	begin
		set @n = right('0000000000' + ltrim(str(convert(int, (select MAX(ReporteID) from Reportes Where RucE = @RucE)) + 1)),10)
	end
	-- Return the result of the function
	RETURN @n

END
GO
