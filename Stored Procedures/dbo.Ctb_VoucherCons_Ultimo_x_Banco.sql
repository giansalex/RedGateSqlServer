SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherCons_Ultimo_x_Banco]
@RucE nvarchar(11),
@Ejer varchar(4),
@NroCtaBanco varchar(13),
@msj varchar(100) output
as

if not exists
( 
select top 1 Cd_Vou,Cd_TD,NroSre,NroDoc,RegCtb  
from Voucher 
where RucE = @RucE
and Ejer = @Ejer and 
TipOper = 'CHEQ' and 
ISNULL(NroChke,'')<>'' and 
ISNULL(IB_Anulado,0)<>1 and 
NroCta = @NroCtaBanco
order by FecReg desc
)
set @msj = 'No existen cheques en este banco'
else
begin
select top 1 Cd_Vou,Cd_TD,NroSre,NroDoc,RegCtb  
from Voucher 
where RucE = @RucE
and Ejer = @Ejer and 
TipOper = 'CHEQ' and 
ISNULL(NroChke,'')<>'' and 
ISNULL(IB_Anulado,0)<>1 and 
NroCta = @NroCtaBanco
order by FecReg desc
end
GO
