SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VoucherFC]

AS

Select 
	*
from Voucher WHere Cd_Fte in ('CB','LD') and IB_Anulado<>1 and isnull(IB_EsDes,0)=0


GO
