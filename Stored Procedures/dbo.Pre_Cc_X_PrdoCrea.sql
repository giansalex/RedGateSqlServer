SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_Cc_X_PrdoCrea]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta nvarchar(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@msj varchar(100) output
as

if not exists (select * from Presupuesto where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)
begin
	if(isnull(len(@NroCta),0) <> 0)
	begin
	begin transaction
		Insert into Presupuesto(RucE,Cd_Psp,Ejer,NroCta,Estado)
		Values(@RucE,dbo.Cod_Psp(@RucE),@Ejer,@NroCta,'1')
	
		if @@rowcount <= 0
		begin
			Set @msj = 'Nro, Cuenta no pudo ser registrada en presupuesto'
			rollback transaction
			return
		end
		else
		begin
			if(isnull(len(@Cd_CC),0) <> 0)
			begin
				Insert into Presupuesto(RucE,Cd_Psp,Ejer,NroCta,Cd_CC,Estado)
				Values(@RucE,dbo.Cod_Psp(@RucE),@Ejer,@NroCta,@Cd_CC,'1')
	
				if @@rowcount <= 0
				begin
					Set @msj = 'CCostos, no pudo ser registrada en presupuesto'
					rollback transaction
					return
				end
				else
				begin
					if(isnull(len(@Cd_SC),0) <> 0)
					begin
						Insert into Presupuesto(RucE,Cd_Psp,Ejer,NroCta,Cd_CC,Cd_SC,Estado)
						Values(@RucE,dbo.Cod_Psp(@RucE),@Ejer,@NroCta,@Cd_CC,@Cd_SC,'1')
	
						if @@rowcount <= 0
						begin
							Set @msj = 'Sub.CCostos, no pudo ser registrada en presupuesto'
							rollback transaction
							return
						end
						else
						begin
							if(isnull(len(@Cd_SS),0) <> 0)
							begin
								Insert into Presupuesto(RucE,Cd_Psp,Ejer,NroCta,Cd_CC,Cd_SC,Cd_SS,Estado)
								Values(@RucE,dbo.Cod_Psp(@RucE),@Ejer,@NroCta,@Cd_CC,@Cd_SC,@Cd_SS,'1')
			
								if @@rowcount <= 0
								begin
									Set @msj = 'Sub.Sub.CCostos, no pudo ser registrada en presupuesto'
									rollback transaction
									return
								end
							end
						end
					end
				end
			end
		end
	commit transaction
	end
end
else if not exists(select * from Presupuesto where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta and Cd_CC=@Cd_CC)
begin
	if(isnull(len(@Cd_CC),0) <> 0)
	begin
	begin transaction
		Insert into Presupuesto(RucE,Cd_Psp,Ejer,NroCta,Cd_CC,Estado)
		Values(@RucE,dbo.Cod_Psp(@RucE),@Ejer,@NroCta,@Cd_CC,'1')

		if @@rowcount <= 0
		begin
			Set @msj = 'CCostos, no pudo ser registrada en presupuesto'
			rollback transaction
			return
		end
		else
		begin
			if(isnull(len(@Cd_SC),0) <> 0)
			begin
				Insert into Presupuesto(RucE,Cd_Psp,Ejer,NroCta,Cd_CC,Cd_SC,Estado)
				Values(@RucE,dbo.Cod_Psp(@RucE),@Ejer,@NroCta,@Cd_CC,@Cd_SC,'1')

				if @@rowcount <= 0
				begin
					Set @msj = 'Sub.CCostos, no pudo ser registrada en presupuesto'
					rollback transaction
					return
				end
				else
				begin
					if(isnull(len(@Cd_SS),0) <> 0)
					begin
						Insert into Presupuesto(RucE,Cd_Psp,Ejer,NroCta,Cd_CC,Cd_SC,Cd_SS,Estado)
						Values(@RucE,dbo.Cod_Psp(@RucE),@Ejer,@NroCta,@Cd_CC,@Cd_SC,@Cd_SS,'1')
	
						if @@rowcount <= 0
						begin
							Set @msj = 'Sub.Sub.CCostos, no pudo ser registrada en presupuesto'
							rollback transaction
							return
						end
					end
				end
			end
		end
	commit transaction
	end
end
else if not exists(select * from Presupuesto where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC)
begin
	if(isnull(len(@Cd_SC),0) <> 0)
	begin
	begin transaction
		Insert into Presupuesto(RucE,Cd_Psp,Ejer,NroCta,Cd_CC,Cd_SC,Estado)
		Values(@RucE,dbo.Cod_Psp(@RucE),@Ejer,@NroCta,@Cd_CC,@Cd_SC,'1')

		if @@rowcount <= 0
		begin
			Set @msj = 'Sub.CCostos, no pudo ser registrada en presupuesto'
			rollback transaction
			return
		end
		else
		begin
			if(isnull(len(@Cd_SS),0) <> 0)
			begin
				Insert into Presupuesto(RucE,Cd_Psp,Ejer,NroCta,Cd_CC,Cd_SC,Cd_SS,Estado)
				Values(@RucE,dbo.Cod_Psp(@RucE),@Ejer,@NroCta,@Cd_CC,@Cd_SC,@Cd_SS,'1')

				if @@rowcount <= 0
				begin
					Set @msj = 'Sub.Sub.CCostos, no pudo ser registrada en presupuesto'
					rollback transaction
					return
				end
			end
		end
	commit transaction
	end
end
else if not exists(select * from Presupuesto where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC and Cd_SS=@Cd_SS)
begin
	if(isnull(len(@Cd_SS),0) <> 0)
	begin
	begin transaction
		Insert into Presupuesto(RucE,Cd_Psp,Ejer,NroCta,Cd_CC,Cd_SC,Cd_SS,Estado)
		Values(@RucE,dbo.Cod_Psp(@RucE),@Ejer,@NroCta,@Cd_CC,@Cd_SC,@Cd_SS,'1')

		if @@rowcount <= 0
		begin
			Set @msj = 'Sub.Sub.CCostos, no pudo ser registrada en presupuesto'
			rollback transaction
			return
		end
	commit transaction
	end
end

-- Leyenda --
-- DI : 08/01/10 <Creacion del procedimiento almacenado>

GO
