SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Voucher_LD]
as
select * from voucher where Cd_Fte = 'LD' 
GO
