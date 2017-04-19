SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_Letra_CobroCrea]

@RucE	nvarchar(11),
@Cd_Cnj	char(10),
--@Cd_Ltr	int,
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


DECLARE @Cd_Ltr int
Set @Cd_Ltr = ( Select isnull(max(Cd_Ltr),0)+1 From Letra_Cobro Where RucE=@RucE)

If exists (Select * From Letra_Cobro Where RucE=@RucE and Cd_Cnj=@Cd_Cnj and Cd_Ltr=@Cd_Ltr)
	set @msj = 'Ya existe una letra con mismo codigo'
Else
Begin

	-- Se agrego-------------------------
	Declare @Cd_CC nvarchar(8),@Cd_SC nvarchar(8),@Cd_SS nvarchar(8)
	Set @Cd_CC=null Set @Cd_SC=null Set @Cd_SS=null
	Select top 1 @Cd_CC=Cd_CC,@Cd_SC=Cd_SC,@Cd_SS=Cd_SS From CanjePago Where RucE=@RucE and Cd_Cnj=@Cd_Cnj
	-------------------------------------

	Declare @Cd_TD varchar(2) Set @Cd_TD='39'
	Insert into Letra_Cobro(RucE,Cd_Cnj,Cd_Ltr,Cd_TD,NroRenv,NroLtr,RefGdor,LugGdor,FecGiro,FecVenc,Plazo,Imp,Dsct,Total,FecReg,
				CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,Cd_CC,Cd_SC,Cd_SS)
			   Values(@RucE,@Cd_Cnj,@Cd_Ltr,@Cd_TD,@NroRenv,@NroLtr,@RefGdor,@LugGdor,@FecGiro,@FecVenc,@Plazo,@Imp,@Dsct,@Total,getdate(),
				@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Cd_CC,@Cd_SC,@Cd_SS)
					  
	If @@rowcount <= 0
	Begin
		set @msj = 'No se pudo crear letra'
	End
	Else
	Begin
		
		-- REGISTRAR MOVIMIENTOS --
		Declare @NomUsu varchar(10)
		Select @NomUsu=UsuReg From Canje Where RucE=@RucE and Cd_Cnj=@Cd_Cnj
		insert into Letra_CobroRM( RucE,Cd_Cnj,Cd_Ltr,Cd_TD,NroRenv,NroLtr,RefGdor,LugGdor,
								   FecGiro,FecVenc,Plazo,Imp,Dsct,Total,FecReg,Cd_Est,NomUsu )
						   Values( @RucE,@Cd_Cnj,@Cd_Ltr,@Cd_TD,@NroRenv,@NroLtr,@RefGdor,@LugGdor,
								   @FecGiro,@FecVenc,@Plazo,@Imp,@Dsct,@Total,getdate(),'01',@NomUsu)
		
		print 'registrando movimiento'
	End
End

-- Leyenda --
-- Di : 04/01/2012 <Creacion del SP>
-- Di : 27/02/2013 <Se agrego las columnas centro de costos>

GO
