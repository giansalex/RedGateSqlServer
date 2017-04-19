SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create FUNCTION [dbo].[Cd_ConceptoRetDetProv]
(
	-- Add the parameters for the function here
	@RucE nvarchar(11),
	@Cd_ConceptoRet char(10)
)
RETURNS char(10)
AS
BEGIN
	declare @c nvarchar(10), @n int
	select @c = count(Cd_ConceptoRet) from ConceptoRetencionDetProv where RucE = @RucE And Cd_ConceptoRet = @Cd_ConceptoRet
	if @c =0
		set @c = '0000000001'
	else
	begin
		select @c = max(Cd_ConceptoRetDetProv) from ConceptoRetencionDetProv where RucE = @RucE And Cd_ConceptoRet = @Cd_ConceptoRet
		set @n = convert(int,@c) + 1
		set @c = right('0000000000'+ltrim(str(@n)), 10)
	end
	

	-- Return the result of the function
	return @c

END
GO
