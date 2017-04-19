SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherMdf5]
@RucE nvarchar(11),
@Cd_Vou int,
@Ejer nvarchar(4),
@Prdo nvarchar(2),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Cd_MdRg nvarchar(2),
@CamMda decimal(6,3),
@FecMov smalldatetime,
@RegCtb nvarchar(15),
@Cd_Fte nvarchar(2),
@Cd_Aux nvarchar(7),
@NroCta nvarchar(10),
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15),
@IC_TipAfec nvarchar(1),
@Glosa nvarchar(100),
@NroChke varchar(30),
@Cd_TG nvarchar(2),
@MtoD decimal(13,2),
@MtoH decimal(13,2),
@MtoD_ME decimal(13,2),
@MtoH_ME decimal(13,2),
@Cd_Area nvarchar(6),
@UsuModf nvarchar(10),
@FecED smalldatetime,
@FecVD smalldatetime,
@IB_EsProv bit,
--@DR_NroDet varchar(15),
--@DR_FecDet smalldatetime,
@msj varchar(100)output

as
if not exists (select * from Voucher where RucE=@RucE and Cd_Vou=@Cd_Vou)
	set @msj = 'Voucher no existe'
else
begin
	Declare @V nvarchar(15)
	Set @V = (select RegCtb from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	print @V

	Declare @V2 nvarchar(2)
	Set @V2 = (select Prdo from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	print @V2

	--Declare @V3 nvarchar(2)
	--Set @V3 = (select Cd_MdRg from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V3
	
	Declare @V4 nvarchar(2)	
	Set @V4 = (select Cd_Fte from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	print @V4

	--Declare @V5 nvarchar(4)
	--Set @V5 = (select NroSre from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V5
	
	--Declare @V6 nvarchar(15)
	--Set @V6 = (select NroDoc from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V6

	--Declare @V7 nvarchar(1)
	--Set @V7 = (select IC_TipAfec from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V7

	--Declare @V8 nvarchar(8)
	--Set @V8 = (select Cd_CC from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V8

	--Declare @V9 nvarchar(8)
	--Set @V9 = (select Cd_SC from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V9

	--Declare @V10 nvarchar(8)
	--Set @V10 = (select Cd_SS from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V10

	--Declare @V11 decimal(6,3)
	--Set @V11 = (select CamMda from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V11

	--Declare @V12 smalldatetime
	--Set @V12 = (select FecMov from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V12

	--Declare @V13 nvarchar(7)
	--Set @V13 = (select Cd_Aux from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V13

	--Declare @V14 nvarchar(2)
	--Set @V14 = (select Cd_TD from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V14

	--Declare @V15 nvarchar(100)
	--Set @V15 = (select Glosa from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V15

	--Declare @V16 varchar(30)
	--Set @V16 = (select NroChke from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V16

	--Declare @V17 nvarchar(2)
	--Set @V17 = (select Cd_TG from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V17

	--Declare @V18 nvarchar(6)
	--Set @V18 = (select Cd_Area from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V18

	--Declare @V19 smalldatetime
	--Set @V19 = (select FecED from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V19

	--Declare @V20 smalldatetime
	--Set @V20 = (select FecVD from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V20

	--Declare @V21 bit
	--Set @V21 = (select IB_EsProv from Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
	--print @V21

	if(@V<>@RegCtb and @V2<>@Prdo and @V4<>@Cd_Fte)-- and @V3<>@Cd_MdRg and @V8<>@Cd_CC and @V9<>@Cd_SC and 
	   --@V10<>@Cd_SS and @V5<>@NroSre and @V6<>@NroDoc and @V7<>@IC_TipAfec and @V12<>@CamMda and 
	   --@V13<>@Cd_Aux and @V14<>@Cd_TD and @V15<>@Glosa and @V16<>@NroChke and @V17<>@Cd_TG and 
	   --@V18<>@Cd_Area and @V19<>@FecED and @V20<>@FecVD and @V21<>@IB_EsProv)

	-- Si RegCtb actual (@valor) es diferente al RegCtb mandado (@RegCtb) -->> se quiere modificar RegCtb 
	
	begin
		if exists (select RegCtb,Prdo--,Cd_Fte,Cd_MdRg,NroSre,NroDoc,IC_TipAfec,
				  --Cd_CC,Cd_SC,Cd_SS,CamMda,FecMov,Cd_Aux,Cd_TD,Glosa,
				  --NroChke,Cd_TG,Cd_Area
	
			   from Voucher 
			
			   where RucE=@RucE and Ejer=@Ejer and Cd_Vou<>1 and RegCtb=@RegCtb and Prdo=@Prdo and
                        	 Cd_Fte=@Cd_Fte)--and Cd_MdRg=@Cd_MdRg and NroSre=@NroSre and NroDoc=@NroDoc and
				 --IC_TipAfec=@IC_TipAfec and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS and 
				 --CamMda=@CamMda and FecMov=@FecMov and Cd_Aux=@Cd_Aux and Cd_TD=@Cd_TD and 
				 --Glosa=@Glosa and NroChke=@NroChke and Cd_TG=@Cd_TG and Cd_Area=@Cd_Area)
		begin
			set @msj = 'Registro Contable ya existe'
			return
		end
	end	

	update Voucher 

	set 
		RegCtb=@RegCtb,Prdo=@Prdo,Cd_Fte=@Cd_Fte--,Cd_MdRg=@Cd_MdRg,NroSre=@NroSre,NroDoc=@NroDoc,
		--IC_TipAfec=@IC_TipAfec,Cd_CC=@Cd_CC,Cd_SC=@Cd_SC,Cd_SS=@Cd_SS,CamMda=@CamMda,FecMov=@FecMov,
		--Cd_Aux=@Cd_Aux,Cd_TD=@Cd_TD,Glosa=@Glosa,NroChke=@NroChke,Cd_TG=@Cd_TG,Cd_Area=@Cd_Area

	where 
		RucE=@RucE and Ejer=@Ejer and RegCtb=@V and Prdo=@V2 and Cd_Fte=@V4 --and Cd_MdRg=@V3 and 
		--NroSre=@V5 and NroDoc=@V6 and IC_TipAfec=@V7 and Cd_CC=@V8 and Cd_SC=@V9 and Cd_SS=@V10 and 
		--CamMda=@V11 and FecMov=@V12 and Cd_Aux=@V13 and Cd_TD=@V14 and Glosa=@V15 and NroChke=@V16 and 
		--Cd_TG=@V17 and Cd_Area=@V18

	if @@rowcount <= 0
	   set @msj = 'Registro Contable no pudo ser modificado'

	update Voucher set 
		Ejer = @Ejer,
		Prdo = @Prdo,
		Cd_CC = @Cd_CC,
		Cd_SC = @Cd_SC,
		Cd_SS = @Cd_SS,
		Cd_MdRg = @Cd_MdRg,
		CamMda = @CamMda,
		FecMov = @FecMov,
		--RegCtb = @RegCtb,
		Cd_Fte = @Cd_Fte,
		Cd_Aux = @Cd_Aux,
		NroCta = @NroCta,
		Cd_TD = @Cd_TD,
		NroSre = @NroSre,
		NroDoc = @NroDoc,
		IC_TipAfec = @IC_TipAfec,
		Glosa = @Glosa,
		NroChke = @NroChke,
		Cd_TG = @Cd_TG,
		MtoD = @MtoD,
		MtoH = @MtoH,
		MtoD_ME=@MtoD_ME,
		MtoH_ME=@MtoH_ME,
		Cd_Area = @Cd_Area,
		UsuModf = @UsuModf,
		FecED = @FecED,
		FecVD = @FecVD,
		IB_EsProv=@IB_EsProv--,
		--DR_NroDet=@DR_NroDet,
		--DR_FecDet=@DR_FecDet
	where RucE=@RucE and Cd_Vou = @Cd_Vou
	if @@rowcount <= 0
	   set @msj = 'Voucher no pudo ser modificado'
	else
	begin
		declare @Cd_MR varchar(2)
		set @Cd_MR = 'XX'  -->  No se ha definido (SE DEBERIA TRAER)		
		   insert into VoucherRM (RucE, NroReg, RegCtb, Ejer, Cd_Vou, NroCta, Cd_TD, NroDoc, Debe, Haber, Cd_Mda, Cd_Area, Cd_MR, Usu, FecMov, Cd_Est)
		   			 values (@RucE, dbo.Nro_RegVouRM(@RucE), @RegCtb, @Ejer, @Cd_Vou, @NroCta, @Cd_TD, @NroDoc, @MtoD, @MtoH, @Cd_MdRg, @Cd_Area, @Cd_MR, @UsuModf, getdate(), '02')
		 --insert into VoucherRM values (@RucE, dbo.Nro_RegVouRM(@RucE), @Cd_Vou, @Cd_TD, @NroDoc, @MtoD, @MtoH, @Cd_MdRg, @Cd_Area, @Cd_MR, @UsuCrea, getdate(), '02')
	end


end
print @msj
-- DIE  16/04/2009 Modificacion para alterar todo los registros contables similares que se localizan dentro de la tabla
-- DIE  08/05/2009 Se agrego los campos FecED y FecVD
-- PV: 23/07/2009 Mdf: faltaba considerar año (@Ejer) para modificar
-- J	03/07/2009 Se agrego el campo IB_Provision
-- J:   04/08/2009 Se modificaron la parte de registros
-- PV: 19/03/2010 Mdf: se agrego registro en VoucherRM
GO
