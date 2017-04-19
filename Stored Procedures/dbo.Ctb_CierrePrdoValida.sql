SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_CierrePrdoValida]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(20),
@Codigo nvarchar(10),
@Prdo nvarchar(2),
@Cd_MR nvarchar(2),
@Accion varchar(100),
@msj varchar(200) output

AS

--****************************************************************************
-- TEMPORALMENTE HASTA QUE PERMISOS ESTE FINALIZADO	<-- POR DIEGO <12/09/2011>
--****************************************************************************

--Declare @Prdo varchar(2)
Declare @Stx nvarchar(1000)
Declare @Est int Set @Est=0

If(@Cd_MR = '01') -- MOD. VENTAS
Begin	
		if(isnull(@Prdo,'')='')
		Begin
			if(isnull(@RegCtb,'')='')
				Select @Ejer=Eje,@Prdo=Prdo From Venta Where RucE=@RucE and Cd_Vta=@Codigo
			else Set @Prdo = (Select Top 1 Prdo From Venta Where RucE=@RucE and Eje=@Ejer and RegCtb=@RegCtb)
		End
End
Else If(@Cd_MR = '02') -- MOD. COMPRAS
Begin	
		if(isnull(@Prdo,'')='')
		Begin
			if(isnull(@RegCtb,'')='')
				Select @Ejer=Ejer,@Prdo=Prdo From Compra Where RucE=@RucE and Cd_Com=@Codigo
			else Set @Prdo = (Select Top 1 Prdo From Compra Where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
		End
End
Else If(@Cd_MR in ('03','04')) -- MOD. CONTABILIDAD y TESORERIA
Begin	
		if(isnull(@Prdo,'')='')
		Begin
			if(isnull(@RegCtb,'')='')
				Select @Ejer=Ejer,@Prdo=Prdo From Voucher Where RucE=@RucE and Cd_Vou=@Codigo
			else Set @Prdo = (Select top 1 Prdo From Voucher Where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
		End
End
Else
Begin
	Return
End

Print @Prdo

if(isnull(@Prdo,'') <> '')
Begin
	Set @Stx = 'Select @Est=P'+@Prdo+' from Periodo Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''''
	Exec sp_executesql @stx,N'@Est int output',@Est output
	If(@Est=1)
	Begin
		Set @msj = 'No se puede '+@Accion+', periodo se encuentra cerrado'
	End
End

Print @msj

-- Leyenda --
-- Di 14/09/2011 <Creacion del sp>

GO
