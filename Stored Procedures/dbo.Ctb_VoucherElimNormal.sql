SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherElimNormal]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
@UsuMdf nvarchar(10),
@msj varchar(100) output
as

if not exists (select * from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
	set @msj = 'Voucher no existe.'
else if(User123.VPrdo(@RucE,@Ejer,SubString(@RegCtb,8,2)) = 1)
	set @msj = 'Voucher no puede ser eliminado, el periodo '+User123.DamePeriodo(SubString(@RegCtb,8,2))+' no se encuentra habilitado.'
else
begin
begin transaction
	
	--INSERTANDO MOVIMIENTO DE REGISTRO--
	Declare row cursor for 
	select Cd_Vou,NroCta,Cd_TD, NroDoc, MtoD, MtoH,Cd_MdRg, Cd_Area, Cd_MR from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
	
		Declare @Cd_Vou int,@Cd_TD nvarchar(2), @NroDoc nvarchar(15)
		Declare @NroCta nvarchar(10)
		Declare @Debe decimal(13,2), @Haber decimal(13,2), @Cd_Mda nvarchar(2)
		Declare @Cd_Area nvarchar(6), @Cd_MR nvarchar(2)
		Set @NroCta=null
		Set @Cd_TD=null Set @NroDoc=null
		Set @Debe=0.00 Set @Haber=0.00 Set @Cd_Mda=null
		Set @Cd_Area=null Set @Cd_MR=null
	
		Declare @NroReg int		
	
	OPEN row
		FETCH NEXT from row INTO @Cd_Vou,@NroCta,@Cd_TD,@NroDoc,@Debe,@Haber,@Cd_Mda,@Cd_Area,@Cd_MR
		WHILE @@FETCH_STATUS = 0
			BEGIN	
				Set @NroReg=(select isnull(Max(NroReg),0)+1 from VoucherRM where RucE=@RucE)
				
				Insert into VoucherRM(RucE,NroReg,RegCtb,Ejer,Cd_Vou,NroCta,Cd_TD,NroDoc,Debe,Haber,Cd_MDa,Cd_Area,Cd_MR,Usu,FecMov,Cd_Est)
				     values(@RucE,@NroReg,@RegCtb,@Ejer,@Cd_Vou,@NroCta,@Cd_TD,@NroDoc,@Debe,@Haber,@Cd_MDa,@Cd_Area,@Cd_MR,@UsuMdf,getdate(),'03')
				
				if @@rowcount <= 0
				begin
					set @msj = 'Hubo problemas en la eliminacion'
					print @msj
					rollback transaction
					return
				end

				FETCH NEXT from row INTO @Cd_Vou,@NroCta,@Cd_TD,@NroDoc,@Debe,@Haber,@Cd_Mda,@Cd_Area,@Cd_MR
			END
	CLOSE row
	DEALLOCATE row
	-----------------------------------------------------------------------------------------------------------------------------------
	delete from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
	if @@rowcount <= 0
	begin
		set @msj = 'Voucher no pudo ser eliminado.'
		rollback transaction
		return
	end

	if @msj is not null
		rollback transaction

commit transaction
end
print @msj
-- LEYENDA
-- CAM 04/01/2012 <Creacion><Se creo porque cuando se modifica una compra y se quiere volver a generar el voucher, se elimina la compra>

GO
