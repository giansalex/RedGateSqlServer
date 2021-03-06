SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaCreaImport2]
@RucE nvarchar(11),
@FecMov smalldatetime,
@FecCbr smalldatetime,
@Cd_TD nvarchar(2),
@NroDoc nvarchar(15),
@NroSerie nvarchar(5), --@Cd_Sr nvarchar(4),
@FecED smalldatetime,
@FecVD smalldatetime,
@Cd_TDICte nvarchar(2), --@Cd_Cte nvarchar(7),
@NroDocCte nvarchar(15),
@Cd_Vdr nvarchar(7),
@Cd_Area nvarchar(6),
@Cd_MR nvarchar(2),
@Obs varchar(1000),
@BIM numeric(13,2),
@IGV numeric(13,2),
@Total numeric(13,2),
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
@INF numeric(13,2),
@EXO numeric(13,2),
------------------------------
@DR_FecED smalldatetime,
@DR_CdTD nvarchar(2),
@DR_NSre nvarchar(4),
@DR_NDoc nvarchar(15),
------------------------------
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),

@DsctoFnzP decimal(5,2),
@DsctoFnzI decimal(13,2),

@msj varchar(100) output
as

declare @Cd_Sr nvarchar(4), @Cd_Cte nvarchar(7)

set @Cd_Sr = (select Cd_Sr from Serie where  RucE=@RucE and NroSerie=@NroSerie)

if @Cd_Sr='' or @Cd_Sr is null
begin 	set @msj = 'Serie no valida en documento ' +@NroDoc
	return
end


set @Cd_Cte=''
set @Cd_Cte = (select Cd_Aux from Auxiliar where  RucE=@RucE and Cd_TDI = @Cd_TDICte and NDoc = @NroDocCte)

if @Cd_Cte='' or @Cd_Cte is null
begin 	set @msj = 'Nro de documento de identidad no pertenece a ningun cliente,  en documento ' +@NroDocCte
	return
end


exec Vta_VentaCrea4 @RucE,@FecMov,@FecCbr,@Cd_TD,@NroDoc,@Cd_Sr,@FecED,@FecVD,@Cd_Cte,@Cd_Vdr,@Cd_Area,@Cd_MR,@Obs,@BIM,@IGV,@Total,@Cd_Mda,@CamMda,@UsuCrea,@IB_Anulado,@Cd_Vta output,@RegCtb,@Eje,@Prdo,@Cd_FPC,@INF,@EXO,@DR_FecED,@DR_CdTD,@DR_NSre,@DR_NDoc,@Cd_CC,@Cd_SC,@Cd_SS,@DsctoFnzP,@DsctoFnzI,@msj output

-- LEYENDA --

--PV : Jue 11-12-08
--PV : Vie 12-12-08
--DI : Jue 20-05-10 <Creacion del procedimiento al macenado>
		  --<Se creo con la referencia de procedimiento Vta_VentaCreaImport>
GO
