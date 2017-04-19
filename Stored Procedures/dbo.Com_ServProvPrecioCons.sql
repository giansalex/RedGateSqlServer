SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ServProvPrecioCons]
@RucE nvarchar(11),
@Cd_Prv nvarchar(10),
@Cd_Srv char(7),
@msj varchar(100) output
as
declare @check bit
set @check = 0

declare @tip char(1)

if(LEFT(@Cd_Prv,3) = 'PRV')
	set @tip = 'C'
else
	set @tip = 'V'
	
if(LEN(@Cd_Prv)>0)
begin
	if(@tip = 'C')
	begin
		select @check as sel ,s.RucE,s.ID_PrecSP,s.Cd_Prv,s.Cd_Srv,convert(Nvarchar,  s.Fecha,103) as Fecha,s.PrecioCom ,s.IB_IncIGV,m.Nombre ,s.Estado, s.Cd_Mda
		from ServProvPrecio s inner join Moneda m on s.Cd_Mda = m.Cd_Mda 
		where s.RucE=@RucE and s.Cd_Prv=@Cd_Prv and s.Cd_Srv = @Cd_Srv
	end
	else
	begin
		select @check as sel ,s.RucE,0 ID_PrecSP,@Cd_Prv Cd_Prv,s.Cd_Srv,convert(Nvarchar,  getdate(),103) as Fecha,s.PVta as PrecioCom ,s.IB_IncIGV,m.Nombre ,s.Estado, s.Cd_Mda
		from PrecioSrv s inner join Moneda m on s.Cd_Mda = m.Cd_Mda 
		where s.RucE=@RucE and s.Cd_Srv = @Cd_Srv
	end
end
else
begin
	select @check as sel ,s.RucE,s.ID_PrecSP,s.Cd_Prv,s.Cd_Srv,convert(Nvarchar,  s.Fecha,103) as Fecha,s.PrecioCom ,s.IB_IncIGV,m.Nombre ,s.Estado, s.Cd_Mda
	from ServProvPrecio s inner join Moneda m on s.Cd_Mda = m.Cd_Mda 
	where s.RucE=@RucE and s.Cd_Srv =@Cd_Srv --and s.Cd_Prv=@Cd_Prv 
end
	
print @msj
-- Leyenda --
-- FL : 2010-08-26 : <Creacion del procedimiento almacenado>
GO
