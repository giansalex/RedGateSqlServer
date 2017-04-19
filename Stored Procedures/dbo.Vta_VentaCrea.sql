SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaCrea]
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
--@BIM numeric(13,2),
--@IGV numeric(13,2),
--@Total numeric(13,2),
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
--@INF numeric(13,2),
--@EXO numeric(13,2),
@msj varchar(100) output
as

set @msj = 'Para crear venta, debe actualizar el sistema'
/*

if exists (select * from Venta where RucE=@RucE and NroDoc=@NroDoc and Cd_Sr=@Cd_Sr)
	set @msj = 'Ya existe una venta con la misma serie y numero de documento: ' + @Cd_Sr +' - '+ @NroDoc

else if exists (select * from Venta where RucE=@RucE and Eje=@Eje and Prdo=@Prdo and RegCtb=@RegCtb)
	set @msj = 'Ya existe una venta con registro contable: ' + @RegCtb
else
begin
	declare @Cd_Num nvarchar(7)
	set @Cd_Num = (select Cd_Num from Numeracion where RucE=@RucE and Cd_Sr=@Cd_Sr and Desde<=convert(int,@NroDoc) and Hasta>=convert(int,@NroDoc))
	set @Cd_Vta = user123.Cod_Vta(@RucE)
	--set @RegCtb = dbo.RegCtb_Vta(@RucE, @Cd_MR, @Eje, @Prdo )
	insert into Venta(RucE, Cd_Vta, Eje, Prdo, RegCtb, FecMov, Cd_FPC, FecCbr,Cd_TD,NroDoc,Cd_Sr,Cd_Num,FecED,FecVD,Cd_Cte,Cd_Vdr,Cd_Area,Cd_MR,Obs/ *,BIM,INF,EXO,IGV,Total* /,Cd_Mda,CamMda,FecReg,FecMdf,UsuCrea,UsuModf,IB_Anulado)
		   values(@RucE,@Cd_Vta,@Eje, @Prdo, @RegCtb,@FecMov, @Cd_FPC, @FecCbr,@Cd_TD, @NroDoc,@Cd_Sr,@Cd_Num,@FecED,@FecVD,@Cd_Cte,@Cd_Vdr,@Cd_Area,@Cd_MR,@Obs/ *,@BIM,@INF,@EXO,@IGV,@Total* /,@Cd_Mda,@CamMda,getdate(),getdate(),@UsuCrea,@UsuCrea,0)

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
*/
--print @Cd_Vta
--print @msj
--PV
--PV
--DG
--PV : Mie 29/11/08
--DI : Lun 19/01/09
--DI : Lun 23/01/09
--PV: Jue 13/02/09  --> Validación RegCtb
GO
