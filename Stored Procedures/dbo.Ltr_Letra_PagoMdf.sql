SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_Letra_PagoMdf]

@RucE	nvarchar(11),
@Cd_Cnj	char(10),
@Cd_Ltr	int,

@NroRenv varchar(5),
@NroLtr	varchar(10),
@RefGdor varchar(50),
@LugGdor varchar(100),
@FecGiro smalldatetime,
@FecVenc smalldatetime,
@Plazo int,
@Imp	numeric(13,2),
@Dsct	numeric(13,2),
@Total	numeric(13,2),
--@FecReg	datetime,
--@FecMdf	datetime,

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


If not exists (Select * From Letra_Pago Where RucE=@RucE and Cd_Cnj=@Cd_Cnj and Cd_Ltr=@Cd_Ltr)
	set @msj = 'No existe una letra'
Else
Begin

	update Letra_Pago set
		NroRenv=@NroRenv,
		NroLtr=@NroLtr,
		RefGdor=@RefGdor,
		LugGdor=@LugGdor,
		FecGiro=@FecGiro,
		FecVenc=@FecVenc,
		Plazo=@Plazo,
		Imp=@Imp,
		Dsct=@Dsct,
		Total=@Total,
		FecMdf=getdate(),
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
	Where RucE=@RucE and Cd_Cnj=@Cd_Cnj and Cd_Ltr=@Cd_Ltr
					  
	If @@rowcount <= 0
	Begin
		set @msj = 'No se pudo modificar letra'
	End
End

-- Leyenda --
-- Di : 09/04/2012 <Creacion del SP>
GO
