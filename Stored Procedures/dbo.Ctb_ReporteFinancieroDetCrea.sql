SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[Ctb_ReporteFinancieroDetCrea]

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


if exists (Select * From ReporteFinancieroDet Where RucE=@RucE and Ejer=@Ejer and Cd_REF=@Cd_REF and Cd_Rub=@Cd_Rub)
	Set @msj = 'Existe otro registro con el mismo codigo'
else
begin
	insert into ReporteFinancieroDet(RucE,Ejer,Cd_REF,Cd_Rub,Nombre,Predecesor,RefPorc,Nivel,Formula,IB_esTitulo,IB_verPlanCta,Estado)
	values(@RucE,@Ejer,@Cd_REF,@Cd_Rub,@Nombre,@Predecesor,@RefPorc,@Nivel,@Formula,@IB_esTitulo,@IB_verPlanCta,@Estado)

	if @@rowcount <= 0
		Set @msj = 'No se pudo registrar informacion'
end
-- Leyenda --
-- DI : 10/09/2012 <Creacion del SP>
-- DI : 15/10/2012 <Se Agrego Columna @RefPorc>

GO
