SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaElim_2]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@UsuModf nvarchar(10),
@msj varchar(100) output
as
--
if not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no existe'
else if(User123.VPrdo(@RucE,(select Eje from venta where ruce=@RucE and Cd_Vta=@Cd_Vta),SubString((select RegCtb from venta where ruce=@RucE and Cd_Vta=@Cd_Vta),8,2)) = 1)
	set @msj = 'Venta no puede ser eliminada, el periodo '+User123.DamePeriodo(SubString((select regctb from venta where ruce=@RucE and Cd_Vta=@Cd_Vta),8,2))+' no se encuentra habilitado'
else
begin
	if(@UsuModf<>'eleon')
	Begin
		if (@UsuModf != (select UsuCrea from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta ))
		begin 	set @msj = 'No tiene permisos para eliminar esta venta'
			return
		end
	End


	if exists (select * from Cobro where RucE = @RucE and Cd_Vta = @Cd_Vta)
	begin	
		set @msj='Venta a sido cobrada'
		return
	end

	if exists (select * from Inventario where  RucE=@RucE and Cd_Vta=@Cd_Vta) --PV
	begin 	set @msj = 'Venta no puede ser eliminada xq esta siendo referenciada por un mov. de inventario'
		return
	end



	--------------------------------------------------------------------------- codigo de prueba para serial
	
	--select * from serial where ruce='11111111111'
	--select * from SerialMov where RucE = @RucE and Cd_Prod=@Cd_Prod and Serial = @Serial and Cd_Inv=@Cd_Inv
	if exists(select top 1 * from serialmov where RucE=@RucE and Cd_Vta=@Cd_Vta)
	begin
	
	begin try
		select serial into #temp from Serialmov where RucE = @RucE and Cd_Vta=@Cd_Vta
		
		delete serialmov where RucE = @RucE and Cd_Vta=@Cd_Vta and 
		Cd_Prod in (select Cd_Prod from serial where RucE=@RucE and Serial 
		in (select * from #temp) 
		group by Cd_Prod) 
		
		update serial set FecSal = null where RucE = @RucE and 
		Serial in(select * from #temp)
		
		drop table #temp
		end try
		begin catch
		drop table #temp
		end catch
		
		--delete serialmov where RucE = @RucE and Cd_Vta=@Cd_Vta and 
		--Cd_Prod in (select Cd_Prod from serial where RucE=@RucE and Serial 
		--in (select Serial from Serialmov where RucE = @RucE and Cd_Vta=@Cd_Vta) 
		--group by Cd_Prod) 
		
		--update serial set FecSal = null where RucE = @RucE and 
		--Serial in(select Serial from Serialmov where RucE = @RucE and Cd_Vta=@Cd_Vta)
		----delete from Serial where RucE = @RucE and 
		--Serial in(select Serial from Serialmov where RucE = @RucE and Cd_Vta=@Cd_Vta)
	end

		--select * from serialmov where RucE = '11111111111' and Cd_Vta='VT00001236' and 
		--Cd_Prod in (select Cd_Prod from serial where RucE='11111111111' and Serial 
		--in (select Serial from Serialmov where RucE = '11111111111' and Cd_Vta='VT00001236') 
		--group by Cd_Prod) 
		
		--select * from Serial where RucE = '11111111111' and 
		--Serial in(select Serial from Serialmov where RucE = '11111111111' and Cd_Vta='VT00001236')
		--and Cd_Prod in (select Cd_Prod from serial where RucE='11111111111' and Serial 
		--in (select Serial from Serialmov where RucE = '11111111111' and Cd_Vta='VT00001236') 
		--group by Cd_Prod)
		 
		--select * from producto2 where Cd_Prod = 'PD00039' and ruce='11111111111'
		
		--select top 1 * from venta where ruce='11111111111' order by Cd_Vta desc
		
	---------------------------------------------------------------------------
	--OBTENIENDO INFORMACION PARA REGISTRAR MOVIMIENTO
	-----------------------------------------------------------------------------------
	declare @Cd_TD nvarchar(2), @NroDoc nvarchar(15), @Cd_Area nvarchar(6),@Cd_MR nvarchar(2), @Cd_Mda nvarchar(2), @Total decimal(13,2)
	declare @RegCtb varchar(15), @Ejer nvarchar(4)

	select @RegCtb=RegCtb, @Ejer=Eje, @Cd_TD=Cd_TD, @NroDoc=NroDoc, @Cd_Area=Cd_Area, @Cd_MR=Cd_MR, @Cd_Mda=Cd_Mda, @Total=Total from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta

	-----------------------------------------------------------------------------------
	--Sacamos Reg Contable y Ejer. para eliminar voucher en contabilidad
	--select @RegCtb=RegCtb, @Ejer=Eje from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta

	-----------------------------------------------------------------------------------
	
	--delete Cobro where RucE=@RucE and Cd_Vta=@Cd_Vta
	--delete CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta
	
	-- Permitir eliminar una Venta que esta referenciada a una Guia de Remision:
	-- CAM:
	declare @Cd_GR char(10)
	select @Cd_GR =Cd_GR from GuiaXVenta where RucE=@RucE and Cd_Vta=@Cd_Vta
	if (@Cd_GR is not null)
	begin	
		delete from GuiaXVenta where RucE = @RucE and Cd_GR = @Cd_GR and Cd_Vta = @Cd_Vta
	end
	-----------------------------------------------------------------------------------
	
	delete  VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta
	delete  Venta where RucE=@RucE and Cd_Vta=@Cd_Vta
	
	if @@rowcount <= 0
	begin
	   set @msj = 'Venta no pudo ser eliminada'
	   return
	end
	else
	begin
		declare @MovVtaCtb bit
		select @MovVtaCtb = IB_MovVtaCtbLin from CfgGeneral where RucE =@RucE
		if (@MovVtaCtb=1)
			if exists (select * from Voucher where  RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)  --Esta validacion siempre debe estar afuera --PV
				exec pvo.Ctb_VoucherElim2 @RucE,@Ejer,@RegCtb,@UsuModf,@msj output
		if @msj is not null
			rollback transaction
	end
	----------------------------------





	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from VentaRM where RucE=@RucE)
	insert into VentaRM(NroReg,RucE,Cd_Vta,Cd_TD,NroDoc,Total,Cd_Mda,FecMov,Cd_Area,Cd_MR,Usu,Cd_Est)
		     Values(@NroReg,@RucE,@Cd_Vta,@Cd_TD,@NroDoc,@Total,@Cd_Mda,getdate(),@Cd_Area,@Cd_MR,@UsuModf,'03')
	-----------------------------------------------------------------------------------
end
print @msj
--DI : Lun 23/01/09
--PV : JUE 04/06/09 : se agrego elim. voucher
--PV: VIE 26/03/2010 Mdf:  que llame a Ctb_VoucherElim2
--PV: JUE 25/11/2010 Mdf: validacion con inventario
--CAM: 30/04/2012 Mdf: Permitir eliminar una venta con una guia relacionada. Se elimina la venta y la relacion(GuiaxVenta), pero la guia permanece.
--CE: 20/08/2012 Mdf: Antes de eliminar verificar si el periodo esta habilitado en el cierre de periodo
GO
