SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_CanjeMdf]

@RucE	nvarchar(11),
@Ejer	nvarchar(4),

@Cd_Cnj	char(10),

@RegCtb	nvarchar(15),
@Prdo	nvarchar(2),
@FecMov	smalldatetime,
@Cd_Clt	char(10),
@Cd_MIS	char(3),
@Cd_Mda	nvarchar(2),
@TipCam	numeric(8,3),
@CantLtr	int,
@OtrosImp numeric(13,2),
@Total	numeric(13,2),
@Obs	varchar(200),
@Cd_Area	varchar(6),
@Cd_CC	nvarchar(8),
@Cd_SC	nvarchar(8),
@Cd_SS	nvarchar(8),
--@FecReg	datetime,
--@FecMdf	datetime,
--@UsuReg	varchar(20),
@UsuMdf	varchar(20),


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


@msj nvarchar(100) output

AS

If not exists (Select * From Canje Where RucE=@RucE and Cd_Cnj=@Cd_Cnj)
	set @msj = 'No existe canje'
Else
Begin

	Update Canje Set
		RegCtb=@RegCtb,
		Prdo=@Prdo,
		FecMov=@FecMov,
		Cd_Clt=@Cd_Clt,
		Cd_MIS=@Cd_MIS,
		Cd_Mda=@Cd_Mda,
		TipCam=@TipCam,
		CantLtr=@CantLtr,
		OtrosImp=@OtrosImp,
		Total=@Total,
		Obs=@Obs,
		Cd_Area=@Cd_Area,
		Cd_CC=@Cd_CC,
		Cd_SC=@Cd_SC,
		Cd_SS=@Cd_SC,
		FecMdf=GetDate(),
		UsuMdf=@UsuMdf,
		CA01=@CA01,
		CA02=@CA02,
		CA03=@CA03,
		CA04=@CA04,
		CA05=@CA05,
		CA06=@CA06,
		CA07=@CA07,
		CA08=@CA08,
		CA09=@CA09,
		CA10=@CA10
	Where
		RucE=@RucE and Ejer=@Ejer and Cd_Cnj=@Cd_Cnj
					  
	If @@rowcount <= 0
	Begin
		set @msj = 'No se pudo modificar canje de letras'
	End
End

-- Leyenda --
-- Di : 16/01/2012 <Creacion del SP>
-- Di : 19/02/2012 <Se agrego la columna OtrosImp>

GO
