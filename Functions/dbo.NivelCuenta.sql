SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[NivelCuenta]
(
	-- Add the parameters for the function here
	@NroCta nvarchar(15),
	@Nivel int
)
RETURNS nvarchar(15)
AS
BEGIN
	declare @NroCtaR nvarchar(15)
	declare @NroCtaA nvarchar(15)
	if(@Nivel = 1)	
		set  @NroCtaR = left(@NroCta, Charindex('.',@NroCta)-1)
	else if(@Nivel =2)
	begin
		set @NroCtaA = right(@NroCta,(len(@NroCta)-Charindex('.',@NroCta)))	
		set @NroCtaA = right(@NroCtaA,(len(@NroCtaA)-Charindex('.',@NroCtaA)))
		set @NroCtaR = left(@NroCta, len(@NroCta) - len(@NroCtaA)-1)
	end
	else if(@Nivel =3)
	begin
		set @NroCtaA = right(@NroCta,(len(@NroCta)-Charindex('.',@NroCta)))	
		set @NroCtaA = right(@NroCtaA,(len(@NroCtaA)-Charindex('.',@NroCtaA)))
		set @NroCtaA = right(@NroCtaA,(len(@NroCtaA)-Charindex('.',@NroCtaA)))
		set @NroCtaR = left(@NroCta, len(@NroCta) - len(@NroCtaA)-1)
	end
	else if(@Nivel =4)
	begin
		set @NroCtaA = right(@NroCta,(len(@NroCta)-Charindex('.',@NroCta)))	
		set @NroCtaA = right(@NroCtaA,(len(@NroCtaA)-Charindex('.',@NroCtaA)))
		set @NroCtaA = right(@NroCtaA,(len(@NroCtaA)-Charindex('.',@NroCtaA)))
		set @NroCtaA = right(@NroCtaA,(len(@NroCtaA)-Charindex('.',@NroCtaA)))
		set @NroCtaR = left(@NroCta, len(@NroCta) - len(@NroCtaA)-1)
	end
	return @NroCtaR

END
GO
