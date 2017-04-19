SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[TipCamCalc](@RucE nvarchar(11), @Ejer nvarchar(4), @Cd_Clt char(10), @Cd_Prv char(7), @Cd_TD nvarchar(2), @NroSre nvarchar(4), @NroDoc nvarchar(15))
returns numeric(6,3) AS
begin 
/*    declare @n int
      select @n = count(NroReg) from VoucherRM where RucE=@RucE
      set @n = @n+1
      return @n
*/
     -- return (select isnull(Max(NroReg),0)+1 from voucherRM where RucE=@RucE)

--------------------------------------------------------------------------------------

	if @NroSre=null or @NroSre is null
	begin
	   set @NroSre = ''
	end

	
	declare @SaldoME numeric(13,2), @TipCam numeric(6,3)
	set @TipCam = 0.00



	if @NroDoc!=null or @NroDoc is Not null --PROCEDIMIENTO 1: solo se tendran en cuenta en la suma las ctas que manejen auxiliar (xq por equivocacion se le puede aver ingresado TipDoc, NroSre y NroDoc a las otras cuentas lo que puede ocacionar que se calcule mal el Tipo de Cambio)
	begin
		--select sum(MtoD_ME-MtoH_ME)  from voucher v, PlanCtas p  where v.ruce='20503060621' and v.RucE=p.RucE and Ejer='2009' and v.NroCta=p.NroCta and Cd_Aux='AUX0002' and Cd_TD='01' and NroSre ='001' and NroDoc='9286' and p.IB_Aux=1
		set @SaldoME = (select sum(MtoD_ME-MtoH_ME)  from voucher v, PlanCtas p where v.ruce=@RucE and v.RucE=p.RucE and /*Ejer=@Ejer and*/ v.NroCta=p.NroCta and (v.Cd_Clt=@Cd_Clt or v.Cd_Prv=@Cd_Prv)  /*Cd_Aux=@Cd_Aux*/ and Cd_TD=@Cd_TD and isnull(NroSre,'') =@NroSre and NroDoc=@NroDoc and p.IB_Aux=1 and p.Ejer=@Ejer)
		if(@SaldoME != 0.00)
			set @TipCam = (select sum(MtoD-MtoH)/ @SaldoME from voucher v, PlanCtas p where v.ruce=@RucE and v.RucE=p.RucE and /*Ejer=@Ejer and*/ v.NroCta=p.NroCta and (v.Cd_Clt=@Cd_Clt or v.Cd_Prv=@Cd_Prv)  /*Cd_Aux=@Cd_Aux*/ and Cd_TD=@Cd_TD and isnull(NroSre,'') =@NroSre and NroDoc=@NroDoc and p.IB_Aux=1 and p.Ejer=@Ejer)

	end

	else -- PROCEDIMIENTO 2: SON PARA CUENTAS QUE NO MANEJARAN NRO DE DOCUMENTO, ASI QUE NO IMPORTA QUE SUME TODO
	begin
		set @SaldoME = (select sum(MtoD_ME-MtoH_ME)  from voucher where ruce=@RucE and /*Ejer=@Ejer and*/ (Cd_Clt=@Cd_Clt or Cd_Prv=@Cd_Prv)  /*Cd_Aux=@Cd_Aux*/ and Cd_TD=@Cd_TD and isnull(NroSre,'') =@NroSre and NroDoc=@NroDoc)
		if(@SaldoME != 0.00)
			set @TipCam = (select sum(MtoD-MtoH)/ @SaldoME from voucher where ruce=@RucE and /*Ejer=@Ejer and*/ (Cd_Clt=@Cd_Clt or Cd_Prv=@Cd_Prv)  /*Cd_Aux=@Cd_Aux*/ and Cd_TD=@Cd_TD and isnull(NroSre,'') =@NroSre and NroDoc=@NroDoc)
	end
	

	return @TipCam		
	--Otra forma:
	--return (select sum(MtoD-MtoH)/ case(sum(MtoD_ME-MtoH_ME)) when 0 then 1 else  sum(MtoD_ME-MtoH_ME) end  from voucher where ruce=@RucE and Ejer=@Ejer and Cd_Aux=@Cd_Aux and Cd_TD=@Cd_TD and Nrosre=@NroSre and NroDoc=@NroDoc)


	/*
	Pruebas:
	print dbo.TipCamCalc('11111111111','2009','CLT0006','01','001','2527')
	print dbo.TipCamCalc('11111111111','2009','CLT0001','01','001','5050')

	print dbo.TipCamCalc('11111111111', '2010', null, 'PRV0222', '01', '005', '888')
	print dbo.TipCamCalc('11111111111', '2010', 'CLT0000009', null, '01', '005', '888')
	*/		
end







--PV: MAR 05/01/2010 Mdf: --> Para que NO tome en cuenta el Ejer al jalar las facturas
--PV & MP: 16/09/2010 Mdf: --> Quitamos las referencias a Auxiliar y lo enlazamos con Cliente y Proveedor
--PV: JUE 02/12/2010 Mdf: --> se agrego Cd_Clt, Cd_Prv y ...and p.IB_Aux=1 and p.Ejer=@Ejer





GO
