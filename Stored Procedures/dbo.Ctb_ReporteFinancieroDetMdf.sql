SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[Ctb_ReporteFinancieroDetMdf]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_REF nvarchar(5),
@Cd_Rub nvarchar(5),
@Nombre	varchar(100),
@Predecesor	nvarchar(5),
@RefPorc nvarchar(5),
@Nivel smallint,
@Formula varchar(50),
@IB_esTitulo bit,	
@IB_verPlanCta bit,
@Estado	bit,

@msj varchar(100) output		

AS


if not exists (Select * From ReporteFinancieroDet Where RucE=@RucE and Ejer=@Ejer and Cd_REF=@Cd_REF and Cd_Rub=@Cd_Rub)
	Set @msj = 'No existe registro para poder modificar'
else
begin
	
	update ReporteFinancieroDet set
		Nombre=@Nombre,
		Predecesor=@Predecesor,
		RefPorc=@RefPorc,
		Nivel=@Nivel,
		Formula=@Formula,
		IB_esTitulo=@IB_esTitulo,
		IB_verPlanCta=@IB_verPlanCta,
		Estado=@Estado
	Where
		RucE=@RucE
		and Ejer=@Ejer
		and Cd_REF=@Cd_REF
		and Cd_Rub=@Cd_Rub

	if @@rowcount <= 0
		Set @msj = 'No se pudo modificar informacion'
end
-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>
-- DI : 15/10/2012 <Se Agrego Columna @RefPorc>

GO
