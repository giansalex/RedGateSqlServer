SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_Letra_PagoElim_X_Cnj]

@RucE	nvarchar(11),
@Cd_Cnj	char(10),

@msj nvarchar(100) output

AS


If not exists (Select * From Letra_Pago Where RucE=@RucE and Cd_Cnj=@Cd_Cnj)
	set @msj = 'No se encontro letra(s)'
Else If exists (Select d.* From	CanjePagoDet d	Inner Join Letra_Pago l On l.RucE=d.RucE and l.Cd_Cnj=@Cd_Cnj and l.Cd_Ltr=d.Cd_Ltr)
	Set @msj = 'Letra se encuentra asociada en otro registro'
Else
Begin
	Delete From Letra_Pago Where RucE=@RucE and Cd_Cnj=@Cd_Cnj
	If @@Rowcount <= 0
		set @msj = 'No se pudo eliminar letra'
End

-- Leyenda --
-- Di : 09/04/2012 <Creacion del SP>
GO
