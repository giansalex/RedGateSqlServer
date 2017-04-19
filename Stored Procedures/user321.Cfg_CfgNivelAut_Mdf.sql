SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Cfg_CfgNivelAut_Mdf]
@Id_Niv int,
@Descrip varchar (100),
@IB_AutComNiv bit,
@IB_Hab bit,
@msj varchar(100) output
as
	if not exists (select * from CfgNivelAut where Id_Niv = @Id_Niv)
	begin
		set @msj = 'No existe el nivel'
		return
	end	

	if(@IB_Hab = 0)
	begin
		declare @idAut int
		declare @niv int	
		
		select @idAut = Id_Aut, @niv = Niv from CfgNivelAut where Id_Niv = @Id_Niv
		if exists (select * from CfgNivelAut where Id_Aut = @idAut and Niv > @niv and IB_Hab = 1)
		begin
			set @msj = 'No puede desabilitar el nivel. Existen niveles superiores habilitados.'
			return
		end
	end	

	--Existe el nivel y se valido el identificador de habilitacion
	update CfgNivelAut
	set Descrip = @Descrip, IB_AutComNiv = @IB_AutComNiv, IB_Hab = @IB_Hab
	where Id_Niv = @Id_Niv
	
	if(@IB_Hab = 1)	
	begin
		update CfgNivelAut 
		set IB_Hab = 1
		where Id_Aut = (select Id_Aut from CfgNivelAut where Id_Niv = @Id_Niv)
		and Niv < (select Niv from CfgNivelAut where Id_Niv = @Id_Niv)
	end

-- Leyenda --
-- MM : 2010-01-06    : <Creacion del procedimiento almacenado>
-- MM : 2010-02-03    : <Modif. del procedimiento almacenado>
GO
