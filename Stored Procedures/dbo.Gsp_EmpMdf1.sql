SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_EmpMdf1]
@Ruc nvarchar(11),
@RSocial varchar(100),
@FecIni smalldatetime,
@Ubigeo nvarchar(6),
@Direccion varchar(100),
@Telef varchar(15),
@Logo image,
@Cd_MdaP nvarchar(2),
@Cd_MdaS nvarchar(2),
@CA01 varchar(8000),
@CA02 varchar(8000),
@CA03 varchar(8000),
@CA04 varchar(8000),
@CA05 varchar(8000),
@msj varchar(100) output
as
if not exists (select * from Empresa Where Ruc=@Ruc)
	set @msj = 'Empresa no existe'
else
begin
	update Empresa set Ruc=@Ruc, RSocial=@RSocial, FecIni=@FecIni, Ubigeo=@Ubigeo, 
                           Direccion=@Direccion, Telef=@Telef, Logo=@Logo, Cd_MdaP=@Cd_MdaP, Cd_MdaS=@Cd_MdaS,
                           CA01=@CA01, CA02=@CA02, CA03=@CA03, CA04=@CA04, CA05=@CA05
			Where Ruc=@Ruc
	if @@rowcount <= 0
		set @msj = 'Empresa no pudo ser modificado'
end
print @msj
GO
