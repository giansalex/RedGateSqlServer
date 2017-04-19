SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[RegCtb_Inv](@RucE nvarchar(11), @Cd_Area nvarchar(6), @Ejer nvarchar(4), @Prdo nvarchar(2))
returns nvarchar(15) AS
begin 
	declare @c nvarchar(15)
	declare @n int
	declare @AR char(2)

	select @AR = NCorto from Area where RucE=@RucE and Cd_Area=@Cd_Area
	select @c = count(RegCtb) from Inventario where RucE=@RucE and Ejer=@Ejer and Cd_Area=@Cd_Area and right(left(RegCtb,9),2) = @Prdo
	if @c=0
		set @c= 'IN'+@AR+'_LD'+@Prdo+ '-00001'
	else
	begin
		select @n=convert(int, max(right(RegCtb,5)))+1 from Inventario where RucE=@RucE and Ejer=@Ejer and Cd_Area=@Cd_Area and right(left(RegCtb,9),2) = @Prdo
		set @c = 'IN'+@AR+'_LD'+@Prdo+'-'+right('00000'+ltrim(str(@n)), 5)
	end
	return @c
end
--
-- PRUEBAS
/*

declare
@RegCtb nvarchar(15)
print  dbo.RegCtb_Inv('20513272848', '010101', '2011',  right('00'+convert(nvarchar,month('03/05/2011')), 2) )


select * from Area where RUcE = '20513272848'
*/

GO
