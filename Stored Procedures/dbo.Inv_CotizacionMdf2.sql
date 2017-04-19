SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionMdf2]

/*
exec Inv_CotizacionConsUn '11111111111','CT00000002',null
*/

@RucE nvarchar(11),
@Cd_Cot char(10),
@NroCot varchar(15),
@FecEmi smalldatetime, 
@FecCad smalldatetime,
@Cd_FPC nvarchar(2),
@Asunto varchar(200),
@Cd_Clt char(10),
@Cd_Vdr char(7),
@CostoTot numeric(13,2),
@Valor numeric(13,2),
@TotDsctoP numeric(5,2),
@TotDsctoI numeric(13,2),
@INF numeric(13,2),
@DsctoFnzInf_P numeric(5,2),
@DsctoFnzInf_I numeric(13,2),
@INF_Neto numeric(13,2),
@BIM numeric(13,2),
@DsctoFnzAf_P numeric(5,2),
@DsctoFnzAf_I numeric(13,2),
@BIM_Neto numeric(13,2),
@IGV numeric(13,2),
@Total numeric(13,2),
@MU_Porc numeric(13,2),
@MU_Imp numeric(13,2),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
@Cd_Area nvarchar(6),
@Obs varchar(1000), 
@UsuMdf nvarchar(10),
@CdCot_Base char(10),
--@Id_EstC char(2),
@Cd_FCt char(2),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),

@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),

@msj varchar(100) output

as

if not exists (select * from Cotizacion where RucE=@RucE and Cd_Cot=@Cd_Cot)
	Set @msj = 'No existe cotizacion'
else
begin

	-- ACTUALIZANDO INFORMACION DE COTIZACION
	update Cotizacion Set
		FecEmi = @FecEmi,
		FecCad = @FecCad,
        Cd_FPC = @Cd_FPC,
		Asunto = @Asunto,
		Cd_Clt = @Cd_Clt,
		Cd_Vdr = @Cd_Vdr,
		CostoTot = @CostoTot,
		Valor = @Valor,
		TotDsctoP = @TotDsctoP,
		TotDsctoI = @TotDsctoI,
		INF = @INF,
        DsctoFnzInf_P = @DsctoFnzInf_P,
		DsctoFnzInf_I = @DsctoFnzInf_I,
		INF_Neto = @INF_Neto,
		BIM = @BIM,
		DsctoFnzAf_P = @DsctoFnzAf_P,
		DsctoFnzAf_I = @DsctoFnzAf_I,
		BIM_Neto = @BIM_Neto,
		IGV = @IGV,
		Total = @Total,
		MU_Porc = @MU_Porc,
        MU_Imp = @MU_Imp,
		Cd_Mda = @Cd_Mda,
		CamMda = @CamMda,
		Cd_Area = @Cd_Area,
		Obs = @Obs,
		FecMdf = GetDate(), 
		UsuMdf = @UsuMdf,
		--CdCot_Base = @CdCot_Base,
		--Id_EstC = @Id_EstC,
		Cd_FCt = @Cd_FCt,
		CA01 = @CA01,
		CA02 = @CA02,
		CA03 = @CA03,
		CA04 = @CA04,
		CA05 = @CA05,
		
		Cd_CC = @Cd_CC,
		Cd_SC = @Cd_SC,
		Cd_SS = @Cd_SS

	where RucE=@RucE and Cd_Cot=@Cd_Cot and NroCot=@NroCot
	
	if @@ROWCOUNT > 0
	BEGIN
		-- ELIMINANDO DETALLE DE PRODUCTOS
		Delete From CotizacionProdDet Where RucE=@RucE and Cd_Cot=@Cd_Cot
		-- ELIMINANDO DETALLE DE LA COTIZACION
		Delete From CotizacionDet Where RucE=@RucE and Cd_Cot=@Cd_Cot
	END
	ElSE
		SET @msj ='Cotizacion no pudo ser modificado'
end

-- Leyenda --
-- DI : 09/06/2011 : <Creacion del procedimiento almacenado>

GO
