SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasCons2]
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
	begin	
		select top 5
			RucE,NroCta,NomCta,Nivel,
			IB_Aux,isnull(IB_NDoc,0) As IB_NDoc,IB_CC,IB_DifC,IB_GCB,IB_Psp,IB_CtasXCbr,IB_CtasXPag,
			IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,
			Cd_Blc,Cd_EGPF,Cd_EGPN,
			IB_CtaD,IC_ASM,IC_ACV,Estado,Cd_Mda
			,IC_IEN,IC_IEF
		from PlanCtas where RucE=@RucE and Ejer=@Ejer
	end
	else if(@TipCons=1)
		select str(NroCta,6,0)+ ' | ' + NomCta as CodNom,NroCta,NomCta  from PlanCtas where RucE=@RucE and Ejer=@Ejer
	else if(@TipCons=3)
		select NroCta,NroCta,NomCta from PlanCtas where RucE=@RucE /*and  len(NroCta)>=9 */ and Estado=1 and Ejer=@Ejer and len(NroCta)>7
end
print @msj 

/*
     0: General: select * from Tabla
     1: ComboBox: select CodNom, Cd_Entidad from Tabla where Estado=1
     2: Activos: select * from Tabla where Estado=1
     3: Ayuda: select Cd_Ent,NroDoc,Nombre from Tabla
*/

----------------------PRUEBA------------------------
--exec Ctb_PlanCtasCons2 '11111111111','2010',3,null

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
--PV: Jue 29/01/09
--PV: Jue 02/02/09
--J : Jue 17/12/09 -> Se agrego el campo Cd_Mda
-- FL: 17/09/2010 <se agrego ejercicio>
-- FL: 23/03/2011 <al TipCons=3 se agrego la condicion and len(NroCta)>7 que solicito el señor Juan, que solo carguen los de nivel 4>

GO
