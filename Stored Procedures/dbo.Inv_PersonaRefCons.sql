SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PersonaRefCons]--Consulta de datos de Persona referencia
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin
		--Consulta general--
		if(@TipCons=0)
		begin
			select 
				ref.RucE,ref.Cd_Clt as Cd_Cte,ref.Cd_Per,ref.Cd_TDI,td.Descrip as DescripTDI,
				ref.NDoc,RTrim(ref.ApPat)+' '+RTrim(ref.ApMat)+' '+RTrim(ref.Nom) as Nombre,
				ref.Cd_Vin,vin.Descrip as DescripVin
			from 
				PersonaRef ref
				Left join TipDocIdn td on td.Cd_TDI = ref.Cd_TDI
				Left join Vinculo vin on vin.RucE=ref.RucE and vin.Cd_Vin=ref.Cd_Vin
			Where 
				ref.RucE=@RucE
		
		end
		--Consulta para el comobox con estado=1--
		else if(@TipCons=1)
		begin
			select 	Cd_Per+'  |  '+Isnull(ApPat,'')+' '+IsNull(ApMat,'')+' '+IsNull(Nom,'') as CodNom,
				Cd_Per,ApPat+' '+ApMat+' '+Nom as Nombre 
			from PersonaRef 
			where RucE=@RucE
		end
		--Consulta general con estado=1--
		else if(@TipCons=2)
			begin
				select 
					ref.RucE,ref.Cd_Clt as Cd_Cte,ref.Cd_Per,ref.Cd_TDI,td.Descrip,ref.NDoc,
					ref.ApPat+' '+ref.ApMat+' '+ref.Nom as Nombre,ref.Cd_Vin,vin.Descrip
				from 
					PersonaRef ref
					Left join TipDocIdn td on td.Cd_TDI = ref.Cd_TDI and td.Estado=1
					Left join Vinculo vin on vin.RucE=ref.RucE and vin.Cd_Vin=ref.Cd_Vin and vin.Estado=1

				Where 
					ref.RucE=@RucE
			end
		--Consulta para la ayuda con estado=1--
		else if(@TipCons=3)
			begin
				select Cd_Per,Cd_Per,IsNull(ApPat,'')+' '+IsNull(ApMat,'')+' '+IsNull(Nom,'') as Nombre from PersonaRef 
				where RucE=@RucE
			end

end
print @msj

GO
