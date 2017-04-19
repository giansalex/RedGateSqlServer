SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VtaDetalleCrea2] -- CAMBIAR NOMBRE PARA PROXIMA ACTUALIZACION  (No se ah usado este SP hasta el momento)
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@Cd_Pro nvarchar(10),
@Cant numeric(13,2),
@Cd_UM nvarchar(2),
@Valor numeric(13,2),
@DsctoP numeric(5,2),
@DsctoI numeric(13,2),
@IMP numeric(13,2),
@IGV numeric(13,2),
@Total numeric(13,2),
--@FecReg datetime,
--@FecMdf datetime,
@UsuCrea nvarchar(10),
--@UsuModf nvarchar(10),
@Ad_INF_Vta numeric(13,2) output,
@Ad_BIM_Vta numeric(13,2) output,
@Ad_IGV_Vta numeric(13,2) output,
@Ad_Total_Vta numeric(13,2) output,
@IB_Term bit,	---> NUNCA SE USO
@msj varchar(100) output
as

begin transaction


declare @NroDoc nvarchar(15)--, @Cd_Sr nvarchar(4)

select @NroDoc=NroDoc from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta


  if not exists (select Cd_Pro from Producto where Cd_Pro = @Cd_Pro)
  begin	set @msj = 'Codigo de producto ' +@Cd_Pro+ ' no existe en catalogo, en documento ' + @NroDoc
 	rollback transaction
	return
  end



   insert into VentaDet(RucE,Cd_Vta, Nro_RegVdt,Cd_Pro,Cant,Cd_UM,Valor,DsctoP,DsctoI,IMP,IGV,Total,FecReg,FecMdf,UsuCrea,UsuModf)
                    values(@RucE,@Cd_Vta,dbo.Nro_RegVdt(@RucE,@Cd_Vta),@Cd_Pro,@Cant,@Cd_UM,@Valor,@DsctoP,@DsctoI,@IMP,@IGV,@Total,getdate(),getdate(),@UsuCrea,@UsuCrea)
   if @@rowcount <= 0
   begin
	set @msj = 'Producto no pudo ser registrado'
 	rollback transaction
	return
   end

---
   declare @IB_IncIGV bit, @IB_Exrdo bit, @BIM numeric(13,2), @INF numeric(13,2), @EXO numeric(13,2)
   select @IB_IncIGV=IB_IncIGV, @IB_Exrdo=IB_Exrdo  from Producto where Cd_Pro=@Cd_Pro

   if(@IB_IncIGV=1)
   begin
     set @BIM=@IMP set @INF=0.00 set @EXO=0.00
   end
   else if (@IB_Exrdo=1)
	   begin  set @INF=0.00  set @EXO=@IMP set @BIM=0.00  end
        else begin  set @INF=@IMP  set @EXO=0.00  set @BIM=0.00  end

   --update Venta set BIM=BIM+@BIM, IGV=IGV+@IGV, Total=Total+@Total where RucE = @RucE and Cd_Vta=@Cd_Vta
   update Venta set INF=INF+@INF, EXO=EXO+@EXO, BIM=BIM+@BIM, IGV=IGV+@IGV, Total=Total+@Total where RucE = @RucE and Cd_Vta=@Cd_Vta
---
   
   if @@rowcount <= 0
   begin 
	set @msj = 'Venta no pudo ser actualizada'
 	rollback transaction
	return
   end
   else 
   begin
	set @Ad_INF_Vta = 0.00
	set @Ad_BIM_Vta = 0.00
	set @Ad_IGV_Vta = 0.00
	set @Ad_Total_Vta = 0.00
	select @Ad_INF_Vta= INF+EXO, @Ad_BIM_Vta= BIM, @Ad_IGV_Vta = IGV,  @Ad_Total_Vta = Total from  Venta  where RucE = @RucE and Cd_Vta=@Cd_Vta
   end


   --//ACTUALIZANDO INFORMACION VENTA-RM
   -----------------------------------------------------------------------------------------------------------------------
   declare @NroReg int
   set @NroReg = (select max(NroReg) from VentaRM where  RucE = @RucE and Cd_Vta=@Cd_Vta)
   update VentaRM set Total=Total+@Total where NroReg=@NroReg
   -----------------------------------------------------------------------------------------------------------------------
  
/*
   if (@IB_Term = 1)
   begin
		
	--print dbo.RegCtb_Ctb(@RucE, @Cd_MR, @Cd_Fte, @Cd_Area, @Eje, @Prdo)
	--print dbo.RegCtb_Ctb('11111111111', '01', 'RV', '010101', '2008', '01')
	
		declare @Eje nvarchar(4),  @Prdo nvarchar(2), @RegCtb = nvarchar(15), @FecMov smalldatetime, @FecCbr smalldatetime, @CtaCtb nvarchar(12),
			@CtaAsoc nvarchar(12), @Cd_Aux nvarchar(9), @Cd_TD nvarchar(2), @Cd_Sr nvarchar(4), @NroDoc nvarchar(15),
			@FecED smalldatetime, @FecVD smalldatetime, @Glosa varchar(200), @Mto numeric(13,2),  @Cd_MdRg nvarchar(2), @CamMda numeric(6,3), 
			@Cd_CC nvarchar(8), @Cd_SC nvarchar(8), @Cd_SS nvarchar(8), @Cd_Area nvarchar(6), @Cd_MR nvarchar(2), @NroChke varchar(30),
			@Cd_TG nvarchar(2), @IC_CtrMd varchar(1), 

		declare @Cd_Pro nvarchar(7)

--			@MtoOr, @MtoD, @MtoH, @Cd_MdOr, @UsuCrea, null, null, 'A',  @msj output

		select @Cd_Pro=Cd_Pro from VentaDet where RucE=@RucE and Cd_Vta = @Cd_Vta
		select @Cd_CC=Cd_CC, @Cd_SC=Cd_SC, @Cd_SS=Cd_SS from ventaDet RucE=@RucE and Cd_Pro = @Cd_Pro

		set @Cd_TG='01', 
		set @IC_CtrMd='a', 
		set @Glosa='Por la Venta', 
		set @NroChke=null,

		select @CtaCtb=CtaCtb from PlanCtasDef where RucE=@RucE

		select @Eje=Eje, @Prdo=Prdo, @RegCtb=RegCtb, @FecMov=FecMov, @FecCbr=FecCbr, @Cd_Aux=Cd_Cte, @Cd_TD=Cd_TD, @Cd_Sr=Cd_Sr, @NroDoc=NroDoc,
		@FecED=FecED, @FecVD=FecVD, @Mto=Total,  @Cd_MdRg=Cd_Mda, @CamMda=CamMda, @Cd_Area=Cd_Area, @Cd_MR=Cd_MR, from Venta where RucE=@RucE and Cd_Vta = @Cd_Vta

		select @CtaAsoc=Cta from Cliente where RucE=@RucE and Cd_Aux=@Cd_Aux


	--							      @Cd_Fte
		exec pvo.Ctb_VoucherCrea @RucE, @Ejer, @Prdo, @RegCtb, 'RV', @FecMov, @FecCbr, @CtaCtb, @CtaAsoc, @Cd_Aux, 
					 @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, 
					 @Cd_SS, @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, null, null, 'A',  @msj output
	
		exec pvo.Ctb_VoucherCrea '11111111111', '2009', '02', 'VTMM_RV02-00001', 'RV', '15/02/2009' ,NULL, '12.1.1.10', '70.1.1.10', 'CLT0001',
					 '01', '001', '000088', NULL, NULL, 'glosa', 119.00, 119.00, 0.00, '01', '01', 3.140, '01010101', '01010101', 
					 '01010101', '010101', '01', NULL, '01', 'a', 'admin', NULL, NULL, 'A', NULL

select * from voucher
delete voucher

	
   end
*/

commit transaction
--PV

--PV: Lun 05-01-09
GO
