SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cod_Cte](@RucE nvarchar(11))
returns nvarchar(7) AS
begin 
      declare @c nvarchar(7), @n int
      select @c = count(Cd_Aux) from Cliente where RucE=@RucE
 if @c=0
      begin
		if @RucE = '20515124218' --or @RucE='20520727192' --SOLO PARA CEDIVE SAC comentado el ruc de t-apruebo porque llego al tope
		 set @c='CLI0001'
		else if @RucE='20520727192'--SOLO PARA T-APRUEBO // --Agregado--
		 set @c='CTE0001'  --Agregado
		else set @c='CLT0001'

      end
 else
	begin
		if 	@RucE =  '20515124218' --or @RucE='20520727192'
		   	select @c=max(Cd_Aux) from Cliente where RucE=@RucE and left(Cd_Aux,3)='CLI'
		else if @RucE='20520727192' --SOLO PARA T-APRUEBO // --Agregado--
			select @c=max(Cd_Aux) from Cliente where RucE=@RucE and left(Cd_Aux,3)='CTE' --
		else -- Pa las otras empresas
			select @c=max(Cd_Aux) from Cliente where RucE=@RucE
	
	
		set @c= right(@c,4)  --> solo es necesario si lleva una letra adelante
		set @n =convert(int, @c)+1
		
		if @RucE =  '20515124218' --or @RucE='20520727192' --SOLO PARA CEDIVE SAC
		   set @c ='CLI'+ right('0000'+ltrim(str(@n)),4)
		else if @RucE='20520727192'--SOLO PARA T-APRUEBO// --Agregado--
		  set @c ='CTE'+ right('0000'+ltrim(str(@n)),4)--SOLO PARA T-APRUEBO // --Agregado--
		else set @c ='CLT'+ right('0000'+ltrim(str(@n)),4)

	end
       return @c
end

GO
