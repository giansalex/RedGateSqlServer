SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioElim_5]
@RucE nvarchar(11),
@RegCtb nvarchar(15),
@msj varchar(100) output, 
@Ejer nvarchar(4),
@UsuModf nvarchar(10)
as 

-- El Usuario j.garrido de la Empresa MER no debe poder eliminar ni modificar Mov de Inventario segun correo con fecha miércoles 14/09/2011 08:44 a.m. - Melissa Rojas [melissar@mer-peru.com]
if(@UsuModf = 'j.garrido' and @RucE = '20512141022')
	set @msj = 'El usuario no tiene permiso para modificar inventario.'
else
begin
	declare @CadCd_Prod nvarchar(70)
	declare @Cd_Prod char(7)
	declare @Cd_Inv char(12)
	declare @FecMov datetime
	set @CadCd_Prod = ''
	--exec Inv_Serial_Elimina_Por_RegCtb @RucE,@RegCtb,''

	select @FecMov = Min(FecMov) from Inventario where RucE = @RucE and  RegCtb= @RegCtb  and Ejer = @Ejer

	declare Cur_Inv cursor for select Cd_Prod from Inventario where RucE = @RucE and  RegCtb= @RegCtb
	open Cur_Inv
		fetch Cur_Inv into @Cd_Prod
			while(@@fetch_status = 0)
			begin
				set @CadCd_Prod = @CadCd_Prod + @Cd_Prod
				fetch Cur_Inv into @Cd_Prod
			end
	close Cur_Inv
	deallocate Cur_Inv
	set @Cd_Inv = (select Cd_Inv from Inventario where RucE = @RucE and Ejer = @Ejer and  RegCtb= @RegCtb and Cd_Prod=@Cd_Prod)
	--delete serialmov where RucE = @RucE and Cd_Inv=@Cd_Inv and Cd_Prod=@Cd_Prod
	--------------------------------------------------------------------------- codigo de prueba para serial
	declare @Serial varchar(100)
	select @Serial = Serial from Serialmov where RucE = @RucE and Cd_Inv=@Cd_Inv and Cd_Prod=@Cd_Prod
	
	select * from SerialMov where RucE = @RucE and Cd_Prod=@Cd_Prod and Serial = @Serial and Cd_Inv=@Cd_Inv
	if(@@rowcount = 0)
	begin
		delete from Serial where RucE = @RucE and Cd_Prod=@Cd_Prod and Serial = @Serial
		delete serialmov where RucE = @RucE and Cd_Inv=@Cd_Inv and Cd_Prod=@Cd_Prod -------------------------------------------------
	end
	---------------------------------------------------------------------------
	delete Inventario where RucE = @RucE and Ejer = @Ejer and  RegCtb= @RegCtb 
	print @CadCd_Prod
	exec dbo.Inv_Recalcular @RucE, @CadCd_Prod, @FecMov, null, @msj output
	declare @MovInvCtb bit
	select @MovInvCtb =  IB_MovInvCtbLin from CfgGeneral where RucE =@RucE
	if (@MovInvCtb=1)
		if exists (select * from Voucher where  RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)  --Esta validacion siempre debe estar afuera --PV
			exec pvo.Ctb_VoucherElim2 @RucE,@Ejer,@RegCtb,@UsuModf,@msj output
	if @msj is not null
		rollback transaction
		
end
-- Leyenda --
-- PP : 2010-08-20 19:38:17.483	: <Creacion del procedimiento almacenado>
-- CAM: 23/11/2010 Agregue Ejercicio
-- CAM 15/03/2011 <Nueva version del SP><Miguel me dijo que agregue el Exec Inv_Serial_Elimina_Por_RegCtb>
-- CAM 16/03/2011 <Modf><Comente la linea anterior>
-- CAM 14/09/2011 <Modf><Se agrego el condicional del usuario de MER>
/*
select * from Serial where RucE= '11111111111' and Cd_Prod = 'PD00149'
select * from SerialMov where RucE = '11111111111' /*and Cd_Inv='INV000001696'*/ and Cd_Prod='PD00149'



select * from Serial where RucE = '11111111111' and Cd_Prod = 'PD00042' and Serial = 'a'
select * from SerialMov where RucE = '11111111111' and Cd_Inv='INV000001458' and Cd_Prod='PD00042'

delete from Serial where RucE = '11111111111' and Cd_Prod = 'PD00003' and Serial in ('2','a','A-200')
delete from SerialMov where RucE = '11111111111' and Cd_Inv='INV000001503' and Cd_Prod='PD00003'

select * from Inventario where RucE = '11111111111' and Cd_Inv = 'INV000001458'

*/
GO
