SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherConsUn_X_ND]
@RucE nvarchar(11),
--@Cd_Fte nvarchar(2),
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15),
@msj varchar(100) output
as
if not exists (select * from Voucher where RucE=@RucE and ((Cd_Fte = 'RV' and left(NroCta,2)='12') or (Cd_Fte = 'RC' and left(NroCta,2)='42')) and Cd_TD=@Cd_TD and NroSre = @NroSre and NroDoc = @NroDoc )
	set @msj = 'No existe registro con este nro. de documento'
else	select * from Voucher where RucE=@RucE and ((Cd_Fte = 'RV' and left(NroCta,2)='12') or (Cd_Fte = 'RC' and left(NroCta,2)='42')) and Cd_TD=@Cd_TD and NroSre = @NroSre and NroDoc = @NroDoc
print @msj
--PV: Vie 27/02/09  --> creado
GO
