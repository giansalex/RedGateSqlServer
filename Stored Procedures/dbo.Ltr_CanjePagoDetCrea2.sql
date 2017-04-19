SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_CanjePagoDetCrea2]

@RucE	nvarchar(11),
@Cd_Com	nvarchar(10),

@Cd_Vou	nvarchar(10),

@Cd_Cnj	char(10),
@Cd_Ltr	int,

@Cd_Mda nvarchar(2),

@Importe numeric(13,2),
@DsctPor numeric(5,2),
@DsctImp numeric(13,2),
@Total numeric(13,2),

@Cd_TD nvarchar(2),
@NroSre nvarchar(5),
@NroDoc nvarchar(15),

@msj nvarchar(100) output

AS

If exists (Select * From CanjePagoDet Where RucE=@RucE and isnull(Cd_Com,'')=@Cd_Com and isnull(Cd_Vou,'')=@Cd_Vou and isnull(Cd_Cnj,'')=@Cd_Cnj and Cd_Ltr=@Cd_Ltr)
	set @msj = 'Ya existe un canje relacionado con las facturas indicadas'
Else
Begin

	-- Se agrego-------------------------
	Declare @Cd_CC nvarchar(8),@Cd_SC nvarchar(8),@Cd_SS nvarchar(8)
	Set @Cd_CC=null Set @Cd_SC=null Set @Cd_SS=null
	Select top 1 @Cd_CC=Cd_CC,@Cd_SC=Cd_SC,@Cd_SS=Cd_SS From CanjePago Where RucE=@RucE and Cd_Cnj=@Cd_Cnj
	-------------------------------------

	Declare @Item int
	Select @Item=isnull(Max(Item),0)+1 From CanjePagoDet Where RucE=@RucE and Cd_Cnj=@Cd_Cnj

	if(@Cd_Vou='') Set @Cd_Vou=null

	Insert into CanjePagoDet(RucE,Cd_Cnj,Item,Cd_Com,Cd_Vou,Cd_Ltr,Cd_TD,NroSre,NroDoc,Cd_Mda,Importe,DsctPor,DsctImp,Total,Cd_CC,Cd_SC,Cd_SS)
			   Values(@RucE,@Cd_Cnj,@Item,@Cd_Com,@Cd_Vou,@Cd_Ltr,@Cd_TD,@NroSre,@NroDoc,@Cd_Mda,@Importe,@DsctPor,@DsctImp,@Total,@Cd_CC,@Cd_SC,@Cd_SS)
					  
	If @@rowcount <= 0
	Begin
		set @msj = 'No se pudo crear canje detalle'
	End
	Else
	Begin
		
		-- REGISTRAR MOVIMIENTOS --
		Declare @Ejer nvarchar(4)
		Declare @RegCtb nvarchar(15)
		Declare @Prdo nvarchar(2)
		Declare @FecMov smalldatetime
		Declare @Cd_Prv char(7)
		Declare @TipCam numeric(13,4)
		Declare @CantLtr int
		Declare @OtrosImp numeric(13,2)
		Declare @TotalG numeric(13,3)
		Declare @Obs varchar(200)
		Declare @NomUsu varchar(10)
		
		--Declare @Cd_TD nvarchar(2)
		--Declare @NroSre varchar(5)
		--Declare @NroDoc nvarchar(15)
		
		Select 
			@Ejer=Ejer,	@RegCtb=RegCtb,	@Prdo=Prdo,	@FecMov=FecMov,	@Cd_Prv=Cd_Prv,	@Cd_Mda=Cd_Mda,
			@TipCam=TipCam,	@CantLtr=CantLtr,	@OtrosImp=OtrosImp,  @TotalG=Total,	@Obs=Obs,  @NomUsu=UsuReg
		From CanjePago Where RucE=@RucE and Cd_Cnj=@Cd_Cnj
		
		if(ISNULL(@Cd_Ltr,0)<>0)
			Select @Cd_TD=Cd_TD,@NroSre='',@NroDoc=ISNULL(NroRenv,'')+ISNULL(NroLtr,'') From Letra_Pago Where RucE=@RucE and Cd_Cnj=@Cd_Cnj and Cd_Ltr=@Cd_Ltr

		insert into CanjePagoDetRM(	RucE,Ejer,Cd_Cnj,RegCtb,Prdo,FecMov,Cd_Prv,Cd_Mda,TipCam,CantLtr,OtrosImp,Total,
								Obs,FecReg,Cd_Com,Cd_Vou,Cd_Ltr,Cd_TD,NroSre,NroDoc,Importe,DsctPor,DsctImp,TotalDoc,Cd_Est,NomUsu )
						Values( @RucE,@Ejer,@Cd_Cnj,@RegCtb,@Prdo,@FecMov,@Cd_Prv,@Cd_Mda,@TipCam,@CantLtr,@OtrosImp,@TotalG,
								@Obs,getdate(),@Cd_Com,@Cd_Vou,@Cd_Ltr,@Cd_TD,@NroSre,@NroDoc,@Importe,@DsctPor,@DsctImp,@Total,'01',@NomUsu )
		
		print 'registrando movimiento'
	End
End


-- Leyenda --
-- Di : 09/04/2012 <Creacion del SP>
-- Di : 27/02/2013 <Se agrego las columnas centro de costos>

GO
