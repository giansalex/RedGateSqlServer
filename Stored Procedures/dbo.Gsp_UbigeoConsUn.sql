SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_UbigeoConsUn]
@Ubigeo nvarchar(6),
@msj varchar(50) output
as
begin
if(len(@Ubigeo)=2)
	select Cd_UDp,Nombre,Estado from UDepa where Cd_Udp=@Ubigeo
	else if(len(@Ubigeo)=4)
		select a.Cd_UPv,b.Nombre+' - '+a.Nombre as Nombre,a.Estado from UProv a, UDepa b where a.Cd_UPv=@Ubigeo and b.Cd_UDp=left(a.Cd_UPv,2)
		else if(len(@Ubigeo)=6)
			select a.Cd_UDt,c.Nombre+' - '+b.Nombre+' - '+a.Nombre as Nombre,a.Estado from UDist a, UProv b, UDepa c where a.Cd_UDt=@Ubigeo and c.Cd_UDp=left(a.Cd_UDt,2) and b.Cd_UPv=left(a.Cd_UDt,4)
end
Print @msj
GO
