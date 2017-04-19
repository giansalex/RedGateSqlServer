SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_UbigeoCons]
@Ubigeo nvarchar(6),
@TipCons int,
@msj varchar(50) output
as
if not exists (select top 1 * from UDepa)
	set @msj = 'No se encontro Departamentos'
else
begin
	if(@TipCons = 0)
		begin
		if(len(@Ubigeo)=0)
			select * from UDepa
			else if(len(@Ubigeo)=2)
				select * from UProv where left(Cd_UPv,2)=@Ubigeo
				else if (len(@Ubigeo)=4)
					select * from UDist where left(Cd_UDt,4)=@Ubigeo
		end
	if(@TipCons = 3)
		begin
		if(len(@Ubigeo)=0)
			select Cd_Udp,Cd_Udp,Nombre from UDepa
			else if(len(@Ubigeo)=2)
				select Cd_UPv,Cd_UPv,Nombre from UProv where left(Cd_UPv,2)=@Ubigeo
				else if (len(@Ubigeo)=4)
					select Cd_UDt,Cd_UDt,Nombre from UDist where left(Cd_UDt,4)=@Ubigeo
		end
end
Print @msj
GO
