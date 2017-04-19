SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioElim]
@RucE nvarchar(11),
@Id_Prec int,
@msj varchar(100) output
as
if not exists (select * from Precio where RucE=@RucE and Id_Prec = @Id_Prec)
	set @msj = 'Precio no existe'
else
begin
	begin
		if exists(select * from cotizaciondet where RucE=@RucE and Id_Prec in (select Id_Prec from precio where RucE=@RucE and Id_Prec = @Id_Prec))
			set @msj = 'Unidad de Medida no puede ser eliminado, ver cotizaciones relacionadas'
		else
			begin
			begin transaction
			delete preciohist where RucE=@RucE and Id_Prec = @Id_Prec
			delete from precio where RucE=@RucE and Id_Prec = @Id_Prec
			if @@rowcount <= 0
			begin				set @msj = 'Precio no pudo ser eliminado'	
				rollback transaction
			end	
			else
			begin
				if exists (select* from Precio where RucE=@RucE and Id_Prec=@Id_Prec and IB_EsPrin= 1)
					if exists (select* from Precio where RucE=@RucE and Cd_Prod = (select Cd_Prod from Precio where RucE=@RucE and Id_Prec=@Id_Prec) and IB_EsPrin= 0)
						update Precio set IB_EsPrin = 1 where RucE=@RucE and Cd_Prod = (select Cd_Prod from Precio where RucE=@RucE and Id_Prec=@Id_Prec) and Id_Prec = (select top 1 Id_Prec from Precio where RucE=@RucE and Cd_Prod = (select Cd_Prod from Precio where RucE=@RucE and Id_Prec=@Id_Prec) and Id_Prec <> @Id_Prec)
				commit transaction	
			end	
		end
	end
end
print @msj
-- Leyenda --
-- PP : 2010-02-26 		: <Creacion del procedimiento almacenado>
-- PP : 2010-03-19 11:29:56.643	: <Modificacion del procedimiento almacenado por el Id_Prec>
-- PP : 2010-03-20 13:16:20.410	: <Modifacion del procedimiento almacenado por la eliminacion en CASCADA>



GO
