SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_CanjeCrea]

@RucE	nvarchar(11),
@Ejer	nvarchar(4),

@Cd_Cnj	char(10) output,

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
@UsuReg	varchar(20),
--@UsuMdf	varchar(20),


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

If exists (Select * From Canje Where RucE=@RucE and Cd_Cnj=@Cd_Cnj)
	set @msj = 'Ya existe un canje con el mismo codigo'
Else
Begin

	Set @Cd_Cnj = ( Select dbo.Cd_Cnj(@RucE) )

	Insert into Canje(RucE,Ejer,Cd_Cnj,RegCtb,Prdo,FecMov,Cd_Clt,Cd_MIS,Cd_Mda,TipCam,
					  CantLtr,OtrosImp,Total,Obs,Cd_Area,Cd_CC,Cd_SC,Cd_SS,FecReg,UsuReg
					  ,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10)
			   Values(@RucE,@Ejer,@Cd_Cnj,@RegCtb,@Prdo,@FecMov,@Cd_Clt,@Cd_MIS,@Cd_Mda,@TipCam,
					  @CantLtr,@OtrosImp,@Total,@Obs,@Cd_Area,@Cd_CC,@Cd_SC,@Cd_SS,getdate(),@UsuReg
					  ,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10)
					  
	If @@rowcount <= 0
	Begin
		set @msj = 'No se pudo crear canje de letras'
	End
End

-- Leyenda --
-- Di : 04/01/2012 <Creacion del SP>
-- Di : 19/02/2012 <Se agrego Columna OtrosImp>
GO
