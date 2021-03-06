SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Ltr_CanjePagoAnula]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Prv char(7),
@Cd_Cnj char(10),

@IB_Anulado bit,

@msj varchar(100) output

AS

if exists (Select * From CanjePago Where RucE=@RucE and Ejer=@Ejer and Cd_Prv=@Cd_Prv and Cd_Cnj=@Cd_Cnj)
Begin

	Update CanjePago Set
		IB_Anulado = isnull(@IB_Anulado,0)
	Where 
		RucE=@RucE 
		and Ejer=@Ejer
		and Cd_Prv=@Cd_Prv
		and Cd_Cnj=@Cd_Cnj
		
	if @@rowcount > 0
	Begin
		if exists (Select * From CanjePagoDetRM Where RucE=@RucE and Ejer=@Ejer and Cd_Prv=@Cd_Prv and Cd_Cnj=@Cd_Cnj)
		Begin
		
			Declare @RegCtb nvarchar(15)
			Set @RegCtb=(Select RegCtb From CanjePago Where RucE=@RucE and Cd_Cnj=@Cd_Cnj)
			
			Update CanjePagoDetRM Set
				IB_Anulado = isnull(@IB_Anulado,0)
			Where 
				RucE=@RucE 
				and Ejer=@Ejer
				and Cd_Prv=@Cd_Prv
				and Cd_Cnj=@Cd_Cnj
				
			update Voucher Set 
				IB_Anulado= isnull(@IB_Anulado,0) 
			Where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
			
		End
	End
	Else
		Set @msj = 'No se pudo anulado o habilitar'
End
Else
	Set @msj = 'No se encontro registro para anular o habilitar'

-- Leyenda --
-- DI : 09/04/2012 <Creacion del SP>
GO
