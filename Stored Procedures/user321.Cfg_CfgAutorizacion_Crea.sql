SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Cfg_CfgAutorizacion_Crea]
@RucE nvarchar(11),
@Cd_DMA char(2),
@IB_Hab bit,
@Tipo int,
@DescripTip varchar(100),
@msj varchar(100) output,
@Id_Aut int output
as
	if not exists (select Ruc from Empresa where Ruc = @RucE)
		set @msj = 'No existe la empresa'
	else
	begin
		if not exists (select Cd_DMA from DocMovAUts where Cd_DMA = @Cd_DMA)
		begin
			set @msj = 'No existe el documento a autorizar'
			set @Id_Aut = 0
		end
		else 
		begin
			set @Id_Aut = dbo.Id_Aut()
			insert into CfgAutorizacion (Id_Aut, RucE, Cd_DMA, IB_Hab,Tipo,DescripTip)
			values (@Id_Aut, @RucE, @Cd_DMA, @IB_Hab,@Tipo,@DescripTip)
			
			if @@rowcount <=0
			begin
				set @msj = 'La autorizacion no pudo ser ingresada'
				set @Id_Aut = 0
			end
		end
	end

-- Leyenda --
-- MM : 2010-01-05    : <Creacion del procedimiento almacenado>

GO
