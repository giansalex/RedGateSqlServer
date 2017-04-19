SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_ReporteCotizacionGeneral1]
	@Cd_Mda char(2)
AS
BEGIN
SELECT COUNT(*) AS TotalCustomers, 
CASE WHEN @Cd_Mda = 'MA' THEN 2 ELSE NULL END
		
	 
END
GO
