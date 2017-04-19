SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[NroChke](@RucE nvarchar(11), @Ejer varchar(4), @NroCta nvarchar(20))
returns varchar(30) AS
begin 

	declare @c varchar(30)
	declare @i bigint
	select @c = MAX(NroChke) from Voucher 
	where RucE=@RucE and Ejer=@Ejer and (Cd_Fte = 'CB' or Cd_Fte = 'LD') and NroCta=@NroCta
	and LEFT(NroChke,2) != 'CB' and LEFT(NroChke,2) != 'LD'
	
	if @c is null or @c='' or @c='0' 
		set @c='1'
	else
	begin
	
		--Set @i = CONVERT(int, @c) -- ANTERIOR
		
		-- AGREADO POR DIEGO PARA VALIDAR SI ES NUMERO O TEXTO
		-- **********************************************************************
		Declare @ini int Set @ini=len(@c) -- iniciando
		Declare @nuevo varchar(30) Set @nuevo='' --temporal
		Declare @d char(1) Set @d='' -- Caracter
		while(@ini>0)
		Begin
			set @d = substring(@c,@ini,1)
			--Print @d
			if(@d in ('0','1','2','3','4','5','6','7','8','9'))
				Set @nuevo = @d + @nuevo
			else Set @ini=0
				
			Set @ini = @ini-1
		End
		
		-- Resultados
		--Print 'Nro Cheque :' + @nuevo
		--Print 'Dato Ant. -> ' + @c
		Set @c=@nuevo
		--Print 'Dato Nuevo. -> ' + @c
		-- Fin de Resultados
		
		set @i = CONVERT(bigint, @c)
		-- **********************************************************************
		-- FIN DE LA VALIDACION
		
		set @c = (@i+1)
	end
	
	--print 'Nuevo Nro Cheque : ' + @c
	return @c
end

/*
select * from Voucher 
where RucE = '11111111111' and Ejer = '2008' and (Cd_Fte = 'CB' or Cd_Fte = 'LD') and NroCta = '10.4.0.03'
and LEFT(NroChke,2) != 'CB' and LEFT(NroChke,2) != 'LD'
--41951739

declare @f nvarchar(20)
set @f = dbo.NroChke('11111111111', '2008', '10.4.0.03')
print @f
*/

GO
