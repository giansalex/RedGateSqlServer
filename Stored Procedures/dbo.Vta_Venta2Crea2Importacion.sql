SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Venta2Crea2Importacion]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10) output, 
@Eje nvarchar(4), 
@Prdo nvarchar(2),
@RegCtb nvarchar(15),
@FecMov smalldatetime,
@Cd_FPC nvarchar(2),
@FecCbr smalldatetime,
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@FecED smalldatetime,
@FecVD smalldatetime,
@Cd_Area nvarchar(6),
@Cd_MR nvarchar(2),
@Obs varchar(1000),
@Valor numeric(13,2),
@TotDsctoP numeric(5,2),
@TotDsctoI numeric(13,2), 
@ValorNeto numeric(13,2),
@BaseSinDsctoF numeric(13,2),
@DsctoFnz_P numeric(5,2),
@DsctoFnz_I numeric(13,2),
@Cd_IAV_DF char(1),
@INF_Neto numeric(13,2),
@EXO_Neto numeric(13,2), 
@EXPO_Neto numeric(13,2),
@BIM_Neto numeric(13,2),
@IGV numeric(13,2), 
@Total numeric(13,2), 
@Percep numeric(13,2),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
@UsuCrea nvarchar(10),
@CA01 varchar(100), 
@CA02 varchar(100), 
@CA03 varchar(100), 
@CA04 varchar(100),
@CA05 varchar(100),
@CA06 varchar(100),
@CA07 varchar(100),
@CA08 varchar(100),
@CA09 varchar(100),
@CA10 varchar(100),
@CA11 varchar(100),
@CA12 varchar(100),
@CA13 varchar(100),
@CA14 varchar(100),
@CA15 varchar(100),
@CA16 varchar(100),
@CA17 varchar(100),
@CA18 varchar(100),
@CA19 varchar(100),
@CA20 varchar(100),
@CA21 varchar(100),
@CA22 varchar(100),
@CA23 varchar(100),
@CA24 varchar(100),
@CA25 varchar(100),
@Cd_OP char(10),
@NroOP char(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@NroSre varchar(5),
@Cd_MIS char(3),
@IB_Cbdo bit,
--Documento de Referencia
------------------------------
@DR_CdVta nvarchar(10),
@DR_FecED smalldatetime,
@DR_CdTD  nvarchar(2),
@DR_NSre  nvarchar(4),
@DR_NDoc  nvarchar(15),
@MovVtaCtb bit = null output,
------------------------------
@msj varchar(100) output,
@Cd_TDICLI varchar(2),
@NDocCLI varchar(15),
@Cd_TDIVDR varchar(2),
@NDocVDR varchar(15)
as

select @MovVtaCtb = IB_MovVtaCtbLin from CfgGeneral where RucE = @RucE
if @MovVtaCtb is null 
	set @MovVtaCtb =  0
	

--------- Verif 1: ----------
if exists (select * from Venta where RucE=@RucE and Cd_TD=@Cd_TD and NroDoc=@NroDoc and NroSre=@NroSre)
	set @msj = 'Ya existe una venta con el mismo Tipo de documento, serie y numero de documento: ' + @Cd_TD+' -  '+ @NroSre +' - '+ @NroDoc

--------- Verif 2: ----------
else if exists (select * from Venta where RucE=@RucE and Eje=@Eje and Prdo=@Prdo and RegCtb=@RegCtb)
	set @msj = 'Ya existe una venta con registro contable: ' + @RegCtb

--------- Verif 2.1: ----------
else if exists (select * from Venta where RucE=@RucE and Eje=@Eje and RegCtb=@RegCtb)
	set @msj = 'Ya existe una venta con registro contable: ' + @RegCtb

--------- Verif 3: ----------
else if exists (select * from Voucher where RucE=@RucE and Ejer=@Eje and Prdo=@Prdo and RegCtb=@RegCtb)
begin
	set @msj = 'Ya existe un voucher con registro contable: ' + @RegCtb
	print @msj
end
else
begin

--@Cd_TDIVDR varchar(2),
--@NDocVDR varchar(15)

declare @Cd_Clt char(10)
declare @Cd_Vdr nvarchar(7)
set @Cd_Clt=(select Cd_Clt from Cliente2 where RucE=@RucE and Cd_TDI=@Cd_TDICLI and NDoc=@NDocCLI)
set @Cd_Vdr=(select Cd_Vdr from Vendedor2 where RucE=@RucE and Cd_TDI=@Cd_TDIVDR and NDoc=@NDocVDR)

	set @Cd_Vta = user123.Cod_Vta(@RucE)
	insert into Venta(RucE,Cd_Vta,Eje,Prdo,RegCtb,FecMov,Cd_FPC,FecCbr,Cd_TD,NroDoc,
			  FecED,FecVD,Cd_Clt,Cd_Vdr,Cd_Area,Cd_MR,Obs,Valor,TotDsctoP,TotDsctoI,
			  ValorNeto,BaseSinDsctoF,DsctoFnz_P,DsctoFnz_I,Cd_IAV_DF,INF_Neto,EXO_Neto,EXPO_Neto,BIM_Neto,	
			  IGV,Total,Percep,Cd_Mda,CamMda,UsuCrea,FecReg,IB_Anulado,IB_Cbdo,
			  CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,CA11,CA12,CA13,CA14,CA15,CA16,CA17,CA18,CA19,CA20,CA21,CA22,CA23,CA24,CA25,
			  Cd_OP,Cd_CC,Cd_SC,Cd_SS,NroSre,Cd_MIS,NroOP,
			  --Documento Referencia
			  DR_CdVta,DR_FecED,DR_CdTD,DR_NSre,DR_NDoc)
		   values(@RucE,@Cd_Vta,@Eje,@Prdo,@RegCtb,@FecMov,@Cd_FPC,@FecCbr,@Cd_TD,@NroDoc,
			  @FecED,@FecVD,@Cd_Clt,@Cd_Vdr,@Cd_Area,@Cd_MR,@Obs,@Valor,@TotDsctoP,@TotDsctoI,
			  @ValorNeto,@BaseSinDsctoF,@DsctoFnz_P,@DsctoFnz_I,@Cd_IAV_DF,@INF_Neto,@EXO_Neto,@EXPO_Neto,@BIM_Neto,	  
			  @IGV,@Total,@Percep,@Cd_Mda,@CamMda,@UsuCrea,getdate(),0,@IB_Cbdo,
			  @CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@CA11,@CA12,@CA13,@CA14,@CA15,
			  @CA16,@CA17,@CA18,@CA19,@CA20,@CA21,@CA22,@CA23,@CA24,@CA25,
			  @Cd_OP,@Cd_CC,@Cd_SC,@Cd_SS,@NroSre,@Cd_MIS,@NroOP,
			  --Documento Referencia
			  @DR_CdVta,@DR_FecED,@DR_CdTD,@DR_NSre,@DR_NDoc)
	if @@rowcount <= 0
	begin
	   Set @msj = 'Error al registrar venta'
	end

  
	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from VentaRM where RucE=@RucE)
	insert into VentaRM(NroReg,RucE,Cd_Vta,Cd_TD,NroDoc,Total,Cd_Mda,FecMov,Cd_Area,Cd_MR,Usu,Cd_Est)
		     Values(@NroReg,@RucE,@Cd_Vta,@Cd_TD,@NroDoc,@Total,@Cd_Mda,getdate(),@Cd_Area,@Cd_MR,@UsuCrea,'01')
	-----------------------------------------------------------------------------------

end
--JJ: 2010-09-13:   <Creacion del SP>
--JU: 2010-09-17:   <Modificacion del SP>
--JU: 2010-09-22:   <Se Reestructuro el SP agregando los nuevos campos>
--PP: 2011-03-15:   <modificar a restricion   >
--FL: 2011-04-06:   <se agrego el indicador @IB_Cbdo que no se enviaba>
--JJ: 2012-05-16:   <Modificacion del SP>








GO
