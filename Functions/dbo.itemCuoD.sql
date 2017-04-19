SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--sp_help CuotaDet

create function [dbo].[itemCuoD]
(@RucE nvarchar(11),
@Cd_EC int,
@Cd_Cuo int
)
returns int as
begin
	declare @n int
	select @n= count(Item) from CuotaDet where RucE=@RucE and Cd_EC=@Cd_EC and Cd_Cuo=@Cd_Cuo
	if @n=0
		set @n=1
	else
	begin
		select @n=Max(Item) from CuotaDet where RucE=@RucE and Cd_EC=@Cd_EC and Cd_Cuo=@Cd_Cuo
		set @n= @n + 1
	end
		return @n
end
--Leyenda --
--JJ -- 2011-06-17 : <Creacion de la Funcion>
GO
