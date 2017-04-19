SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PersonaRefConsUn]--Consulta x vinculo para Persona referencia
@RucE nvarchar(11),
@Cd_Clt char(10),--Nuevo ver Leyenda
@Cd_Per char(7),
@msj varchar(100) output
as
if not exists (select * from PersonaRef where RucE= @RucE and Cd_Clt = @Cd_Clt and Cd_Per=@Cd_Per)--Modificado
	set @msj = 'Persona de Referencia no existe'
else	
	--select * from PersonaRef
	select 
		ref.RucE,ref.Cd_Clt as CodCli,c.RSocial,ref.Cd_Per as CodPer,ref.Cd_TDI as CodTDI,td.Descrip as DescripTDI,--Modificado
		ref.NDoc,RTrim(ref.ApPat)as ApPat,RTrim(ref.ApMat)as ApMat,RTrim(ref.Nom)as Nom,
		ref.Cd_Vin as CodVin,RTrim(vin.Descrip) as DescripVin,ref.CA01,ref.CA02,ref.CA03,ref.CA04,ref.CA05,
		case(isnull(len(c.RSocial),0)) when 0 then c.ApPat +' '+ c.ApMat +','+ c.Nom 
		else c.RSocial end as Nomb_Clt
	from 
		PersonaRef ref
		Left join TipDocIdn td on td.Cd_TDI = ref.Cd_TDI
		Left join Vinculo vin on vin.RucE=ref.RucE and vin.Cd_Vin=ref.Cd_Vin
		--Left join Auxiliar aux on aux.Cd_Aux = ref.Cd_Cte /*and aux.NDoc = ref.NDoc*/ and aux.RucE = ref.RucE
		Left join Cliente2 c on c.Cd_Clt = ref.Cd_Clt and c.RucE = ref.RucE--Nuevo
	Where 
		ref.RucE= @RucE and ref.Cd_Per=@Cd_Per and ref.Cd_Clt = @Cd_Clt
		
-- Leyenda

-- CAM JUE 16/09/2010 
--	Modificaciones PR03 RA01: Se agrego un parametro @Cd_Clt en Linea 3 y Linea 7 
--			Se cambio la tabla 'axu' por 'c' en la Linea 12 Columna 33
--			Se Quito la tabla Auxiliar Linea 19
--			Se Agrego la tabla Cliente2 Linea 20
--			No tenia datos la tabla PersonaRef


GO
