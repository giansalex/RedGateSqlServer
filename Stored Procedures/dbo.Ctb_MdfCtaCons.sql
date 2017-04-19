SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Ctb_MdfCtaCons] --exec Ctb_MdfCtaCons '11111111111','2009','''00'',''01'',''02'',''03'',''04'',''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'',''13'',''14''','''94.1.0.01''','','1',null
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Prdo nvarchar(1000),
@NroCta nvarchar(1000),
@CodAux char(10),
@TipAux char(1),
@msj nvarchar(100) output
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @CodAux = ''
	BEGIN
	exec ('Select v.RucE, v.RegCtb, v.NroCta, v.FecMov, v.MtoD, v.MtoH, v.MtoD_ME, v.MtoH_ME, v.Cd_MdRg, v.CamMda, m.Simbolo, v.Cd_Vou, Convert(bit,0) as Sel
	From Voucher v join PlanCtas p on v.NroCta = p.NroCta and v.RucE = p.RucE join Moneda m on v.Cd_MdRg = m.Cd_Mda
	Where v.RucE = '''+@RucE+''' and v.Ejer = '''+@Ejer+''' and p.Nivel = 4 and v.NroCta in ('+@NroCta+') and Prdo in ('+@Prdo+')
	Group by v.RucE, v.RegCtb, v.NroCta, v.FecMov, v.MtoD, v.MtoH, v.MtoD_ME, v.MtoH_ME, v.Cd_MdRg, v.CamMda, m.Simbolo, v.Cd_Vou
	Order by v.RegCtb')
	END
	ELSE
	BEGIN
		IF @TipAux = 0
		BEGIN
		exec ('Select v.RucE, v.RegCtb, v.NroCta, v.FecMov, v.MtoD, v.MtoH, v.MtoD_ME, v.MtoH_ME, v.Cd_MdRg, v.CamMda, m.Simbolo, v.Cd_Vou, Convert(bit,0) as Sel
		From Voucher v join PlanCtas p on v.NroCta = p.NroCta and v.RucE = p.RucE join Moneda m on v.Cd_MdRg = m.Cd_Mda
		Where v.RucE = '''+@RucE+''' and v.Ejer = '''+@Ejer+''' and p.Nivel = 4 and v.NroCta in ('+@NroCta+') and Prdo in ('+@Prdo+') and v.Cd_Clt = '''+@CodAux+'''
		Group by v.RucE, v.RegCtb, v.NroCta, v.FecMov, v.MtoD, v.MtoH, v.MtoD_ME, v.MtoH_ME, v.Cd_MdRg, v.CamMda, m.Simbolo, v.Cd_Vou
		Order by v.RegCtb')
		END
		ELSE
		BEGIN
		exec ('Select v.RucE, v.RegCtb, v.NroCta, v.FecMov, v.MtoD, v.MtoH, v.MtoD_ME, v.MtoH_ME, v.Cd_MdRg, v.CamMda, m.Simbolo, v.Cd_Vou, Convert(bit,0) as Sel
		From Voucher v join PlanCtas p on v.NroCta = p.NroCta and v.RucE = p.RucE join Moneda m on v.Cd_MdRg = m.Cd_Mda
		Where v.RucE = '''+@RucE+''' and v.Ejer = '''+@Ejer+''' and p.Nivel = 4 and v.NroCta in ('+@NroCta+') and Prdo in ('+@Prdo+') and v.Cd_Prv = '''+@CodAux+'''
		Group by v.RucE, v.RegCtb, v.NroCta, v.FecMov, v.MtoD, v.MtoH, v.MtoD_ME, v.MtoH_ME, v.Cd_MdRg, v.CamMda, m.Simbolo, v.Cd_Vou
		Order by v.RegCtb')
		END
	END
END
GO
