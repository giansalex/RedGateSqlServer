SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cod_Cte2](@RucE nvarchar(11))
returns nvarchar(7) AS
begin 
	declare @c nvarchar(7), @n int,  @prefijo varchar(3)
	select @c =  count(Cd_Aux) from Cliente where RucE=@RucE
	if @c=0
		set @c='CLT0001'
	else
		begin
			set @prefijo = 'C'		
  		 	select @c=max(Cd_Aux) from Cliente where RucE=@RucE and left(Cd_Aux,1)=@prefijo and right(left(Cd_Aux,2),1)in ('0','1','2','3','4','5','6','7','8','9')
			if @c is null
			begin
				set @prefijo = 'CLI'  	
	  		 	select @c=max(Cd_Aux) from Cliente where RucE=@RucE and left(Cd_Aux,3)=@prefijo
				if @c is null
					begin
						set @prefijo ='CLT'
					   	select @c=max(Cd_Aux) from Cliente where RucE=@RucE and left(Cd_Aux,3)=@prefijo
						if right(@c,4) ='9999'
							begin						
								set @c = 'CLI0000'
							end
						else
						begin
							set @c= right(@c,4)  --> solo es necesario si lleva una letra adelante
							set @n =convert(int, @c)+1
							set @c =@prefijo+ right('0000'+ltrim(str(@n)),4)
						end
					end
				else
					if right(@c,4) ='9999'
						set @c = 'C000001'
					else
					begin
						set @c= right(@c,4)  --> solo es necesario si lleva una letra adelante
						set @n =convert(int, @c)+1
						set @c =@prefijo+ right('0000'+ltrim(str(@n)),4)
					end
			end
			else
				begin
					set @c= right(@c,6)  --> solo es necesario si lleva una letra adelante
					set @n =convert(int, @c)+1
					set @c =@prefijo+ right('000000'+ltrim(str(@n)),6)
				end

		end
	return @c
end




GO
