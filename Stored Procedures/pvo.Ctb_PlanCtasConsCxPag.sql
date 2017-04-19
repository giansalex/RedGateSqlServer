SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_PlanCtasConsCxPag] -- CONSULTA CUENTAS CON INDICADOR CTAS_X_PAGAR
@RucE nvarchar(11),
@Ejer varchar(4),
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from PlanCtas where RucE=@RucE)
	set @msj = 'No se encontro Plan de Cuenta'
else	*/
begin
	if(@TipCons=0)
		select * from PlanCtas where RucE=@RucE and IB_CtasXPag='1' and Ejer=@Ejer
	else if(@TipCons=1)
		select str(NroCta,6,0)+ ' | ' + NomCta as CodNom,NroCta,NomCta  from PlanCtas where RucE=@RucE and IB_CtasXPag='1' and Estado=1 and Ejer=@Ejer
	else if(@TipCons=3)
		select NroCta,NroCta,NomCta from PlanCtas where RucE=@RucE and IB_CtasXPag='1'/*and  len(NroCta)>=9 */ and Estado=1 and Ejer=@Ejer
end
print @msj 

/*
     0: General: select * from Tabla
     1: ComboBox: select CodNom, Cd_Entidad from Tabla where Estado=1
     2: Activos: select * from Tabla where Estado=1
     3: Ayuda: select Cd_Ent,  NroDoc,  Nombre  from Tabla
	--> Ejm.:    AUX0001 20512635025 contaperu
*/

--PV: Vie 19/05/09 creado
GO
