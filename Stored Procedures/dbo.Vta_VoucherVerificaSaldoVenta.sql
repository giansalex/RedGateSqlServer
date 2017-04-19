SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Vta_VoucherVerificaSaldoVenta]
@RucE nvarchar(22),
@Cd_Aux	nvarchar(14),
@Cd_TD	nvarchar(4),
@NroSre	nvarchar(8),
@NroDoc	nvarchar(30),
@msj varchar(100) output
AS

/*
declare @RucE nvarchar(22)
declare @Cd_Aux	nvarchar(14)
declare @Cd_TD	nvarchar(4)
declare @NroSre	nvarchar(8)
declare @NroDoc	nvarchar(30)
declare @msj varchar(100)


set @RucE = '11111111111'
set @Cd_Aux = 'CLT0000010'
set @Cd_TD = '01'
set @NroSre = '001'
set @NroDoc = '0009168'
*/

if not exists (select * from Voucher 
				where RucE = @RucE and 
				Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc = @NroDoc and Cd_Clt = @Cd_Aux and  
				IB_EsProv = 1 and ISNULL(IB_Anulado,0) = 0)
	set @msj = 'El asiento de esta venta no existe, por favor generarlo antes de realizar esta operación'
else
begin

	select 
	SUM(T.MontoProvision) as MtoProvision, SUM(T.MontoCB) as MtoCB, 
	SUM(T.MontoProvision_D) as MtoProvision_D, SUM(T.MontoCB_D) as MtoCB_D,
	TipDoc, NroSre, NroDoc, Cd_CltPrv,
	(SUM(T.MontoProvision) -  SUM(T.MontoCB)) as Saldo,
	(SUM(T.MontoProvision_D) -  SUM(T.MontoCB_D)) as Saldo_D
	from (
		select 
		SUM(ISNULL(MtoD,0)) as MontoProvision,
		0 as MontoCB,
		SUM(ISNULL(MtoD_ME,0)) as MontoProvision_D,
		0 as MontoCB_D,
		MAX(Cd_TD) as TipDoc, MAX(NroSre) as NroSre, MAX(NroDoc) as NroDoc, 
		MAX(ISNULL(Cd_Clt,ISNULL(Cd_Prv,'-'))) as Cd_CltPrv
		from Voucher where RucE = @RucE and 
		Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc and Cd_Clt=@Cd_Aux
		and IB_EsProv = 1 and ISNULL(IB_Anulado,0) = 0
		group by RegCtb
		
		UNION ALL
		
		select 
		0 as MontoProvision,
		SUM(ISNULL(MtoH,MtoD)) as MontoCB,
		0 as MontoProvision_D,
		SUM(ISNULL(MtoH_ME,MtoD_ME)) as MontoCB_D,
		MAX(ISNULL(Cd_TD,0)) as TipDoc, MAX(ISNULL(NroSre,0)) as NroSre, MAX(ISNULL(NroDoc,0)) as NroDoc, 
		MAX(ISNULL(Cd_Clt,ISNULL(Cd_Prv,'-'))) as Cd_CltPrv
		from Voucher where RucE = @RucE and RegCtb in
		(
			select distinct RegCtb from Voucher 
			where RucE = @RucE and LEFT(NroCta,2) = '10' and ISNULL(IB_Anulado,0) = 0
		) and RucE = @RucE and 
		Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc and Cd_Clt=@Cd_Aux
		and ISNULL(IB_Anulado,0) = 0
		group by RegCtb
	) as T
	where T.TipDoc = @Cd_TD and T.NroSre=@NroSre and T.NroDoc = @NroDoc and T.Cd_CltPrv = @Cd_Aux
	group by TipDoc, NroSre, NroDoc, Cd_CltPrv

--esto se agrega solo para ver los saldados
--having (SUM(T.MontoProvision) -  SUM(T.MontoCB)) between -1 and 1
end

--MP : <31/08/2012> : <Creacion del procedimiento almacenado>
GO
