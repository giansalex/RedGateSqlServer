SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[Gsp_CCostosPspElim]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@msj varchar(100) output

AS

-- Eliminando Informacion

If exists (Select * from Presupuesto Where RucE=@RucE and Ejer=@Ejer and Case When isnull(@Cd_CC,'')='' Then '' Else Cd_CC End=isnull(@Cd_CC,'') and Case When isnull(@Cd_SC,'')='' Then '' Else Cd_SC End=isnull(@Cd_SC,'') and Case When isnull(@Cd_SS,'')='' Then '' Else Cd_SS End=isnull(@Cd_SS,''))
Begin
	delete from Presupuesto 
	Where 	RucE=@RucE 
		and Ejer=@Ejer 
		and Case When isnull(@Cd_CC,'')='' Then '' Else Cd_CC End=isnull(@Cd_CC,'')
		and Case When isnull(@Cd_SC,'')='' Then '' Else Cd_SC End=isnull(@Cd_SC,'')
		and Case When isnull(@Cd_SS,'')='' Then '' Else Cd_SS End=isnull(@Cd_SS,'')
	
	If @@rowcount <= 0
	begin
		Set @msj='Error al eliminar informacion presupuestada'
		return
	end
End

-- Quitando check presupuesto

if (isnull(@Cd_SS,'') <> '')
begin
	update CCSubSub Set
		IB_Psp=0
	Where RucE=@RucE and Case When isnull(@Cd_CC,'')='' Then '' Else Cd_CC End=isnull(@Cd_CC,'') and Case When isnull(@Cd_SC,'')='' Then '' Else Cd_SC End=isnull(@Cd_SC,'') and Case When isnull(@Cd_SS,'')='' Then '' Else Cd_SS End=isnull(@Cd_SS,'')
	
	If @@rowcount <= 0
	begin
		Set @msj='Error al actualizar informacion SS'
		return
	end
end
else if (isnull(@Cd_SC,'') <> '')
begin
	update CCSub Set
		IB_Psp=0
	Where RucE=@RucE and Case When isnull(@Cd_CC,'')='' Then '' Else Cd_CC End=isnull(@Cd_CC,'') and Case When isnull(@Cd_SC,'')='' Then '' Else Cd_SC End=isnull(@Cd_SC,'')
	
	If @@rowcount <= 0
	begin
		Set @msj='Error al actualizar informacion SC'
		return
	end
end
else if (isnull(@Cd_CC,'') <> '')
begin
	update CCostos Set
		IB_Psp=0
	Where RucE=@RucE and Case When isnull(@Cd_CC,'')='' Then '' Else Cd_CC End=isnull(@Cd_CC,'')
	
	If @@rowcount <= 0
	begin
		Set @msj='Error al actualizar informacion CC'
		return
	end
end
	
-- Leyenda --
-- Di : 06/01/2011 <Creacion del procedimiento almacenado>
GO
