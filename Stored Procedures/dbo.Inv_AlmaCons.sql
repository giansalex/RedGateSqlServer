SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AlmaCons]
@RucE nvarchar(11),
@Padre varchar(20),
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from UnidadMedida)
	set @msj = 'No se encontro Unidad de medidad'
else*/
begin
	--Consulta general--
	if(@TipCons=0)
		begin
			if(isnull(len(@Padre),0) = 0)
				begin
					select a1.RucE,a1.Cd_Alm,a1.Codigo,a1.Nombre,a1.NCorto, a1.Ubigeo,a1.Direccion,a1.Encargado,a1.Telef,a1.Capacidad,a1.Obs, a1.Estado,a1.IB_EsVi,a1.CA01,a1.CA02,a1.CA03,a1.CA04,a1.CA05,count(a2.Cd_Alm) as Hijo
					from Almacen as a1 left join Almacen a2 On a2.RucE=a1.RucE and left(a2.Cd_Alm,len(a1.Cd_Alm)) = a1.Cd_Alm and len(a2.Cd_Alm)=len(a1.Cd_Alm)+2
					Where a1.RucE = @RucE and len(a1.Cd_Alm) =3 
					group by a1.RucE,a1.Cd_Alm,a1.Codigo,a1.Nombre,a1.NCorto, a1.Ubigeo,a1.Direccion,a1.Encargado,a1.Telef,a1.Capacidad,a1.Obs, a1.Estado,a1.IB_EsVi,a1.CA01,a1.CA02,a1.CA03,a1.CA04,a1.CA05
				end
			else 
				begin
					select a1.RucE,a1.Cd_Alm,a1.Codigo,a1.Nombre,a1.NCorto, a1.Ubigeo,a1.Direccion,a1.Encargado,a1.Telef,a1.Capacidad,a1.Obs, a1.Estado,a1.IB_EsVi,a1.CA01,a1.CA02,a1.CA03,a1.CA04,a1.CA05,count(a2.Cd_Alm) as Hijo
					from Almacen as a1 left join Almacen a2 On a2.RucE=a1.RucE and left(a2.Cd_Alm,len(a1.Cd_Alm)) = a1.Cd_Alm and len(a2.Cd_Alm)=len(a1.Cd_Alm)+2
					where a1.RucE=@RucE and a1.Cd_Alm like @Padre+'%' and len(a1.Cd_Alm)=len(@Padre)+2
					group by a1.RucE,a1.Cd_Alm,a1.Codigo,a1.Nombre,a1.NCorto, a1.Ubigeo,a1.Direccion,a1.Encargado,a1.Telef,a1.Capacidad,a1.Obs, a1.Estado,a1.IB_EsVi,a1.CA01,a1.CA02,a1.CA03,a1.CA04,a1.CA05
				end
		end
	--Consulta para el comobox con estado=1--
	else if(@TipCons=1)
		begin
			select Cd_Alm+'  |  '+Nombre,Cd_Alm,Nombre from Almacen where Estado=1 and RucE = @RucE and Estado = 1
		end
	--Consulta general con estado=1--
	else if(@TipCons=2)
		begin
			select RucE,Cd_Alm,Codigo,Nombre,NCorto, Ubigeo,Direccion,Encargado,Telef,Capacidad,Obs, Estado,IB_EsVi,CA01,CA02,CA03,CA04,CA05  from Almacen where Estado=1 and RucE = @RucE and Estado = 1
		end
	--Consulta para la ayuda con estado=1--
	else if(@TipCons=3)
		begin
			if(isnull(len(@Padre),0) = 0)
				begin
					select a1.Cd_Alm,a1.Cd_Alm, a1.Nombre + '  ('+convert(varchar,count(a2.Cd_Alm)) + ')' as Nombre
					from Almacen as a1  left join Almacen a2 On a2.RucE=a1.RucE and left(a2.Cd_Alm,len(a1.Cd_Alm)) = a1.Cd_Alm and len(a2.Cd_Alm)=len(a1.Cd_Alm)+2
					Where a1.RucE = @RucE and len(a1.Cd_Alm) =3 and a1.Estado = 1
					group by a1.Cd_Alm,a1.Nombre order by a1.Cd_Alm
				end
			else 
				begin
					select a1.Cd_Alm,a1.Cd_Alm,a1.Nombre + '  ('+convert(varchar,count(a2.Cd_Alm)) + ')' as Nombre
					from Almacen as a1 left join Almacen a2 On a2.RucE=a1.RucE and left(a2.Cd_Alm,len(a1.Cd_Alm)) = a1.Cd_Alm and len(a2.Cd_Alm)=len(a1.Cd_Alm)+2
					where a1.RucE=@RucE and a1.Cd_Alm like @Padre+'%' and len(a1.Cd_Alm)=len(@Padre)+2 and a1.Estado = 1
					group by a1.Cd_Alm,a1.Nombre order by a1.Cd_Alm
				end
		end
end
print @msj

-- Leyenda --
-- PP : 2010-02-12 : <Creacion del procedimiento almacenado>

GO
