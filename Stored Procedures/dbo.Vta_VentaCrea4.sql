SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaCrea4]
@RucE nvarchar(11),
@FecMov smalldatetime,
@FecCbr smalldatetime,
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@Cd_Sr nvarchar(4),
@FecED smalldatetime,
@FecVD smalldatetime,
@Cd_Cte nvarchar(7),
@Cd_Vdr nvarchar(7),
@Cd_Area nvarchar(6),
@Cd_MR nvarchar(2),
@Obs varchar(1000),
@BIM numeric(13,2), -- SE AGREGO!!! --> SI NO ES IMPORTACION SE AGREGA  CON CERO
@IGV numeric(13,2), -- SE AGREGO!!! --> SI NO ES IMPORTACION SE AGREGA  CON CERO
@Total numeric(13,2), -- SE AGREGO!!! --> SI NO ES IMPORTACION SE AGREGA  CON CERO
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
--@FecReg datetime,
--@FecMdf datetime,
@UsuCrea nvarchar(10),
--@UsuModf nvarchar(10),
@IB_Anulado bit,
@Cd_Vta nvarchar(10) output, 
@RegCtb nvarchar(15),
@Eje nvarchar(4), 
@Prdo nvarchar(2), 
@Cd_FPC nvarchar(2), 
@INF numeric(13,2), -- SE AGREGO!!! --> SI NO ES IMPORTACION SE AGREGA  CON CERO
@EXO numeric(13,2), -- SE AGREGO!!! --> SI NO ES IMPORTACION SE AGREGA  CON CERO
------------------------------
@DR_FecED	smalldatetime,
@DR_CdTD	nvarchar(2),
@DR_NSre	nvarchar(4),
@DR_NDoc	nvarchar(15),
------------------------------
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),

@DsctoFnzP decimal(5,2), -- SE AGREGOOOOOOOOOOOOOOOO!!! 
@DsctoFnzI decimal(13,2), -- SE AGREGOOOOOOOOOOOOOOOO!!!

@msj varchar(100) output
as

--(Soluc 1)  -- Desencadenó un error que no devolviera los saldos a la hora de registrar el voucher (VER XQ)
--SET ANSI_NULLS OFF  -- Para que se pueda igualar a NULL (NroSre = @NroSre)

----------------------------------------------
declare @NroSre nvarchar(5)
set @NroSre = (select NroSerie from Serie where RucE=@RucE and Cd_Sr=@Cd_Sr)
----------------------------------------------

--(Soluc 2)
if @NroSre=null or @NroSre is null 
begin
   set @NroSre = ''
end

--------- Verif 1: ----------
if exists (select * from Venta where RucE=@RucE and NroDoc=@NroDoc and Cd_Sr=@Cd_Sr)
	set @msj = 'Ya existe una venta con la misma serie y numero de documento: ' + @Cd_Sr +' - '+ @NroDoc

--------- Verif 2: ----------
else if exists (select * from Venta where RucE=@RucE and Eje=@Eje and Prdo=@Prdo and RegCtb=@RegCtb)
	set @msj = 'Ya existe una venta con registro contable: ' + @RegCtb

--------- Verif 3: ----------
else if exists (select * from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and isnull(NroSre,'') = @NroSre and NroDoc=@NroDoc and /*Cd_Aux=@Cd_Cte and*/ Cd_Fte='RV') --and @Cd_Fte!='CB' and @Cd_Fte!='LD'
begin	set @msj = 'Ya existe un voucher contable con el mismo tipo, serie y nro. de documento.' -- para dicho cliente.'
	print @msj
--	return
end
--------- Verif 4: ----------
else if exists (select * from Voucher where RucE=@RucE and Ejer=@Eje and Prdo=@Prdo and RegCtb=@RegCtb)
begin
	set @msj = 'Ya existe un voucher con registro contable: ' + @RegCtb
	print @msj
end
/* NO SE PUEDE UTILIZAR ESTE METODO XQ NO TODOS LOS NUMERO DE DOCUMENTO SON NUMERICOS
else 	if exists (select * from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSre and cast(NroDoc as int)= cast(@NroDoc as int) and Cd_Aux=@Cd_Cte and Cd_Fte='RV')-- and @Cd_Fte!='CB' and @Cd_Fte!='LD'
	begin	set @msj = 'Existe un número de documento parecido en modulo contable, verificar.'
		print @msj
--		return
	end
*/
----------------------------------------------
else
begin

	declare @Cd_Num nvarchar(7)
	set @Cd_Num = (select Cd_Num from Numeracion where RucE=@RucE and Cd_Sr=@Cd_Sr and Desde<=convert(int,@NroDoc) and Hasta>=convert(int,@NroDoc))
	PRINT @Cd_Num
	set @Cd_Vta = user123.Cod_Vta(@RucE)
	PRINT @Cd_Vta
	--set @RegCtb = dbo.RegCtb_Vta(@RucE, @Cd_MR, @Eje, @Prdo )
	insert into Venta(RucE, Cd_Vta, Eje, Prdo, RegCtb, FecMov, Cd_FPC, FecCbr,Cd_TD,NroDoc,Cd_Sr,Cd_Num,FecED,FecVD,Cd_Cte,Cd_Vdr,Cd_Area,Cd_MR,Obs,INF,EXO,BIM,IGV,Total,Cd_Mda,CamMda,FecReg,FecMdf,UsuCrea,UsuModf,IB_Anulado, DR_FecED, DR_CdTD, DR_NSre, DR_NDoc, DsctoFnzP, DsctoFnzI, Cd_CC, Cd_SC, Cd_SS)
		   values(@RucE,@Cd_Vta,@Eje, @Prdo, @RegCtb,@FecMov, @Cd_FPC, @FecCbr,@Cd_TD, @NroDoc,@Cd_Sr,@Cd_Num,@FecED,@FecVD,@Cd_Cte,@Cd_Vdr,@Cd_Area,@Cd_MR,@Obs,@INF,@EXO,@BIM,@IGV,@Total,@Cd_Mda,@CamMda,getdate(),getdate(),@UsuCrea,@UsuCrea,0, @DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc, @DsctoFnzP, @DsctoFnzI, @Cd_CC, @Cd_SC, @Cd_SS)



	if @@rowcount <= 0
	begin
	   set @msj = 'Venta '+ @Cd_Sr +' - '+ @NroDoc+' no pudo ser registrada'
	   return
	end
	
	  
	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from VentaRM where RucE=@RucE)
	insert into VentaRM(NroReg,RucE,Cd_Vta,Cd_TD,NroDoc,Total,Cd_Mda,FecMov,Cd_Area,Cd_MR,Usu,Cd_Est)
		     Values(@NroReg,@RucE,@Cd_Vta,@Cd_TD,@NroDoc,0,@Cd_Mda,getdate(),@Cd_Area,@Cd_MR,@UsuCrea,'01')
	-----------------------------------------------------------------------------------


end
--print @Cd_Vta
--print @msj
--PV
--PV
--DG
--PV: Mie 29/11/08
--DI: Lun 19/01/09
--DI: Lun 23/01/09
--PV: Jue 13/02/09  --> Validación RegCtb
--PV: Lun 28/09/09  CreaMdf --> Se agregaron campos de Doc. Ref
-----------------------------------------------------------------
--PV: Vie 29/01/2010  Mdf --> Se agrego validacion de NroDoc con Contabilidad
--PV: Vie 26/03/2010  Mdf --> Se agrego validacion de existencia de RegCtb en Contabilidad

--PV: Lun 19/04/2010  Crd --> Se agregaron Centros de Costo

--DI: Lun 24/05/2010  Mdf --> Se agregaron DsctoFnz Importe y Porcentual

--PV: Mar 17/08/2010  Mdf --> Se comento validacion de cliente en --------- Verif 3 -------
GO
