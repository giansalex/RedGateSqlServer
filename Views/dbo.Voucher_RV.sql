SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Voucher_RV]
as
select * from voucher where Cd_Fte = 'RV' 
GO
