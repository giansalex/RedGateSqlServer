SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Crd_CreditoAnalisisMdf]

@RucE	nvarchar(11),
@Ejer	nvarchar(11),
@Cd_ACrd	int,
@FecMov	smalldatetime,
@Cd_Clt	char(10),
@TipoVivienda	varchar(50),
@EstCivil	varchar(20),
@CantFam	int,
@CantHijos	int,
@Sexo	char(1),
@Ren01	decimal(13,2),
@Ren02	decimal(13,2),
@Ren03	decimal(13,2),
@Ren04	decimal(13,2),
@Ren05	decimal(13,2),
@OtrosIng	decimal(13,2),
@TotalIng	decimal(13,2),
@CanastaFam	decimal(13,2),
@Vivienda	decimal(13,2),
@Colegio	decimal(13,2),
@PrestamoBan	decimal(13,2),
@CreditoBan	decimal(13,2),
@OtrosEgr1	decimal(13,2),
@OtrosEgr2	decimal(13,2),
@TotalEgr	decimal(13,2),
@SaldoDisp	decimal(13,2),
@PorcDisp	decimal(5,2),
@ImpDisp	decimal(13,2),
@ValorCrd	decimal(13,2),
@TasaAnu	decimal(5,2),
@ValorTasa	decimal(13,2),
@TotalCrd	decimal(13,2),
@NroCuotas	int,
@CuotaMen	decimal(13,2),
@CA01	varchar(100),
@CA02	varchar(100),
@CA03	varchar(100),
@CA04	varchar(100),
@CA05	varchar(100),
@CA06	varchar(100),
@CA07	varchar(100),
@CA08	varchar(100),
@CA09	varchar(100),
@CA10	varchar(100),
@CA11	varchar(100),
@CA12	varchar(100),
@CA13	varchar(100),
@CA14	varchar(100),
@CA15	varchar(100),
@CA16	varchar(100),
@CA17	varchar(100),
@CA18	varchar(100),
@CA19	varchar(100),
@CA20	varchar(100),

@msj varchar(100) output

AS

if not exists (Select * From dbo.CreditoAnalisis Where RucE=@RucE and Ejer=@Ejer and Cd_ACrd=@Cd_ACrd)
	Set @msj = 'No se encontro el registro'
else
Begin
	update dbo.CreditoAnalisis set
				FecMov=@FecMov,
				Cd_Clt=@Cd_Clt,
				TipoVivienda=@TipoVivienda,
				EstCivil=@EstCivil,
				CantFam=@CantFam,
				CantHijos=@CantHijos,
				Sexo=@Sexo,
				Ren01=@Ren01,
				Ren02=@Ren02,
				Ren03=@Ren03,
				Ren04=@Ren04,
				Ren05=@Ren05,
				OtrosIng=@OtrosIng,
				TotalIng=@TotalIng,
				CanastaFam=@CanastaFam,
				Vivienda=@Vivienda,
				Colegio=@Colegio,
				PrestamoBan=@PrestamoBan,
				CreditoBan=@CreditoBan,
				OtrosEgr1=@OtrosEgr1,
				OtrosEgr2=@OtrosEgr2,
				TotalEgr=@TotalEgr,
				SaldoDisp=@SaldoDisp,
				PorcDisp=@PorcDisp,
				ImpDisp=@ImpDisp,
				ValorCrd=@ValorCrd,
				TasaAnu=@TasaAnu,
				ValorTasa=@ValorTasa,
				TotalCrd=@TotalCrd,
				NroCuotas=@NroCuotas,
				CuotaMen=@CuotaMen,
				CA01=@CA01,
				CA02=@CA02,
				CA03=@CA03,
				CA04=@CA04,
				CA05=@CA05,
				CA06=@CA06,
				CA07=@CA07,
				CA08=@CA08,
				CA09=@CA09,
				CA10=@CA10,
				CA11=@CA11,
				CA12=@CA12,
				CA13=@CA13,
				CA14=@CA14,
				CA15=@CA15,
				CA16=@CA16,
				CA17=@CA17,
				CA18=@CA18,
				CA19=@CA19,
				CA20=@CA20
	Where RucE=@RucE and Ejer=@Ejer and Cd_ACrd=@Cd_ACrd
	
	if @@rowcount <= 0
	Begin
		Set @msj = 'Error al modificar analisis crediticio'
	End
End



-- Leyenda --
-- DI : 23/11/2011 <Creacion del SP>

GO
