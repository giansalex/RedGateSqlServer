SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Vta_DesAnula_Upd '11111111111','2011','VTGE_RV03-00015',null

create procedure [dbo].[Vta_DesAnula_Upd2]
@RucE nvarchar(11),
@Ejer varchar(4),
@RegCtb nvarchar(15),
@UsuModf nvarchar(10),
@msj varchar(100) output
as



--haciendo update a ventas
update Venta set IB_Anulado=0, MtvoBaja = null where RucE=@RucE and Eje=@Ejer and RegCtb=@RegCtb

--haciendo update a su voucher contable directo
update Voucher set IB_Anulado=0 where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
--haciendo update a sus vouchers indirectos(cancelaciones,etc)
--if @@ROWCOUNT <=0
--	set @msj='Venta con registro contable '+@RegCtb+' no pudo ser desanulada'




	--OBTENIENDO INFORMACION PARA REGISTRAR MOVIMIENTO
	-----------------------------------------------------------------------------------
	declare @Cd_Vta nvarchar(10)
	set @Cd_Vta = (select Cd_Vta from Venta where RucE=@RucE and Eje=@Ejer and RegCtb=@RegCtb)

	declare @Cd_TD nvarchar(2), @NroDoc nvarchar(15), @Cd_Area nvarchar(6),@Cd_MR nvarchar(2), @Cd_Mda nvarchar(2), @Total decimal(13,2)
	set @Cd_TD = (select Cd_TD from Venta where RucE=@RucE and Eje=@Ejer and Cd_Vta=@Cd_Vta)
	set @NroDoc = (select NroDoc from Venta where RucE=@RucE and Eje=@Ejer and Cd_Vta=@Cd_Vta)
	set @Cd_Area = (select Cd_Area from Venta where RucE=@RucE and Eje=@Ejer and Cd_Vta=@Cd_Vta)
	set @Cd_MR = (select Cd_MR from Venta where RucE=@RucE and Eje=@Ejer and Cd_Vta=@Cd_Vta)
	set @Cd_Mda = (select Cd_Mda from Venta where RucE=@RucE and Eje=@Ejer and Cd_Vta=@Cd_Vta)
	set @Total = (select Total from Venta where RucE=@RucE and Eje=@Ejer and Cd_Vta=@Cd_Vta)
	-----------------------------------------------------------------------------------	


	--INSERTANDO REGISTRO DE MOVIMIENTO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from VentaRM where RucE=@RucE)
	insert into VentaRM(NroReg,RucE,Cd_Vta,Cd_TD,NroDoc,Total,Cd_Mda,FecMov,Cd_Area,Cd_MR,Usu,Cd_Est)
				Values(@NroReg,@RucE,@Cd_Vta,@Cd_TD,@NroDoc,@Total,@Cd_Mda,getdate(),@Cd_Area,@Cd_MR,@UsuModf,'10')
	-----------------------------------------------------------------------------------


--PV: 2017-04-18: se agregó para que se limpie el MtvoBaja
--PV: 2017-04-18: se agregó Registro de Movimiento 
GO
