SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_CanjeDetCrea]

@RucE	nvarchar(11),
@Cd_Vta	nvarchar(10),
@Cd_Cnj	char(10),
@Cd_Ltr	int,

@Cd_Mda nvarchar(2),

@Importe numeric(13,2),
@DsctPor numeric(5,2),
@DsctImp numeric(13,2),
@Total numeric(13,2),

@msj nvarchar(100) output

AS

If exists (Select * From CanjeDet Where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cnj=@Cd_Cnj and Cd_Ltr=@Cd_Ltr)
	set @msj = 'Ya existe un canje relacionado con las facturas indicadas'
Else
Begin

	Declare @Item int
	Select @Item=isnull(Max(Item),0)+1 From CanjeDet Where RucE=@RucE and Cd_Cnj=@Cd_Cnj

	Insert into CanjeDet(RucE,Cd_Cnj,Item,Cd_Vta,Cd_Ltr,Cd_Mda,Importe,DsctPor,DsctImp,Total)
			   Values(@RucE,@Cd_Cnj,@Item,@Cd_Vta,@Cd_Ltr,@Cd_Mda,@Importe,@DsctPor,@DsctImp,@Total)
					  
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
		Declare @Cd_Clt char(10)
		Declare @TipCam numeric(13,4)
		Declare @CantLtr int
		Declare @OtrosImp numeric(13,2)
		Declare @TotalG numeric(13,3)
		Declare @Obs varchar(200)
		Declare @NomUsu varchar(10)
		
		Declare @Cd_TD nvarchar(2)
		Declare @NroSre varchar(5)
		Declare @NroDoc nvarchar(15)
		
		Select 
			@Ejer=Ejer,	@RegCtb=RegCtb,	@Prdo=Prdo,	@FecMov=FecMov,	@Cd_Clt=Cd_Clt,	@Cd_Mda=Cd_Mda,
			@TipCam=TipCam,	@CantLtr=CantLtr,	@OtrosImp=OtrosImp,  @TotalG=Total,	@Obs=Obs,  @NomUsu=UsuReg
		From Canje Where RucE=@RucE and Cd_Cnj=@Cd_Cnj
		
		if(isnull(@Cd_Vta,'')<>'')
			Select @Cd_TD=Cd_TD,@NroSre=NroSre,@NroDoc=NroDoc From Venta Where RucE=@RucE and Cd_Vta=@Cd_Vta
		Else if(ISNULL(@Cd_Vta,0)<>0)
			Select @Cd_TD=Cd_TD,@NroSre='',@NroDoc=ISNULL(NroRenv,'')+ISNULL(NroLtr,'') From Letra_Cobro Where RucE=@RucE and Cd_Cnj=@Cd_Cnj and Cd_Ltr=@Cd_Ltr

		insert into CanjeDetRM(	RucE,Ejer,Cd_Cnj,RegCtb,Prdo,FecMov,Cd_Clt,Cd_Mda,TipCam,CantLtr,OtrosImp,Total,
								Obs,FecReg,Cd_Vta,Cd_Ltr,Cd_TD,NroSre,NroDoc,Importe,DsctPor,DsctImp,TotalDoc,Cd_Est,NomUsu )
						Values( @RucE,@Ejer,@Cd_Cnj,@RegCtb,@Prdo,@FecMov,@Cd_Clt,@Cd_Mda,@TipCam,@CantLtr,@OtrosImp,@TotalG,
								@Obs,getdate(),@Cd_Vta,@Cd_Ltr,@Cd_TD,@NroSre,@NroDoc,@Importe,@DsctPor,@DsctImp,@Total,'01',@NomUsu )
		
		print 'registrando movimiento'
	End
End


-- Leyenda --
-- Di : 04/01/2012 <Creacion del SP>
GO
