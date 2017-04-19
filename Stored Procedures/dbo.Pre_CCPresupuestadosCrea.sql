SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Pre_CCPresupuestadosCrea]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@NroCta varchar(10),
@Ene decimal(13,2),
@Ene_ME decimal(13,2),
@Feb decimal(13,2),
@Feb_ME decimal(13,2),
@Mar decimal(13,2),
@Mar_ME decimal(13,2),
@Abr decimal(13,2),
@Abr_ME decimal(13,2),
@May decimal(13,2),
@May_ME decimal(13,2),
@Jun decimal(13,2),
@Jun_ME decimal(13,2),
@Jul decimal(13,2),
@Jul_ME decimal(13,2),
@Ago decimal(13,2),
@Ago_ME decimal(13,2),
@Sep decimal(13,2),
@Sep_ME decimal(13,2),
@Oct decimal(13,2),
@Oct_ME decimal(13,2),
@Nov decimal(13,2),
@Nov_ME decimal(13,2),
@Dic decimal(13,2),
@Dic_ME decimal(13,2),

@msj varchar(100) output

AS

Begin Transaction
	
	Begin  
		Insert Into dbo.Presupuesto( RucE,Cd_Psp,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,
					     Ene,Ene_ME,Feb,Feb_ME,Mar,Mar_ME,Abr,Abr_ME,May,May_ME,Jun,Jun_ME,
					     Jul,Jul_ME,Ago,Ago_ME,Sep,Sep_ME,Oct,Oct_ME,Nov,Nov_ME,Dic,Dic_ME,Estado
					   )
				     Values( @RucE,dbo.Cod_Psp(@RucE),@Ejer,@Cd_CC,@Cd_SC,@Cd_SS,@NroCta,
					     @Ene,@Ene_ME,@Feb,@Feb_ME,@Mar,@Mar_ME,@Abr,@Abr_ME,@May,@May_ME,@Jun,@Jun_ME,
					     @Jul,@Jul_ME,@Ago,@Ago_ME,@Sep,@Sep_ME,@Oct,@Oct_ME,@Nov,@Nov_ME,@Dic,@Dic_ME,1
				      	   )
		
		If @@Rowcount <= 0
		Begin
			Set @msj = 'Error al ingresar presupuesto'
			Rollback Transaction
		End
	End

commit transaction

-- Leyenda --
-- Di: 29/12/2010 <Creacion del procedimiento almacenado>
GO
