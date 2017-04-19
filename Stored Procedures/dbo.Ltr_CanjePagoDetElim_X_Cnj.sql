SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_CanjePagoDetElim_X_Cnj]

@RucE nvarchar(11),
@Cd_Cnj char(10),

@msj varchar(100) output

AS

If not exists (Select * From CanjePagoDet Where RucE=@RucE and Cd_Cnj=@Cd_Cnj)
	Set @msj = 'No se encontro canje'
--Else If exists (Select * From CanjeDet Where RucE=@RucE and Cd_Cnj=@Ejer and isnull(Cd_Ltr,'') <> '')
Else If exists (Select d.* From	CanjePagoDet d	Inner Join Letra_Pago l On l.RucE=d.RucE and l.Cd_Cnj=@Cd_Cnj and l.Cd_Ltr=d.Cd_Ltr)
	Set @msj = 'Letra se encuentra asociada en otro registro'
Else
	Begin
		delete from CanjePagoDet Where RucE=@RucE and Cd_Cnj=@Cd_Cnj
		if @@rowcount <= 0
			Set @msj = 'No se pudo eliminar canje detalle'
	End

Print @msj
-- Leyedan --
-- DI : 09/04/2012 <Creacion del SP>

GO
