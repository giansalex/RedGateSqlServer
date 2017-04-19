SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Cfg_CfgNivelAut_Crea]
@Id_Aut int,
@Niv int, 
@Descrip varchar (100),
@IB_AutComNiv bit,
@IB_Hab bit,
@Id_Niv int output,
@msj varchar(100) output
as
	if not exists (select Id_Aut from CfgAutorizacion where Id_Aut = @Id_Aut)
	begin
		set @msj = 'No existe la autorizacion'
		set @Id_Niv = 0
	end
	else
	begin
		set @Id_Niv = dbo.Id_Niv()
		insert into CfgNivelAut (Id_Niv, Id_Aut, Niv, Descrip, IB_AutComNiv, IB_Hab)
		values (@Id_Niv, @Id_Aut, @Niv, @Descrip, @IB_AutComNiv, @IB_Hab)
		---------------------------------------------------------------------------------------------------------------------
		if (@@rowcount <=0)
		begin
			set @msj = 'El nivel no pudo ser ingresado'
			set @Id_Niv = 0
			return
		end
		---------------------------------------------------------------------------------------------------------------------
		if(@IB_Hab = 1)
		begin
			if exists (select * from CfgNivelAut where Id_Aut = @Id_Aut and Niv < @Niv and IB_Hab = 0)
			begin
				update CfgNivelAut set IB_Hab = 1 where Id_Aut = @Id_Aut
				if (@@rowcount <=0)
					set @msj = 'No se pudo actualizar el estado del nivel'
			end
		end
		--------------------------------------------------------------------------------------------------------------------
	end

-- Leyenda --
-- MM : 2010-01-06    : <Creacion del procedimiento almacenado>
-- MM : 2010-02-03    : <Modf. del procedimiento almacenado> : Se agrego > si niveles anteriores estan deshab. y se agrega uno habilitado-> actuliza los niveles
GO
