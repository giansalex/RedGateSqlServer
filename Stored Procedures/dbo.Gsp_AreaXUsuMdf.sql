SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Gsp_AreaXUsuMdf]

@RucE nvarchar(11),
@Cd_Area nvarchar(6),
@NomUsu nvarchar(10),
@Estado bit,
@msj varchar(100) output

As

If(@Estado = 1) -- Se Agrego Check
Begin
	If Not Exists (Select * From AreaXUsuario Where RucE=@RucE and Cd_Area=@Cd_Area and NomUsu=@NomUsu)
	Begin
		Insert into AreaXUsuario(RucE,Cd_Area,NomUsu,Estado)
		values(@RucE,@Cd_Area,@NomUsu,1)
	End
	Else
	Begin
		Update AreaXUsuario Set Estado=1 Where RucE=@RucE and Cd_Area=@Cd_Area and NomUsu=@NomUsu 
	End
	
	if @@rowcount <= 0
		Set @msj = 'No se puedo realizar proceso <1->check>'
	
End
Else	-- Se Quito Check
Begin
	If Exists (Select * From AreaXUsuario Where RucE=@RucE and Cd_Area=@Cd_Area and NomUsu=@NomUsu)
	Begin
		Update AreaXUsuario Set Estado=0 Where RucE=@RucE and Cd_Area=@Cd_Area and NomUsu=@NomUsu 
		
		if @@rowcount <= 0
		Set @msj = 'No se puedo realizar proceso <0->check>'
	End
End


-- Leyenda --
-- DI : 16/02/2012 <Creacion del SP>	

GO
