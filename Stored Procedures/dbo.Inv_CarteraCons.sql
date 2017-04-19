SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin
	--Consulta general--
	if(@TipCons=0)
	begin
		select * from CarteraProd Where RucE=@RucE
	end
		--Consulta para el combobox con estado=1--
		else if(@TipCons=1)
		begin
			select Cd_Ct+'  |  '+Descrip,Cd_Ct,Descrip from CarteraProd where Estado=1
		end
			--Consulta general con estado=1--
			else if(@TipCons=2)
			begin
				select * from CarteraProd where Estado=1
			end
				--Consulta para la ayuda con estado=1--
				else if(@TipCons=3)
				begin
					select Cd_Ct,Cd_Ct,Descrip from CarteraProd where Estado=1
				end

end
print @msj

GO
